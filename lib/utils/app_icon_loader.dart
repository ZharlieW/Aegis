import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Utility class to load app icons from local assets
class AppIconLoader {
  /// Get local asset path for an app icon by app name
  /// If imageUrl is provided, use its extension; otherwise try common extensions
  static String? getLocalIconPath(String appName, {String? imageUrl}) {
    // Sanitize app name to match filename (same logic as download script)
    String sanitizedName = appName
        .replaceAll(' ', '_')
        .replaceAll('/', '_')
        .replaceAll('\\', '_');
    // Remove any remaining non-alphanumeric characters except _ and -
    sanitizedName = sanitizedName.replaceAll(RegExp(r'[^a-zA-Z0-9_\-.]'), '');
    
    // If we have imageUrl, try to extract extension from it
    String? extension;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      final urlLower = imageUrl.toLowerCase();
      if (urlLower.endsWith('.svg')) {
        extension = '.svg';
      } else if (urlLower.endsWith('.png')) {
        extension = '.png';
      } else if (urlLower.endsWith('.jpg') || urlLower.endsWith('.jpeg')) {
        extension = '.jpg';
      } else if (urlLower.endsWith('.ico')) {
        extension = '.ico';
      } else if (urlLower.endsWith('.webp')) {
        extension = '.webp';
      }
    }
    
    // Use extension from URL if available, otherwise default to .png
    extension ??= '.png';
    
    return 'assets/images/app_icons/$sanitizedName$extension';
  }
  
  /// Check if app name is a default/system-generated name (not a preset app)
  static bool _isDefaultAppName(String appName) {
    // Check for default application names like "application #1", "application #2", etc.
    if (appName.startsWith('application #') || 
        appName.startsWith('application_') ||
        appName == 'application') {
      return true;
    }
    return false;
  }

  /// Build icon widget from local asset or fallback
  static Widget buildIcon({
    required String? imageUrl,
    required String appName,
    required double size,
    required Widget fallback,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    // Skip local lookup for default/system-generated app names
    // These don't have corresponding icon files
    if (_isDefaultAppName(appName)) {
      // For default app names, use network URL if available, otherwise fallback
      if (imageUrl != null && imageUrl.isNotEmpty) {
        return _buildNetworkIcon(
          url: imageUrl,
          size: size,
          fallback: fallback,
          fit: fit,
          borderRadius: borderRadius,
        );
      }
      return fallback;
    }
    
    // First try to get local icon path (use imageUrl to determine extension)
    String? localPath = getLocalIconPath(appName, imageUrl: imageUrl);
    
    // If we have a local path, try to load it with fallback to network
    if (localPath != null) {
      return _buildLocalIconWithNetworkFallback(
        localPath: localPath,
        networkUrl: imageUrl,
        size: size,
        fallback: fallback,
        fit: fit,
        borderRadius: borderRadius,
      );
    }
    
    // If no local icon and no imageUrl, return fallback
    if (imageUrl == null || imageUrl.isEmpty) {
      return fallback;
    }
    
    // Fallback to network loading if local not available
    return _buildNetworkIcon(
      url: imageUrl,
      size: size,
      fallback: fallback,
      fit: fit,
      borderRadius: borderRadius,
    );
  }
  
  /// Build icon from local asset, fallback to network if local fails
  static Widget _buildLocalIconWithNetworkFallback({
    required String localPath,
    required String? networkUrl,
    required double size,
    required Widget fallback,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    final isSvg = localPath.toLowerCase().endsWith('.svg');
    
    Widget iconWidget;
    
    if (isSvg) {
      // SVG doesn't have errorBuilder, use a wrapper widget
      iconWidget = _SafeSvgAsset(
        assetPath: localPath,
        networkUrl: networkUrl,
        size: size,
        fallback: fallback,
        fit: fit,
      );
    } else {
      iconWidget = Image.asset(
        localPath,
        width: size,
        height: size,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          // If local asset fails and we have network URL, try network
          if (networkUrl != null && networkUrl.isNotEmpty) {
            return _buildNetworkIcon(
              url: networkUrl,
              size: size,
              fallback: fallback,
              fit: fit,
              borderRadius: borderRadius,
            );
          }
          return fallback;
        },
      );
    }
    
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: iconWidget,
      );
    }
    
    return iconWidget;
  }
  
  /// Build icon from network (fallback)
  static Widget _buildNetworkIcon({
    required String url,
    required double size,
    required Widget fallback,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    final isSvg = url.toLowerCase().endsWith('.svg');
    
    Widget iconWidget;
    
    if (isSvg) {
      iconWidget = SvgPicture.network(
        url,
        width: size,
        height: size,
        fit: fit,
        placeholderBuilder: (context) => SizedBox(
          width: size,
          height: size,
          child: Center(
            child: SizedBox(
              width: size * 0.5,
              height: size * 0.5,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        headers: const {
          'User-Agent': 'Mozilla/5.0',
        },
      );
    } else {
      iconWidget = Image.network(
        url,
        width: size,
        height: size,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => fallback,
        headers: const {
          'User-Agent': 'Mozilla/5.0',
        },
      );
    }
    
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: iconWidget,
      );
    }
    
    return iconWidget;
  }
}

/// Safe wrapper for SVG asset that handles errors gracefully
class _SafeSvgAsset extends StatefulWidget {
  final String assetPath;
  final String? networkUrl;
  final double size;
  final Widget fallback;
  final BoxFit fit;

  const _SafeSvgAsset({
    required this.assetPath,
    required this.networkUrl,
    required this.size,
    required this.fallback,
    required this.fit,
  });

  @override
  State<_SafeSvgAsset> createState() => _SafeSvgAssetState();
}

class _SafeSvgAssetState extends State<_SafeSvgAsset> {
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      // If local SVG fails and we have network URL, try network
      if (widget.networkUrl != null && widget.networkUrl!.isNotEmpty) {
        return AppIconLoader._buildNetworkIcon(
          url: widget.networkUrl!,
          size: widget.size,
          fallback: widget.fallback,
          fit: widget.fit,
          borderRadius: null,
        );
      }
      return widget.fallback;
    }

    // Use FutureBuilder to check if asset exists before loading
    return FutureBuilder<List<int>>(
      future: DefaultAssetBundle.of(context).load(widget.assetPath).then((data) => data.buffer.asUint8List()),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // Asset doesn't exist, fallback to network or default
          if (!_hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _hasError = true;
                });
              }
            });
          }
          if (widget.networkUrl != null && widget.networkUrl!.isNotEmpty) {
            return AppIconLoader._buildNetworkIcon(
              url: widget.networkUrl!,
              size: widget.size,
              fallback: widget.fallback,
              fit: widget.fit,
              borderRadius: null,
            );
          }
          return widget.fallback;
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: widget.size,
            height: widget.size,
            child: Center(
              child: SizedBox(
                width: widget.size * 0.5,
                height: widget.size * 0.5,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        // Asset exists, load it
        return SvgPicture.asset(
          widget.assetPath,
          width: widget.size,
          height: widget.size,
          fit: widget.fit,
          placeholderBuilder: (context) => SizedBox(
            width: widget.size,
            height: widget.size,
            child: Center(
              child: SizedBox(
                width: widget.size * 0.5,
                height: widget.size * 0.5,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        );
      },
    );
  }
}

