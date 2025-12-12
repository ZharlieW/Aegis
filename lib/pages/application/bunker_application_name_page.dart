import 'package:flutter/material.dart';
import 'package:aegis/common/common_tips.dart';
import 'package:aegis/navigator/navigator.dart';
import 'bunker_socket_info.dart';

class BunkerApplicationNamePage extends StatefulWidget {
  const BunkerApplicationNamePage({super.key});

  @override
  BunkerApplicationNamePageState createState() => BunkerApplicationNamePageState();
}

class BunkerApplicationNamePageState extends State<BunkerApplicationNamePage> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedPresetName;
  String _currentDisplayName = '';
  
  // Preset application names with their corresponding images
  final Map<String, String> _presetApps = {
    'Amethyst': 'amethyst_icon.png',
    'Jumble': 'jumble_icon.png',
    '0xchat': '0xchat_icon.png',
    'Nostur': 'nostur_icon.png',
  };
  
  List<String> get _presetNames => _presetApps.keys.toList();
  
  // Get image for a preset name, returns null if not found
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
    final imageName = _getImageForName(name);
    
    if (imageName != null) {
      // Try to load image, fallback to first letter if it fails
      return Image.asset(
        'assets/images/$imageName',
        width: size,
        height: size,
        errorBuilder: (context, error, stackTrace) {
          return _buildInitialIcon(name, size);
        },
      );
    } else {
      // No image defined, show first letter
      return _buildInitialIcon(name, size);
    }
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
      CommonTips.error(context, 'The name cannot be empty');
      return;
    }
    
    if (name.length > 15) {
      CommonTips.error(context, 'The name is too long.');
      return;
    }

    // Navigate to BunkerSocketInfo with the application name
    AegisNavigator.pushPage(
      context,
      (context) => BunkerSocketInfo(applicationName: name),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Application Name',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w400,
              ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              'Please enter a name for this application',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 24),
            // Dropdown for preset names
            DropdownButtonFormField<String>(
              value: _selectedPresetName,
              decoration: InputDecoration(
                labelText: 'Select a preset name',
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: _presetNames.map((String name) {
                return DropdownMenuItem<String>(
                  value: name,
                  child: Row(
                    children: [
                      _buildAppIcon(name, size: 24),
                      const SizedBox(width: 12),
                      Text(name),
                    ],
                  ),
                );
              }).toList(),
              onChanged: _onPresetNameSelected,
            ),
            const SizedBox(height: 16),
            // Text field for custom name
            TextField(
              controller: _nameController,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: 'Or enter a custom name',
                labelText: 'Application name',
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
                  'Continue',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}


