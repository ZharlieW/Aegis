import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/logger.dart';
import 'package:aegis/utils/signed_event_manager.dart';
import 'package:aegis/utils/local_storage.dart';
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
  bool _isLoading = true;
  String? _currentUrl;
  bool _isFavorite = false;

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
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
              _currentUrl = url;
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
    } else {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _loadFavoriteStatus() async {
    try {
      await LocalStorage.init();
      final account = Account.sharedInstance;
      if (account.currentPubkey.isEmpty) {
        return;
      }

      final key = 'browser_favorites_${account.currentPubkey}';
      final rawFavorites = LocalStorage.get(key);
      
      // Handle different possible types from LocalStorage
      List<String> favorites = [];
      if (rawFavorites != null) {
        if (rawFavorites is List) {
          // Handle List<dynamic>, List<Object?>, List<String>, etc.
          favorites = rawFavorites.map((e) {
            if (e == null) return '';
            return e.toString();
          }).where((e) => e.isNotEmpty).toList();
        } else if (rawFavorites is String) {
          // If it's a string, try to parse it as JSON
          try {
            final decoded = jsonDecode(rawFavorites);
            if (decoded is List) {
              favorites = decoded.map((e) {
                if (e == null) return '';
                return e.toString();
              }).where((e) => e.isNotEmpty).toList();
            } else {
              // If parsing fails or is not a list, treat as single string
              favorites = [rawFavorites];
            }
          } catch (_) {
            // If parsing fails, treat as single string
            favorites = [rawFavorites];
          }
        }
      }
      
      final currentUrl = _currentUrl ?? widget.url;
      if (mounted) {
        setState(() {
          _isFavorite = favorites.contains(currentUrl);
        });
      }
    } catch (e) {
      AegisLogger.error('Failed to load favorite status: $e');
    }
  }

  Future<void> _toggleFavorite() async {
    try {
      await LocalStorage.init();
      final account = Account.sharedInstance;
      if (account.currentPubkey.isEmpty) {
        return;
      }

      final key = 'browser_favorites_${account.currentPubkey}';
      final rawFavorites = LocalStorage.get(key);
      
      // Handle different possible types from LocalStorage
      List<String> favoriteList = [];
      if (rawFavorites != null) {
        if (rawFavorites is List) {
          // Handle List<dynamic>, List<Object?>, List<String>, etc.
          favoriteList = rawFavorites.map((e) {
            if (e == null) return '';
            return e.toString();
          }).where((e) => e.isNotEmpty).toList();
        } else if (rawFavorites is String) {
          // If it's a string, try to parse it as JSON
          try {
            final decoded = jsonDecode(rawFavorites);
            if (decoded is List) {
              favoriteList = decoded.map((e) {
                if (e == null) return '';
                return e.toString();
              }).where((e) => e.isNotEmpty).toList();
            } else {
              // If parsing fails or is not a list, treat as single string
              favoriteList = [rawFavorites];
            }
          } catch (_) {
            // If parsing fails, treat as single string
            favoriteList = [rawFavorites];
          }
        }
      }

      final currentUrl = _currentUrl ?? widget.url;

      if (_isFavorite) {
        favoriteList.remove(currentUrl);
      } else {
        if (!favoriteList.contains(currentUrl)) {
          favoriteList.add(currentUrl);
        }
      }

      // Save as List<String> which LocalStorage.set() supports
      await LocalStorage.set(key, favoriteList);
      if (mounted) {
        setState(() {
          _isFavorite = !_isFavorite;
        });
      }
    } catch (e) {
      AegisLogger.error('Failed to toggle favorite: $e');
    }
  }

  Future<void> _copyUrl() async {
    final url = _currentUrl ?? widget.url;
    await Clipboard.setData(ClipboardData(text: url));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _reload() async {
    await _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleBackButton,
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (String value) {
              switch (value) {
                case 'favorite':
                  _toggleFavorite();
                  break;
                case 'reload':
                  _reload();
                  break;
                case 'copy':
                  _copyUrl();
                  break;
                case 'exit':
                  Navigator.of(context).pop();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'favorite',
                child: Row(
                  children: [
                    Icon(
                      _isFavorite ? Icons.star : Icons.star_border,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(_isFavorite ? 'Unfavorite' : 'Favorite'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'reload',
                child: Row(
                  children: [
                    Icon(Icons.refresh, size: 20),
                    SizedBox(width: 12),
                    Text('Reload'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'copy',
                child: Row(
                  children: [
                    Icon(Icons.copy, size: 20),
                    SizedBox(width: 12),
                    Text('Copy Link'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'exit',
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app, size: 20),
                    SizedBox(width: 12),
                    Text('Exit'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}

