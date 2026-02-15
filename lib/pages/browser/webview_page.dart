import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/logger.dart';
import 'package:aegis/db/user_app_db_isar.dart';
import 'package:aegis/pages/browser/nip07_handlers.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const WebViewPage({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  String? _currentUrl;
  bool _isFavorite = false;
  bool _canGoBack = false;
  bool _canGoForward = false;

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.url;
    _initializeWebView();
    _loadFavoriteStatus();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) async {
            if (!mounted) return;
            // Update navigation state
            final canGoBack = await _controller.canGoBack();
            final canGoForward = await _controller.canGoForward();
            if (mounted) {
              setState(() {
                _canGoBack = canGoBack;
                _canGoForward = canGoForward;
              });
            }
          },
          onPageFinished: (String url) async {
            if (!mounted) return;
            setState(() {
              _currentUrl = url;
            });
            // Update navigation state
            if (!mounted) return;
            final canGoBack = await _controller.canGoBack();
            final canGoForward = await _controller.canGoForward();
            if (!mounted) return;
            setState(() {
              _canGoBack = canGoBack;
              _canGoForward = canGoForward;
            });
            if (!mounted) return;
            _injectNIP07();
            if (!mounted) return;
            _loadFavoriteStatus();
          },
        ),
      )
      ..addJavaScriptChannel(
        'NostrBridge',
        onMessageReceived: (JavaScriptMessage message) {
          _handleNostrMessage(message.message);
        },
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  Future<void> _injectNIP07() async {
    if (!mounted) return;
    try {
      // Get current user's public key
      final account = Account.sharedInstance;
      final publicKey = account.currentPubkey;
      
      if (publicKey.isEmpty) {
        AegisLogger.warning('No user logged in, NIP-07 will not be available');
        return;
      }

      // Inject NIP-07 JavaScript code
      final nip07Code = '''
        (function() {
          if (window.nostr) {
            console.log('NIP-07 already exists');
            return;
          }

          let requestId = 0;
          const pendingRequests = new Map();

          window.nostr = {
            getPublicKey: async function() {
              return new Promise((resolve, reject) => {
                const id = requestId++;
                pendingRequests.set(id, { resolve, reject });
                NostrBridge.postMessage(JSON.stringify({
                  method: 'getPublicKey',
                  id: id
                }));
                
                // Timeout after 30 seconds
                setTimeout(() => {
                  if (pendingRequests.has(id)) {
                    pendingRequests.delete(id);
                    reject(new Error('Request timeout'));
                  }
                }, 30000);
              });
            },

            signEvent: async function(event) {
              return new Promise((resolve, reject) => {
                const id = requestId++;
                pendingRequests.set(id, { resolve, reject });
                NostrBridge.postMessage(JSON.stringify({
                  method: 'signEvent',
                  id: id,
                  params: event
                }));
                
                // Timeout after 30 seconds
                setTimeout(() => {
                  if (pendingRequests.has(id)) {
                    pendingRequests.delete(id);
                    reject(new Error('Request timeout'));
                  }
                }, 30000);
              });
            },

            nip04: {
              encrypt: async function(pubkey, plaintext) {
                return new Promise((resolve, reject) => {
                  const id = requestId++;
                  pendingRequests.set(id, { resolve, reject });
                  NostrBridge.postMessage(JSON.stringify({
                    method: 'nip04_encrypt',
                    id: id,
                    params: {
                      public_key: pubkey,
                      content: plaintext
                    }
                  }));
                  
                  setTimeout(() => {
                    if (pendingRequests.has(id)) {
                      pendingRequests.delete(id);
                      reject(new Error('Request timeout'));
                    }
                  }, 30000);
                });
              },

              decrypt: async function(pubkey, ciphertext) {
                return new Promise((resolve, reject) => {
                  const id = requestId++;
                  pendingRequests.set(id, { resolve, reject });
                  NostrBridge.postMessage(JSON.stringify({
                    method: 'nip04_decrypt',
                    id: id,
                    params: {
                      public_key: pubkey,
                      content: ciphertext
                    }
                  }));
                  
                  setTimeout(() => {
                    if (pendingRequests.has(id)) {
                      pendingRequests.delete(id);
                      reject(new Error('Request timeout'));
                    }
                  }, 30000);
                });
              }
            },

            nip44: {
              encrypt: async function(pubkey, plaintext) {
                return new Promise((resolve, reject) => {
                  const id = requestId++;
                  pendingRequests.set(id, { resolve, reject });
                  NostrBridge.postMessage(JSON.stringify({
                    method: 'nip44_encrypt',
                    id: id,
                    params: {
                      public_key: pubkey,
                      content: plaintext
                    }
                  }));
                  
                  setTimeout(() => {
                    if (pendingRequests.has(id)) {
                      pendingRequests.delete(id);
                      reject(new Error('Request timeout'));
                    }
                  }, 30000);
                });
              },

              decrypt: async function(pubkey, ciphertext) {
                return new Promise((resolve, reject) => {
                  const id = requestId++;
                  pendingRequests.set(id, { resolve, reject });
                  NostrBridge.postMessage(JSON.stringify({
                    method: 'nip44_decrypt',
                    id: id,
                    params: {
                      public_key: pubkey,
                      content: ciphertext
                    }
                  }));
                  
                  setTimeout(() => {
                    if (pendingRequests.has(id)) {
                      pendingRequests.delete(id);
                      reject(new Error('Request timeout'));
                    }
                  }, 30000);
                });
              }
            }
          };

          // Handle responses from Flutter
          window.handleNostrResponse = function(response) {
            const data = typeof response === 'string' ? JSON.parse(response) : response;
            const request = pendingRequests.get(data.id);
            if (request) {
              pendingRequests.delete(data.id);
              if (data.error) {
                request.reject(new Error(data.error));
              } else {
                request.resolve(data.result);
              }
            }
          };

          console.log('NIP-07 injected successfully');
        })();
      ''';

      if (!mounted) return;
      await _controller.runJavaScript(nip07Code);
      AegisLogger.info('✅ NIP-07 JavaScript injected');
    } catch (e) {
      AegisLogger.error('❌ Failed to inject NIP-07: $e');
    }
  }

  Future<void> _handleNostrMessage(String message) async {
    if (!mounted) return;
    try {
      final data = json.decode(message);
      final method = data['method'] as String;
      final id = data['id'] as int;
      final params = data['params'];

      final result = await Nip07Handlers.handle(
        method,
        id,
        params,
        widget.url,
        widget.title,
      );

      if (!mounted) return;
      final responseJson = json.encode(result);
      await _controller.runJavaScript('window.handleNostrResponse($responseJson);');
    } catch (e) {
      AegisLogger.error('❌ Error handling Nostr message: $e');
      if (!mounted) return;
      try {
        final errorData = json.decode(message);
        final errorId = errorData['id'] as int? ?? 0;
        final errorResponse = json.encode({
          'id': errorId,
          'error': e.toString(),
        });
        if (!mounted) return;
        await _controller.runJavaScript('window.handleNostrResponse($errorResponse);');
      } catch (_) {
        if (!mounted) return;
        final errorResponse = json.encode({
          'id': 0,
          'error': e.toString(),
        });
        await _controller.runJavaScript('window.handleNostrResponse($errorResponse);');
      }
    }
  }

  Future<void> _handleBackButton() async {
    if (!mounted) return;
    final canGoBack = await _controller.canGoBack();
    if (canGoBack) {
      if (!mounted) return;
      await _controller.goBack();
      // Update navigation state after going back
      if (!mounted) return;
      final newCanGoBack = await _controller.canGoBack();
      final newCanGoForward = await _controller.canGoForward();
      if (!mounted) return;
      setState(() {
        _canGoBack = newCanGoBack;
        _canGoForward = newCanGoForward;
      });
    } else {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _handleForwardButton() async {
    if (!mounted) return;
    await _controller.goForward();
    // Update navigation state after going forward
    if (!mounted) return;
    final canGoBack = await _controller.canGoBack();
    final canGoForward = await _controller.canGoForward();
    if (!mounted) return;
    setState(() {
      _canGoBack = canGoBack;
      _canGoForward = canGoForward;
    });
  }

  Future<void> _loadFavoriteStatus() async {
    try {
      final currentUrl = _currentUrl ?? widget.url;
      final app = await UserAppDBISAR.getByUrl(currentUrl);
      
      if (mounted) {
        setState(() {
          _isFavorite = app?.isFavorite ?? false;
        });
      }
    } catch (e) {
      AegisLogger.error('Failed to load favorite status: $e');
    }
  }

  /// Try to get favicon URL from common paths
  Future<String> _getFaviconUrl(Uri uri) async {
    final baseUrl = '${uri.scheme}://${uri.host}';
    final commonPaths = [
      '/favicon.ico',
      '/favicon.png',
      '/apple-touch-icon.png',
      '/apple-touch-icon-precomposed.png',
    ];

    // Try each common favicon path
    for (final path in commonPaths) {
      try {
        final faviconUrl = '$baseUrl$path';
        final response = await http.head(Uri.parse(faviconUrl)).timeout(
          const Duration(seconds: 3),
        );
        
        if (response.statusCode == 200) {
          AegisLogger.info('Found favicon at: $faviconUrl');
          return faviconUrl;
        }
      } catch (e) {
        // Continue to next path if this one fails
        continue;
      }
    }

    // Fallback to default favicon.ico path
    AegisLogger.info('Using default favicon path: $baseUrl/favicon.ico');
    return '$baseUrl/favicon.ico';
  }

  Future<void> _toggleFavorite() async {
    try {
      final currentUrl = _currentUrl ?? widget.url;
      final app = await UserAppDBISAR.getByUrl(currentUrl);
      
      if (app != null) {
        // App exists in database, toggle favorite status
        await UserAppDBISAR.toggleFavorite(currentUrl, !_isFavorite);
      } else {
        // App doesn't exist in database, create it with favorite status
        final uri = Uri.tryParse(currentUrl);
        if (uri == null) {
          AegisLogger.error('Invalid URL: $currentUrl');
          return;
        }
        
        final appId = uri.host.isNotEmpty 
            ? uri.host.replaceAll('.', '_') 
            : 'user_app_${DateTime.now().millisecondsSinceEpoch}';
        final appName = uri.host.isNotEmpty 
            ? uri.host 
            : widget.title.isNotEmpty 
                ? widget.title 
                : 'Web App';
        
        // Try to get favicon URL
        final iconUrl = await _getFaviconUrl(uri);
        
        final newApp = UserAppDBISAR(
          appId: appId,
          url: currentUrl,
          name: appName,
          icon: iconUrl,
          description: 'User Added',
          platformsJson: jsonEncode(['web']),
          createTimestamp: DateTime.now().millisecondsSinceEpoch,
          isFavorite: !_isFavorite,
          isPreset: false,
        );
        
        await UserAppDBISAR.saveFromDB(newApp);
      }
      
      if (mounted) {
        setState(() {
          _isFavorite = !_isFavorite;
        });
      }
    } catch (e) {
      AegisLogger.error('Failed to toggle favorite: $e');
    }
  }


  Future<void> _reload() async {
    if (!mounted) return;
    await _controller.reload();
  }

  Widget _buildBottomToolbar() {
    return SafeArea(
      top: false,
      child: Container(
        height: 34,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Go Back button
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: _canGoBack ? _handleBackButton : null,
              iconSize: 24,
              tooltip: 'Go Back',
            ),
            // Go Forward button
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: _canGoForward ? _handleForwardButton : null,
              iconSize: 24,
              tooltip: 'Go Forward',
            ),
            // Bookmark button
            IconButton(
              icon: Icon(_isFavorite ? Icons.star : Icons.star_border),
              onPressed: _toggleFavorite,
              iconSize: 24,
              tooltip: _isFavorite ? 'Unfavorite' : 'Favorite',
            ),
            // Reload button
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _reload,
              iconSize: 24,
              tooltip: 'Reload',
            ),
            // Exit button
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
              iconSize: 24,
              tooltip: 'Exit',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // WebViewController will be automatically disposed by Flutter
    // but we ensure no callbacks are executed after dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            Expanded(
              child: WebViewWidget(controller: _controller),
            ),
            _buildBottomToolbar(),
          ],
        ),
      ),
    );
  }
}

