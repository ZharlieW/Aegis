import 'package:flutter/material.dart';
import '../../common/common_appbar.dart';
import '../../common/common_tips.dart';
import '../../navigator/navigator.dart';
import '../../nostr/utils.dart';
import '../../nostr/nips/nip49/nip49.dart';
import '../../utils/account.dart';

class LoginPrivateKey extends StatefulWidget {
  const LoginPrivateKey({super.key});

  @override
  LoginPrivateKeyState createState() => LoginPrivateKeyState();
}

class LoginPrivateKeyState extends State<LoginPrivateKey> {
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isNcryptsec = false;

  @override
  void initState() {
    super.initState();
    _keyController.addListener(_onKeyChanged);
  }

  @override
  void dispose() {
    _keyController.removeListener(_onKeyChanged);
    _keyController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onKeyChanged() {
    final key = _keyController.text.trim();
    final isNcryptsec = NIP49Utils.isValidNcryptsec(key);
    if (isNcryptsec != _isNcryptsec) {
      setState(() {
        _isNcryptsec = isNcryptsec;
        if (!isNcryptsec) {
          _passwordController.clear();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: CustomScrollView(
          slivers: [
            const CommonAppBar(
              title: 'Use your private key',
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Text(
                          "Set up Aegis with your Nostr private key — supports nsec, ncryptsec, and hex formats.",
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        TextField(
                          controller: _keyController,
                          textAlignVertical: TextAlignVertical.center,
                          style: theme.textTheme.bodyLarge,
                          decoration: InputDecoration(
                            labelText: 'Private Key',
                            hintText: 'nsec / ncryptsec / hex key',
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.all(12),
                            prefixIcon: Icon(Icons.key, color: colorScheme.onSurfaceVariant),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isNcryptsec ? Icons.lock : Icons.visibility,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              onPressed: () {
                                if (_isNcryptsec) {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        
                        if (_isNcryptsec) ...[
                          const SizedBox(height: 16),
                          TextField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            textAlignVertical: TextAlignVertical.center,
                            style: theme.textTheme.bodyLarge,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter password to decrypt ncryptsec',
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.all(12),
                              prefixIcon: Icon(Icons.lock_outline, color: colorScheme.onSurfaceVariant),
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
                          ),
                        ],
                        
                        const SizedBox(height: 20),
                        
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _handleLogin,
                            style: FilledButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Login',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogin() async {
    final key = _keyController.text.trim();
    if (key.isEmpty) {
      if (mounted) {
        CommonTips.error(context, 'The content cannot be empty!');
      }
      return;
    }

    try {
      String privateKey;
      
      if (_isNcryptsec) {
        final password = _passwordController.text.trim();
        if (password.isEmpty) {
          if (mounted) {
            CommonTips.error(context, 'Password is required for ncryptsec!');
          }
          return;
        }
        
        try {
          privateKey = await NIP49.decrypt(key, password);
        } catch (e) {
          if (mounted) {
            CommonTips.error(context, 'Failed to decrypt ncryptsec. Please check your password.');
          }
          return;
        }
      } else if (validateNsec(key)) {
        privateKey = Account.getPrivateKey(key);
      } else {
        privateKey = key;
      }

      if (privateKey.length != 64 || !RegExp(r'^[a-fA-F0-9]+$').hasMatch(privateKey)) {
        if (mounted) {
          CommonTips.error(context, 'Invalid private key format!');
        }
        return;
      }

      final publicKey = Account.getPublicKey(privateKey);
      Account.sharedInstance.loginSuccess(publicKey, privateKey);

      if (mounted) {
        CommonTips.success(context, 'Login successful!');
        AegisNavigator.popToRoot(context);
      }
      
    } catch (e) {
      if (mounted) {
        CommonTips.error(context, 'Login failed: ${e.toString()}');
      }
    }
  }
}
