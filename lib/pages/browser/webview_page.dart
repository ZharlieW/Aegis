import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/logger.dart';
import 'package:aegis/utils/signed_event_manager.dart';
import 'package:aegis/db/user_app_db_isar.dart';
import 'package:nostr_rust/src/rust/api/nostr.dart' as rust_api;

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
            setState(() {
              _currentUrl = url;
            });
            // Update navigation state
            final canGoBack = await _controller.canGoBack();
            final canGoForward = await _controller.canGoForward();
            setState(() {
              _canGoBack = canGoBack;
              _canGoForward = canGoForward;
            });
            _injectNIP07();
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

      await _controller.runJavaScript(nip07Code);
      AegisLogger.info('✅ NIP-07 JavaScript injected');
    } catch (e) {
      AegisLogger.error('❌ Failed to inject NIP-07: $e');
    }
  }

  Future<void> _handleNostrMessage(String message) async {
    try {
      final data = json.decode(message);
      final method = data['method'] as String;
      final id = data['id'] as int;
      final params = data['params'];

      Map<String, dynamic> result;

      switch (method) {
        case 'getPublicKey':
          result = await _handleGetPublicKey(id);
          break;
        case 'signEvent':
          result = await _handleSignEvent(id, params);
          break;
        case 'nip04_encrypt':
          result = await _handleNIP04Encrypt(id, params);
          break;
        case 'nip04_decrypt':
          result = await _handleNIP04Decrypt(id, params);
          break;
        case 'nip44_encrypt':
          result = await _handleNIP44Encrypt(id, params);
          break;
        case 'nip44_decrypt':
          result = await _handleNIP44Decrypt(id, params);
          break;
        default:
          result = {
            'id': id,
            'error': 'Unknown method: $method',
          };
      }

      // Send response back to JavaScript
      final responseJson = json.encode(result);
      await _controller.runJavaScript('window.handleNostrResponse($responseJson);');
    } catch (e) {
      AegisLogger.error('❌ Error handling Nostr message: $e');
      try {
        final errorData = json.decode(message);
        final errorId = errorData['id'] as int? ?? 0;
        final errorResponse = json.encode({
          'id': errorId,
          'error': e.toString(),
        });
        await _controller.runJavaScript('window.handleNostrResponse($errorResponse);');
      } catch (_) {
        // If message is not valid JSON, send a generic error
        final errorResponse = json.encode({
          'id': 0,
          'error': e.toString(),
        });
        await _controller.runJavaScript('window.handleNostrResponse($errorResponse);');
      }
    }
  }

  Future<Map<String, dynamic>> _handleGetPublicKey(int id) async {
    try {
      final account = Account.sharedInstance;
      final publicKey = account.currentPubkey;
      
      if (publicKey.isEmpty) {
        return {
          'id': id,
          'error': 'No user logged in',
        };
      }

      // Record the getPublicKey event for NIP-07
      try {
        // Extract domain from URL for applicationPubkey
        String? applicationPubkey;
        try {
          final uri = Uri.parse(widget.url);
          applicationPubkey = uri.host.isNotEmpty ? uri.host : widget.url;
        } catch (_) {
          applicationPubkey = widget.url;
        }
        
        // Create metadata with connection_type, url, and title
        final metadata = json.encode({
          'connection_type': 'nip07',
          'url': widget.url,
          'title': widget.title,
        });
        
        // Record the getPublicKey event
        await SignedEventManager.sharedInstance.recordSignedEvent(
          eventId: 'get_public_key_${DateTime.now().millisecondsSinceEpoch}',
          eventKind: 0, // Kind 0 for get_public_key
          eventContent: 'get_public_key',
          applicationName: widget.title,
          applicationPubkey: applicationPubkey,
          status: 1,
          metadata: metadata,
        );
        
        AegisLogger.info('✅ Recorded NIP-07 getPublicKey event');
      } catch (e) {
        AegisLogger.error('❌ Failed to record NIP-07 getPublicKey event: $e');
        // Don't fail the getPublicKey if recording fails
      }

      // NIP-07 requires hex format, not npub
      // Return hex public key directly
      return {
        'id': id,
        'result': publicKey,
      };
    } catch (e) {
      AegisLogger.error('❌ Failed to get public key: $e');
      return {
        'id': id,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> _handleSignEvent(int id, dynamic params) async {
    try {
      final account = Account.sharedInstance;
      final privateKey = account.currentPrivkey;
      final publicKey = account.currentPubkey;
      
      if (privateKey.isEmpty || publicKey.isEmpty) {
        return {
          'id': id,
          'error': 'No user logged in',
        };
      }

      // Ensure event has pubkey field
      Map<String, dynamic> eventMap;
      if (params is Map<String, dynamic>) {
        eventMap = Map<String, dynamic>.from(params);
      } else {
        // If params is already a JSON string, parse it
        eventMap = json.decode(params.toString());
      }

      // Add pubkey if missing (required by Rust signEvent)
      if (!eventMap.containsKey('pubkey') || eventMap['pubkey'] == null || (eventMap['pubkey'] as String).isEmpty) {
        eventMap['pubkey'] = publicKey;
      }

      // Convert event to JSON string
      final eventJson = json.encode(eventMap);

      // Sign the event using Rust
      final signedEventJson = await rust_api.signEvent(
        eventJson: eventJson,
        privateKey: privateKey,
      );

      // Parse signed event
      final signedEvent = json.decode(signedEventJson);
      
      // Record the signed event for NIP-07
      try {
        final eventId = signedEvent['id'] as String? ?? '';
        final eventKind = signedEvent['kind'] as int? ?? -1;
        final eventContent = signedEvent['content'] as String? ?? '';
        
        // Skip recording kind 22242 (NIP-42 Client Authentication)
        // This should be handled by remote signer (NIP-46), not NIP-07
        if (eventKind == 22242) {
          AegisLogger.info('⚠️ Skipped recording kind 22242 event via NIP-07 (should use remote signer/NIP-46)');
        } else {
          // Extract domain from URL for applicationPubkey
          String? applicationPubkey;
          try {
            final uri = Uri.parse(widget.url);
            applicationPubkey = uri.host.isNotEmpty ? uri.host : widget.url;
          } catch (_) {
            applicationPubkey = widget.url;
          }
          
          // Create metadata with connection_type, url, and title
          final metadata = json.encode({
            'connection_type': 'nip07',
            'url': widget.url,
            'title': widget.title,
          });
          
          // Record the signed event
          await SignedEventManager.sharedInstance.recordSignedEvent(
            eventId: eventId,
            eventKind: eventKind,
            eventContent: eventContent.isNotEmpty && eventContent.length < 100
                ? eventContent
                : 'Signed Event (Kind $eventKind)',
            applicationName: widget.title,
            applicationPubkey: applicationPubkey,
            status: 1,
            metadata: metadata,
          );
          
          AegisLogger.info('✅ Recorded NIP-07 signed event: $eventId');
        }
      } catch (e) {
        AegisLogger.error('❌ Failed to record NIP-07 signed event: $e');
        // Don't fail the signing if recording fails
      }

      return {
        'id': id,
        'result': signedEvent,
      };
    } catch (e) {
      AegisLogger.error('❌ Failed to sign event: $e');
      return {
        'id': id,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> _handleNIP04Encrypt(int id, dynamic params) async {
    try {
      final account = Account.sharedInstance;
      final privateKey = account.currentPrivkey;
      
      if (privateKey.isEmpty) {
        return {
          'id': id,
          'error': 'No user logged in',
        };
      }

      final publicKey = params['public_key'] as String;
      final plaintext = params['content'] as String;

      final encrypted = await rust_api.nip04Encrypt(
        plaintext: plaintext,
        publicKey: publicKey,
        privateKey: privateKey,
      );

      // Record the NIP-04 encryption event for NIP-07
      try {
        // Extract domain from URL for applicationPubkey
        String? applicationPubkey;
        try {
          final uri = Uri.parse(widget.url);
          applicationPubkey = uri.host.isNotEmpty ? uri.host : widget.url;
        } catch (_) {
          applicationPubkey = widget.url;
        }
        
        // Create metadata with connection_type, url, and title
        final metadata = json.encode({
          'connection_type': 'nip07',
          'url': widget.url,
          'title': widget.title,
          'operation': 'nip04_encrypt',
          'target_pubkey': publicKey,
        });
        
        // Record the encryption event
        await SignedEventManager.sharedInstance.recordSignedEvent(
          eventId: 'nip04_encrypt_${DateTime.now().millisecondsSinceEpoch}',
          eventKind: 4, // Kind 4 for encrypted direct message
          eventContent: 'NIP-04 Encrypted Data',
          applicationName: widget.title,
          applicationPubkey: applicationPubkey,
          status: 1,
          metadata: metadata,
        );
        
        AegisLogger.info('✅ Recorded NIP-07 NIP-04 encryption event');
      } catch (e) {
        AegisLogger.error('❌ Failed to record NIP-07 NIP-04 encryption event: $e');
        // Don't fail the encryption if recording fails
      }

      return {
        'id': id,
        'result': encrypted,
      };
    } catch (e) {
      AegisLogger.error('❌ Failed to encrypt with NIP-04: $e');
      return {
        'id': id,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> _handleNIP04Decrypt(int id, dynamic params) async {
    try {
      final account = Account.sharedInstance;
      final privateKey = account.currentPrivkey;
      
      if (privateKey.isEmpty) {
        return {
          'id': id,
          'error': 'No user logged in',
        };
      }

      final publicKey = params['public_key'] as String;
      final ciphertext = params['content'] as String;

      final decrypted = await rust_api.nip04Decrypt(
        ciphertext: ciphertext,
        publicKey: publicKey,
        privateKey: privateKey,
      );

      // Record the NIP-04 decryption event for NIP-07
      try {
        // Extract domain from URL for applicationPubkey
        String? applicationPubkey;
        try {
          final uri = Uri.parse(widget.url);
          applicationPubkey = uri.host.isNotEmpty ? uri.host : widget.url;
        } catch (_) {
          applicationPubkey = widget.url;
        }
        
        // Create metadata with connection_type, url, and title
        final metadata = json.encode({
          'connection_type': 'nip07',
          'url': widget.url,
          'title': widget.title,
          'operation': 'nip04_decrypt',
          'target_pubkey': publicKey,
        });
        
        // Record the decryption event
        await SignedEventManager.sharedInstance.recordSignedEvent(
          eventId: 'nip04_decrypt_${DateTime.now().millisecondsSinceEpoch}',
          eventKind: 4, // Kind 4 for encrypted direct message
          eventContent: 'NIP-04 Decrypted Data',
          applicationName: widget.title,
          applicationPubkey: applicationPubkey,
          status: 1,
          metadata: metadata,
        );
        
        AegisLogger.info('✅ Recorded NIP-07 NIP-04 decryption event');
      } catch (e) {
        AegisLogger.error('❌ Failed to record NIP-07 NIP-04 decryption event: $e');
        // Don't fail the decryption if recording fails
      }

      return {
        'id': id,
        'result': decrypted,
      };
    } catch (e) {
      AegisLogger.error('❌ Failed to decrypt with NIP-04: $e');
      return {
        'id': id,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> _handleNIP44Encrypt(int id, dynamic params) async {
    try {
      final account = Account.sharedInstance;
      final privateKey = account.currentPrivkey;
      
      if (privateKey.isEmpty) {
        return {
          'id': id,
          'error': 'No user logged in',
        };
      }

      final publicKey = params['public_key'] as String;
      final plaintext = params['content'] as String;

      final encrypted = await rust_api.nip44Encrypt(
        plaintext: plaintext,
        publicKey: publicKey,
        privateKey: privateKey,
      );

      // Record the NIP-44 encryption event for NIP-07
      try {
        // Extract domain from URL for applicationPubkey
        String? applicationPubkey;
        try {
          final uri = Uri.parse(widget.url);
          applicationPubkey = uri.host.isNotEmpty ? uri.host : widget.url;
        } catch (_) {
          applicationPubkey = widget.url;
        }
        
        // Create metadata with connection_type, url, and title
        final metadata = json.encode({
          'connection_type': 'nip07',
          'url': widget.url,
          'title': widget.title,
          'operation': 'nip44_encrypt',
          'target_pubkey': publicKey,
        });
        
        // Record the encryption event
        await SignedEventManager.sharedInstance.recordSignedEvent(
          eventId: 'nip44_encrypt_${DateTime.now().millisecondsSinceEpoch}',
          eventKind: 4, // Kind 4 for encrypted direct message
          eventContent: 'NIP-44 Encrypted Data',
          applicationName: widget.title,
          applicationPubkey: applicationPubkey,
          status: 1,
          metadata: metadata,
        );
        
        AegisLogger.info('✅ Recorded NIP-07 NIP-44 encryption event');
      } catch (e) {
        AegisLogger.error('❌ Failed to record NIP-07 NIP-44 encryption event: $e');
        // Don't fail the encryption if recording fails
      }

      return {
        'id': id,
        'result': encrypted,
      };
    } catch (e) {
      AegisLogger.error('❌ Failed to encrypt with NIP-44: $e');
      return {
        'id': id,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> _handleNIP44Decrypt(int id, dynamic params) async {
    try {
      final account = Account.sharedInstance;
      final privateKey = account.currentPrivkey;
      
      if (privateKey.isEmpty) {
        return {
          'id': id,
          'error': 'No user logged in',
        };
      }

      final publicKey = params['public_key'] as String;
      final ciphertext = params['content'] as String;

      final decrypted = await rust_api.nip44Decrypt(
        ciphertext: ciphertext,
        publicKey: publicKey,
        privateKey: privateKey,
      );

      // Record the NIP-44 decryption event for NIP-07
      try {
        // Extract domain from URL for applicationPubkey
        String? applicationPubkey;
        try {
          final uri = Uri.parse(widget.url);
          applicationPubkey = uri.host.isNotEmpty ? uri.host : widget.url;
        } catch (_) {
          applicationPubkey = widget.url;
        }
        
        // Create metadata with connection_type, url, and title
        final metadata = json.encode({
          'connection_type': 'nip07',
          'url': widget.url,
          'title': widget.title,
          'operation': 'nip44_decrypt',
          'target_pubkey': publicKey,
        });
        
        // Record the decryption event
        await SignedEventManager.sharedInstance.recordSignedEvent(
          eventId: 'nip44_decrypt_${DateTime.now().millisecondsSinceEpoch}',
          eventKind: 4, // Kind 4 for encrypted direct message
          eventContent: 'NIP-44 Decrypted Data',
          applicationName: widget.title,
          applicationPubkey: applicationPubkey,
          status: 1,
          metadata: metadata,
        );
        
        AegisLogger.info('✅ Recorded NIP-07 NIP-44 decryption event');
      } catch (e) {
        AegisLogger.error('❌ Failed to record NIP-07 NIP-44 decryption event: $e');
        // Don't fail the decryption if recording fails
      }

      return {
        'id': id,
        'result': decrypted,
      };
    } catch (e) {
      AegisLogger.error('❌ Failed to decrypt with NIP-44: $e');
      return {
        'id': id,
        'error': e.toString(),
      };
    }
  }

  Future<void> _handleBackButton() async {
    final canGoBack = await _controller.canGoBack();
    if (canGoBack) {
      await _controller.goBack();
      // Update navigation state after going back
      if (mounted) {
        final newCanGoBack = await _controller.canGoBack();
        final newCanGoForward = await _controller.canGoForward();
        setState(() {
          _canGoBack = newCanGoBack;
          _canGoForward = newCanGoForward;
        });
      }
    } else {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _handleForwardButton() async {
    await _controller.goForward();
    // Update navigation state after going forward
    if (mounted) {
      final canGoBack = await _controller.canGoBack();
      final canGoForward = await _controller.canGoForward();
      setState(() {
        _canGoBack = canGoBack;
        _canGoForward = canGoForward;
      });
    }
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

