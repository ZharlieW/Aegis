import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aegis/navigator/navigator.dart';
import 'package:aegis/utils/local_storage.dart';
import 'package:aegis/utils/account.dart';
import 'package:aegis/utils/logger.dart';
import 'napp_model.dart';
import 'webview_page.dart';

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
      // Load NApp list from JSON file
      final String jsonString = await rootBundle.loadString('lib/assets/napp_list.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      
      _nappList = jsonList.map((item) => NAppModel.fromMap(item as Map<String, dynamic>)).toList();
      
      if (mounted) {
        _applyFilter();
      }
    } catch (e) {
      print('Error loading napp_list.json: $e');
      // Fallback to empty list
      _nappList = [];
      if (mounted) {
        _applyFilter();
      }
    }
  }

  void _onSearchChanged() {
    _searchQuery = _searchController.text;
    _applyFilter();
  }

  void _applyFilter() {
    List<NAppModel> filtered = List.from(_nappList);

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
            const SizedBox(height: 24),
          ],
          // ALL APPS section
          _buildSectionHeader('ALL APPS', null),
          _buildAppGrid(allApps),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData? icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

  Widget _buildAppGrid(List<NAppModel> apps) {
    if (apps.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: apps.length,
        itemBuilder: (context, index) {
          return _buildNappGridItem(apps[index]);
        },
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
          );
        }
      },
      onLongPress: () {
        // Toggle favorite
        _toggleFavorite(napp, isFavorite);
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
          const SizedBox(height: 2),
          // Category
          Text(
            napp.description,
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
          favorites = rawFavorites.map((e) => e.toString()).toList();
        } else if (rawFavorites is String) {
          // If it's a string, try to parse it as JSON
          try {
            final decoded = jsonDecode(rawFavorites);
            if (decoded is List) {
              favorites = decoded.map((e) => e.toString()).toList();
            }
          } catch (_) {
            // If parsing fails, treat as single string
            favorites = [rawFavorites];
          }
        }
      }
      
      if (mounted) {
        setState(() {
          _favoriteIds = favorites.toSet();
        });
      }
    } catch (e) {
      AegisLogger.error('Failed to load favorites: $e');
    }
  }

  Future<void> _toggleFavorite(NAppModel napp, bool isFavorite) async {
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
          favoriteList = rawFavorites.map((e) => e.toString()).toList();
        } else if (rawFavorites is String) {
          // If it's a string, try to parse it as JSON
          try {
            final decoded = jsonDecode(rawFavorites);
            if (decoded is List) {
              favoriteList = decoded.map((e) => e.toString()).toList();
            }
          } catch (_) {
            // If parsing fails, treat as single string
            favoriteList = [rawFavorites];
          }
        }
      }

      final appId = napp.id.isNotEmpty ? napp.id : napp.url;

      if (isFavorite) {
        favoriteList.remove(appId);
        favoriteList.remove(napp.url);
      } else {
        if (!favoriteList.contains(appId) && !favoriteList.contains(napp.url)) {
          favoriteList.add(appId);
        }
      }

      // Save as List<String> which LocalStorage.set() supports
      await LocalStorage.set(key, favoriteList);
      if (mounted) {
        setState(() {
          _favoriteIds = favoriteList.toSet();
        });
      }
    } catch (e) {
      AegisLogger.error('Failed to toggle favorite: $e');
    }
  }
}

