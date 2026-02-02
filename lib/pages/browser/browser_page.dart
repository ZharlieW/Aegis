import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:aegis/navigator/navigator.dart';
import 'package:aegis/utils/logger.dart';
import 'package:aegis/db/user_app_db_isar.dart';
import 'napp_model.dart';
import 'webview_page.dart';

class _AddAppDialog extends StatefulWidget {
  @override
  State<_AddAppDialog> createState() => _AddAppDialogState();
}

class _AddAppDialogState extends State<_AddAppDialog> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final url = _urlController.text.trim();
    final isValidUrl = url.isNotEmpty &&
        (url.startsWith('http://') || url.startsWith('https://'));

    return AlertDialog(
      title: const Text('Add Web App'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'URL *',
                hintText: 'https://example.com',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
              keyboardType: TextInputType.url,
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'App Name (Optional)',
                hintText: 'My App',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: isValidUrl
              ? () {
                  Navigator.of(context).pop({
                    'url': _urlController.text.trim(),
                    'name': _nameController.text.trim(),
                  });
                }
              : null,
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class BrowserPage extends StatefulWidget {
  const BrowserPage({super.key});

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  final TextEditingController _searchController = TextEditingController();
  List<NAppModel> _nappList = [];
  List<NAppModel> _filteredNappList = [];
  String _searchQuery = '';
  Set<String> _favoriteIds = {};

  @override
  void initState() {
    super.initState();
    _loadNappList();
    _loadFavorites();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadNappList() async {
    try {
      // Check if preset apps have been imported
      final isImported = await UserAppDBISAR.isPresetAppsImported();
      
      if (!isImported) {
        // First time: import preset apps from JSON file
        try {
          final String jsonString = await rootBundle.loadString('lib/assets/napp_list.json');
          final List<dynamic> jsonList = jsonDecode(jsonString);
          final List<Map<String, dynamic>> apps = jsonList
              .map((item) => item as Map<String, dynamic>)
              .toList();
          
          await UserAppDBISAR.importPresetApps(apps);
          AegisLogger.info('Imported ${apps.length} preset apps to database');
        } catch (e) {
          AegisLogger.error('Failed to import preset apps: $e');
        }
      }
      
      // Load all apps from database
      final dbApps = await UserAppDBISAR.getAllFromDB();
      _nappList = dbApps.map((dbApp) => _convertFromDBApp(dbApp)).toList();
      
      AegisLogger.info('Loaded ${_nappList.length} app(s) from database');
      
      if (mounted) {
        _applyFilter();
      }
    } catch (e) {
      AegisLogger.error('Failed to load apps: $e');
      // Fallback to empty list
      _nappList = [];
      if (mounted) {
        _applyFilter();
      }
    }
  }

  /// Convert UserAppDBISAR to NAppModel
  NAppModel _convertFromDBApp(UserAppDBISAR dbApp) {
    List<String>? platforms;
    if (dbApp.platformsJson != null && dbApp.platformsJson!.isNotEmpty) {
      try {
        final decoded = jsonDecode(dbApp.platformsJson!);
        if (decoded is List) {
          platforms = decoded.map((e) => e.toString()).toList();
        }
      } catch (_) {
        // Ignore parse errors
      }
    }
    
    Map<String, dynamic> metadata = {};
    if (dbApp.metadataJson != null && dbApp.metadataJson!.isNotEmpty) {
      try {
        metadata = jsonDecode(dbApp.metadataJson!) as Map<String, dynamic>;
      } catch (_) {
        // Ignore parse errors
      }
    }
    
    return NAppModel(
      id: dbApp.appId,
      url: dbApp.url,
      name: dbApp.name,
      icon: dbApp.icon,
      description: dbApp.description,
      platforms: platforms,
      metadata: metadata,
    );
  }

  /// Convert NAppModel to UserAppDBISAR
  UserAppDBISAR _convertToDBApp(NAppModel app, {bool isPreset = false, bool isFavorite = false}) {
    String? platformsJson;
    if (app.platforms != null && app.platforms!.isNotEmpty) {
      platformsJson = jsonEncode(app.platforms);
    }
    
    String? metadataJson;
    if (app.metadata.isNotEmpty) {
      metadataJson = jsonEncode(app.metadata);
    }
    
    return UserAppDBISAR(
      appId: app.id,
      url: app.url,
      name: app.name,
      icon: app.icon,
      description: app.description,
      platformsJson: platformsJson,
      metadataJson: metadataJson,
      createTimestamp: DateTime.now().millisecondsSinceEpoch,
      isPreset: isPreset,
      isFavorite: isFavorite,
    );
  }

  void _onSearchChanged() {
    _searchQuery = _searchController.text;
    _applyFilter();
  }

  void _applyFilter() {
    List<NAppModel> filtered = List.from(_nappList);

    // Filter by platforms - only show web apps
    filtered = filtered.where((napp) {
      // If platforms is null or empty, show for backward compatibility
      if (napp.platforms == null || napp.platforms!.isEmpty) {
        return true;
      }
      // Only show apps that include "web" in their platforms
      return napp.platforms!.contains('web');
    }).toList();

    // Apply search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((napp) {
        return napp.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            napp.description.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    if (mounted) {
      setState(() {
        _filteredNappList = filtered;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browser'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddAppDialog,
            tooltip: 'Add Web App',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _buildNappGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 16),
            child: Icon(
              Icons.search,
              size: 24,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: 'Search Nostr Apps...',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNappGrid() {
    if (_filteredNappList.isEmpty) {
      return Center(
        child: Text(
          _nappList.isEmpty ? 'Loading...' : 'No NApps found',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    // Separate favorites and all apps
    final favorites = _filteredNappList.where((napp) {
      return _favoriteIds.contains(napp.id) || _favoriteIds.contains(napp.url);
    }).toList();

    final allApps = _filteredNappList.where((napp) {
      return !_favoriteIds.contains(napp.id) && !_favoriteIds.contains(napp.url);
    }).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FAVORITES section
          if (favorites.isNotEmpty) ...[
            _buildSectionHeader('FAVORITES', Icons.push_pin),
            _buildAppGrid(favorites),
          ],
          // ALL APPS section
          _buildSectionHeader('ALL APPS', null, topPadding: favorites.isNotEmpty ? 4 : null),
          _buildAppGrid(allApps, showAddButton: false),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData? icon, {double? topPadding}) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: topPadding ?? 8,
        bottom: 8,
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
          ],
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppGrid(List<NAppModel> apps, {bool showAddButton = false}) {
    if (apps.isEmpty && !showAddButton) {
      return const SizedBox.shrink();
    }

    final itemCount = apps.length + (showAddButton ? 1 : 0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 4,
          childAspectRatio: 1.0,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (showAddButton && index == apps.length) {
            return _buildAddButtonItem();
          }
          return _buildNappGridItem(apps[index]);
        },
      ),
    );
  }

  Widget _buildAddButtonItem() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _showAddAppDialog,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: 2,
              ),
            ),
            child: Icon(
              Icons.add,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add App',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            'Tap to add',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNappGridItem(NAppModel napp) {
    final isFavorite = _favoriteIds.contains(napp.id) || _favoriteIds.contains(napp.url);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (napp.url.isNotEmpty) {
          AegisNavigator.pushPage(
            context,
            (context) => WebViewPage(
              url: napp.url,
              title: napp.name,
            ),
          ).then((_) {
            // Reload favorites when returning from webview page
            _loadFavorites();
          });
        }
      },
      onLongPress: () {
        _showDeleteDialog(napp);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // App Icon
          Stack(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildNappIcon(napp),
                ),
              ),
              // Favorite indicator
              if (isFavorite)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.push_pin,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // App Name
          Text(
            napp.name,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          // const SizedBox(height: 2),
          // // Category
          // Text(
          //   napp.description,
          //   style: Theme.of(context).textTheme.bodySmall?.copyWith(
          //         fontSize: 11,
          //         color: Theme.of(context).colorScheme.onSurfaceVariant,
          //       ),
          //   maxLines: 1,
          //   overflow: TextOverflow.ellipsis,
          //   textAlign: TextAlign.center,
          // ),
        ],
      ),
    );
  }

  Widget _buildNappIcon(NAppModel napp) {
    final String iconUrl = napp.iconUrl;
    final Widget fallback = _buildNappIconFallback(napp);

    if (iconUrl.isEmpty) {
      return fallback;
    }

    final Widget iconWidget;
    if (_isSvgUrl(iconUrl)) {
      iconWidget = SvgPicture.network(
        iconUrl,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        placeholderBuilder: (_) => fallback,
        headers: const {
          'User-Agent': 'Mozilla/5.0',
        },
      );
    } else {
      iconWidget = Image.network(
        iconUrl,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => fallback,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            width: 64,
            height: 64,
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.primary,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            ),
          );
        },
        headers: const {
          'User-Agent': 'Mozilla/5.0',
        },
      );
    }

    return iconWidget;
  }

  Widget _buildNappIconFallback(NAppModel napp) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        napp.name.isNotEmpty ? napp.name[0].toUpperCase() : 'N',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  bool _isSvgUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    final path = uri.path.toLowerCase();
    return path.endsWith('.svg') || path.contains('.svg');
  }

  Future<void> _loadFavorites() async {
    try {
      // Load favorite apps from database
      final favoriteApps = await UserAppDBISAR.getFavoriteApps();
      final favoriteUrls = favoriteApps.map((app) => app.url).toSet();
      
      if (mounted) {
        setState(() {
          _favoriteIds = favoriteUrls;
        });
      }
    } catch (e) {
      AegisLogger.error('Failed to load favorites: $e');
    }
  }


  Future<void> _showAddAppDialog() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _AddAppDialog(),
    );

    if (result != null && mounted) {
      await _addWebApp(result['url'] ?? '', result['name'] ?? '');
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

  Future<void> _addWebApp(String url, String name) async {
    try {
      // Validate URL
      Uri? uri;
      try {
        uri = Uri.parse(url);
        if (!uri.hasScheme || (!uri.scheme.startsWith('http'))) {
          throw Exception('Invalid URL');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid URL. Please enter a valid HTTP or HTTPS URL.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      // Check if app already exists
      final existingApp = _nappList.firstWhere(
        (app) => app.url == url,
        orElse: () => NAppModel(
          id: '',
          url: '',
          name: '',
          icon: '',
          description: '',
        ),
      );

      if (existingApp.url.isNotEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('This app is already in the list.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      // Check if app already exists in database
      final existingDbApp = await UserAppDBISAR.getByUrl(url);
      if (existingDbApp != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('This app is already in the list.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      // Extract domain from URL for app name and icon
      final appName = name.isNotEmpty ? name : (uri.host.isNotEmpty ? uri.host : 'Web App');
      final appId = uri.host.isNotEmpty ? uri.host.replaceAll('.', '_') : 'user_app_${DateTime.now().millisecondsSinceEpoch}';
      
      // Try to get favicon URL
      final iconUrl = await _getFaviconUrl(uri);
      
      // Create a new app model
      final newApp = NAppModel(
        id: appId,
        url: url,
        name: appName,
        icon: iconUrl,
        description: 'User Added',
        platforms: ['web'],
      );

      // Convert to database model and save (isPreset=false for user-added apps)
      final dbApp = _convertToDBApp(newApp, isPreset: false);
      await UserAppDBISAR.saveFromDB(dbApp);
      AegisLogger.info('Successfully saved user-added app to database: ${newApp.name}');

      // Reload list from database to maintain proper sorting (newest first)
      if (mounted) {
        await _loadNappList();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added ${newApp.name}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      AegisLogger.error('Failed to add web app: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add app: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _showDeleteDialog(NAppModel napp) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete App'),
        content: Text('Are you sure you want to delete "${napp.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _deleteApp(napp);
    }
  }

  Future<void> _deleteApp(NAppModel napp) async {
    try {
      await UserAppDBISAR.deleteFromDB(napp.url);
      AegisLogger.info('Successfully deleted app: ${napp.name}');

      // Reload list from database
      if (mounted) {
        await _loadNappList();
        await _loadFavorites();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deleted ${napp.name}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      AegisLogger.error('Failed to delete app: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete app: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}

