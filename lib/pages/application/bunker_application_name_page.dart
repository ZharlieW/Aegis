import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aegis/common/common_tips.dart';
import 'package:aegis/navigator/navigator.dart';
import 'package:aegis/utils/app_icon_loader.dart';
import 'package:aegis/generated/l10n/app_localizations.dart';
import 'bunker_socket_info.dart';

class BunkerApplicationNamePage extends StatefulWidget {
  const BunkerApplicationNamePage({super.key});

  @override
  BunkerApplicationNamePageState createState() => BunkerApplicationNamePageState();
}

class BunkerApplicationNamePageState extends State<BunkerApplicationNamePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dialogSearchController = TextEditingController();
  String? _selectedPresetName;
  String _currentDisplayName = '';
  String _dialogSearchQuery = '';
  
  // Preset application names with their corresponding image URLs
  Map<String, String> _presetApps = {};
  
  @override
  void initState() {
    super.initState();
    _loadPresetApps();
  }
  
  // Load preset apps from JSON file
  Future<void> _loadPresetApps() async {
    try {
      final String jsonString = await rootBundle.loadString('lib/assets/preset_apps.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      
      setState(() {
        _presetApps = {
          for (var app in jsonData)
            app['name'] as String: app['thumb'] as String
        };
      });
    } catch (e) {
      // Fallback to empty map if loading fails
      setState(() {
        _presetApps = {};
      });
    }
  }
  
  List<String> get _presetNames {
    final names = _presetApps.keys.toList();
    names.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return names;
  }
  
  // Get filtered preset names based on search query
  List<String> _getFilteredPresetNames(String query) {
    if (query.isEmpty) {
      return _presetNames;
    }
    final lowerQuery = query.toLowerCase();
    return _presetNames.where((name) => 
      name.toLowerCase().contains(lowerQuery)
    ).toList();
  }
  
  // Show dialog with searchable preset list
  Future<void> _showPresetDialog() async {
    _dialogSearchController.clear();
    _dialogSearchQuery = '';
    
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final filteredNames = _getFilteredPresetNames(_dialogSearchQuery);
          
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.selectApplication,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Search box
                  TextField(
                    controller: _dialogSearchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.search,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _dialogSearchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _dialogSearchController.clear();
                                setDialogState(() {
                                  _dialogSearchQuery = '';
                                });
                              },
                            )
                          : null,
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (value) {
                      setDialogState(() {
                        _dialogSearchQuery = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  // Filtered list
                  Flexible(
                    child: SizedBox(
                      height: 300,
                      child: filteredNames.isEmpty
                          ? Center(
                              child: Text(
                                AppLocalizations.of(context)!.noResultsFound,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: filteredNames.length,
                              itemBuilder: (context, index) {
                                final name = filteredNames[index];
                                return ListTile(
                                  leading: _buildAppIcon(name, size: 24),
                                  title: Text(name),
                                  onTap: () {
                                    Navigator.of(context).pop(name);
                                  },
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
            ],
          );
        },
      ),
    );
    
    if (selected != null) {
      _onPresetNameSelected(selected);
    }
  }
  
  // Get image URL for a preset name, returns null if not found
  String? _getImageForName(String name) {
    return _presetApps[name];
  }
  
  // Get first letter of name
  String _getFirstLetter(String name) {
    if (name.isEmpty) return '?';
    // Handle special case for 0xchat
    if (name.startsWith('0x')) {
      return '0';
    }
    return name[0].toUpperCase();
  }
  
  // Build icon widget - shows image if available, otherwise shows first letter
  Widget _buildAppIcon(String name, {double size = 24}) {
    final imageUrl = _getImageForName(name);
    
    return AppIconLoader.buildIcon(
      imageUrl: imageUrl,
      appName: name,
      size: size,
      fallback: _buildInitialIcon(name, size),
      fit: BoxFit.cover,
      borderRadius: BorderRadius.circular(size / 2),
    );
  }
  
  // Build initial letter icon
  Widget _buildInitialIcon(String name, double size) {
    final letter = _getFirstLetter(name);
    final colors = [
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.secondary,
      Theme.of(context).colorScheme.tertiary,
    ];
    // Use hash of name to get consistent color
    final colorIndex = name.hashCode.abs() % colors.length;
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors[colorIndex].withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(
          color: colors[colorIndex],
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            color: colors[colorIndex],
            fontSize: size * 0.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dialogSearchController.dispose();
    super.dispose();
  }

  void _onPresetNameSelected(String? value) {
    setState(() {
      _selectedPresetName = value;
      if (value != null) {
        _nameController.text = value;
        _currentDisplayName = value;
      } else {
        // Check if current text matches a preset name
        final currentText = _nameController.text.trim();
        _currentDisplayName = currentText;
        if (_presetApps.containsKey(currentText)) {
          _selectedPresetName = currentText;
        }
      }
    });
  }

  void _onContinue() {
    String name = _nameController.text.trim();
    
    if (name.isEmpty) {
      CommonTips.error(context, AppLocalizations.of(context)!.nameCannotBeEmpty);
      return;
    }
    
    if (name.length > 15) {
      CommonTips.error(context, AppLocalizations.of(context)!.nameTooLong);
      return;
    }

    // Get image URL if it's a preset application
    String? imageUrl = _getImageForName(name);

    // Navigate to BunkerSocketInfo with the application name and image URL
    AegisNavigator.pushPage(
      context,
      (context) => BunkerSocketInfo(
        applicationName: name,
        applicationImage: imageUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get bottom padding to avoid Android navigation bar
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.application,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w400,
              ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.pleaseSelectApplication,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 24),
              // Button to open preset selection dialog
              SizedBox(
                height: 56,
                child: OutlinedButton(
                  onPressed: _showPresetDialog,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerLeft,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedPresetName ?? AppLocalizations.of(context)!.selectApplication,
                          style: TextStyle(
                            color: _selectedPresetName != null
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Text field for custom name
              TextField(
                controller: _nameController,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.enterCustomName,
                  labelText: AppLocalizations.of(context)!.orEnterCustomName,
                  border: const OutlineInputBorder(),
                  isDense: false,
                  contentPadding: const EdgeInsets.all(16),
                  prefixIcon: _currentDisplayName.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: _buildAppIcon(
                            _currentDisplayName,
                            size: 24,
                          ),
                        )
                      : null,
                ),
                onChanged: (value) {
                  // Update preset selection based on input
                  setState(() {
                    final trimmedValue = value.trim();
                    _currentDisplayName = trimmedValue;
                    if (_presetApps.containsKey(trimmedValue)) {
                      _selectedPresetName = trimmedValue;
                    } else if (trimmedValue != _selectedPresetName) {
                      _selectedPresetName = null;
                    }
                  });
                },
              ),
              const Spacer(),
              // Continue button
              FilledButton.tonal(
                onPressed: _onContinue,
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  child: Text(
                    AppLocalizations.of(context)!.continueButton,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                ),
              ),
              SizedBox(height: 24 + bottomPadding),
            ],
          ),
        ),
      ),
    );
  }
}


