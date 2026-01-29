// NApp data model for Nostr Apps
class NAppModel {
  final String id;
  final String url;
  final String name;
  final String icon;
  final String description;
  final List<String>? platforms;
  final Map<String, dynamic> metadata;

  NAppModel({
    required this.id,
    required this.url,
    required this.name,
    required this.icon,
    required this.description,
    this.platforms,
    this.metadata = const {},
  });

  // Helper getter for backward compatibility
  String get iconUrl => icon;
  
  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'name': name,
      'icon': icon,
      'description': description,
      'platforms': platforms,
      'metadata': metadata,
    };
  }

  // Create from Map
  factory NAppModel.fromMap(Map<String, dynamic> map) {
    List<String>? platformsList;
    if (map['platforms'] != null) {
      if (map['platforms'] is List) {
        platformsList = (map['platforms'] as List).map((e) => e.toString()).toList();
      }
    }
    
    return NAppModel(
      id: map['id'] ?? '',
      url: map['url'] ?? '',
      name: map['name'] ?? '',
      icon: map['icon'] ?? '',
      description: map['description'] ?? '',
      platforms: platformsList,
      metadata: map['metadata'] is Map ? Map<String, dynamic>.from(map['metadata']) : {},
    );
  }
}

