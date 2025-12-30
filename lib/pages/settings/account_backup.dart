import 'package:aegis/utils/widget_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../common/common_appbar.dart';
import '../../common/common_image.dart';
import '../../nostr/nips/nip19/nip19.dart';
import '../../nostr/nips/nip49/nip49.dart';
import '../../nostr/nips/nip49/nip49_utils.dart';
import '../../utils/account.dart';
import '../../utils/took_kit.dart';

class AccountBackup extends StatefulWidget {
  const AccountBackup({super.key});

  @override
  AccountBackupState createState() => AccountBackupState();
}

class AccountBackupState extends State<AccountBackup> {
  bool _isObscured = true;
  late final String nsecKeyStr;
  
  // NIP-49 related variables
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isEncrypting = false;
  String? _encryptedKey;
  String? _encryptionError;

  String get displayNsecKey {
    if (_isObscured) {
      return nsecKeyStr.split('\n').map((line) => '•' * line.length).join('\n');
    } else {
      return nsecKeyStr;
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  _init() {
    Account instance = Account.sharedInstance;
    String nsecKey = Nip19.encodePrivateKey(instance.currentPrivkey);
    nsecKeyStr = nsecKey;
    setState(() {});
  }

  /// Encrypt private key using NIP-49
  Future<void> _encryptPrivateKey() async {
    if (_passwordController.text.isEmpty) {
      setState(() {
        _encryptionError = 'Password is required';
      });
      return;
    }

    setState(() {
      _isEncrypting = true;
      _encryptionError = null;
      _encryptedKey = null;
    });

    try {
      // Get the raw private key (remove nsec prefix)
      Account instance = Account.sharedInstance;
      String rawPrivateKey = instance.currentPrivkey;
      
      // Encrypt using NIP-49
      final encrypted = await NIP49.encrypt(rawPrivateKey, _passwordController.text);
      
      setState(() {
        _encryptedKey = encrypted;
        _encryptionError = null;
      });

      // Copy to clipboard
      await Clipboard.setData(ClipboardData(text: encrypted));
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Encrypted private key copied to clipboard'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _encryptionError = 'Encryption failed: $e';
      });
    } finally {
      setState(() {
        _isEncrypting = false;
      });
    }
  }

  /// Validate password strength
  String _getPasswordStrengthText() {
    if (_passwordController.text.isEmpty) return '';
    
    final score = NIP49Utils.getPasswordStrength(_passwordController.text);
    final description = NIP49Utils.getPasswordStrengthDescription(_passwordController.text);
    
    return '$description ($score/100)';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: CustomScrollView(
          slivers: [
            const CommonAppBar(
              title: 'Account backup',
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                _openAccountWidget(),
                const SizedBox(height: 30),
                _accountPrivateKeyWidget(),
                const SizedBox(height: 30),
                _nip49EncryptionWidget(),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _openAccountWidget() {
    Account instance = Account.sharedInstance;
    String pubkey = instance.currentPubkey;
    String nupKey = Account.getNupPublicKey(pubkey);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Public account ID',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 300,
              child: Text(nupKey),
            ),
            GestureDetector(
              onTap: () {
                TookKit.copyKey(context, nupKey);
              },
              child: SizedBox(
                width: 48,
                height: 48,
                child: Center(
                  child: CommonImage(
                    iconName: 'copy_icon.png',
                    size: 24,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    ).setPadding(const EdgeInsets.symmetric(horizontal: 16));
  }

  Widget _accountPrivateKeyWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Account private key',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    )),
            Row(
              children: [
                const Text('Show'),
                Switch(
                  value: !_isObscured,
                  onChanged: (value) {
                    setState(() {
                      _isObscured = !value;
                    });
                  },
                ).setPaddingOnly(left: 10.0),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                displayNsecKey,
              ),
            ),
            GestureDetector(
              onTap: () {
                TookKit.copyKey(context, nsecKeyStr);
              },
              child: SizedBox(
                width: 48,
                height: 48,
                child: Center(
                  child: CommonImage(
                    iconName: 'copy_icon.png',
                    size: 24,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    ).setPadding(const EdgeInsets.symmetric(horizontal: 16));
  }

  /// NIP-49 Private Key Encryption Widget
  Widget _nip49EncryptionWidget() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'Private Key Encryption',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Description text
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Encrypt your private key to enhance security. The key will be encrypted using a password.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'The encrypted key will start with "ncryptsec1" and cannot be used without the password.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '⚠️ Warning: If you lose your password, you will not be able to recover your key.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Password input field
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Password',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    final securePassword = NIP49Utils.generateSecurePassword(length: 16);
                    _passwordController.text = securePassword;
                    setState(() {
                      _encryptionError = null;
                    });
                  },
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Generate'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: const Size(0, 0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                hintText: 'Enter encryption password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _encryptionError = null;
                });
              },
            ),
            
            // Password strength indicator
            if (_passwordController.text.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                _getPasswordStrengthText(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: _getPasswordStrengthText().contains('Weak') 
                      ? colorScheme.error
                      : _getPasswordStrengthText().contains('Strong') 
                          ? colorScheme.primary
                          : colorScheme.tertiary,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        
        // Encrypt button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isEncrypting ? null : _encryptPrivateKey,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isEncrypting
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.onPrimary,
                    ),
                  )
                : const Text(
                    'Encrypt and Copy Private Key',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ),
        
        // Error message
        if (_encryptionError != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorScheme.error.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: colorScheme.error, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _encryptionError!,
                    style: TextStyle(
                      color: colorScheme.onErrorContainer,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        
        // Success message and encrypted key display
        if (_encryptedKey != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Private key encrypted successfully!',
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Encrypted key (ncryptsec):',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: SelectableText(
                    _encryptedKey!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    ).setPadding(const EdgeInsets.symmetric(horizontal: 16));
  }
}
