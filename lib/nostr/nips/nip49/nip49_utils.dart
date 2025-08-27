import 'dart:math';
import 'nip49.dart';

class NIP49Utils {
  /// Generate a secure random password
  static String generateSecurePassword({int length = 16}) {
    const lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const digits = '0123456789';
    const special = '!@#\$%^&*()_+-=[]{}|;:,.<>?';
    
    final password = <String>[
      lowercase[Random.secure().nextInt(lowercase.length)],
      uppercase[Random.secure().nextInt(uppercase.length)],
      digits[Random.secure().nextInt(digits.length)],
      special[Random.secure().nextInt(special.length)],
    ];
    
    final allChars = lowercase + uppercase + digits + special;
    for (int i = 4; i < length; i++) {
      password.add(allChars[Random.secure().nextInt(allChars.length)]);
    }
    
    password.shuffle(Random.secure());
    
    return password.join();
  }
  
  /// Check if password meets strength requirements
  static bool isPasswordStrong(String password) {
    if (password.length < 8) return false;
    
    bool hasLowercase = false;
    bool hasUppercase = false;
    bool hasDigit = false;
    bool hasSpecial = false;
    
    for (int i = 0; i < password.length; i++) {
      final char = password[i];
      if (char.contains(RegExp(r'[a-z]'))) hasLowercase = true;
      if (char.contains(RegExp(r'[A-Z]'))) hasUppercase = true;
      if (char.contains(RegExp(r'[0-9]'))) hasDigit = true;
      if (char.contains(RegExp(r'[!@#\$%^&*()_+\-=\[\]{}|;:,.<>?]'))) hasSpecial = true;
    }
    
    return hasLowercase && hasUppercase && hasDigit && hasSpecial;
  }
  
  /// Calculate password strength score (0-100)
  static int getPasswordStrength(String password) {
    int score = 0;
    
    if (password.length >= 8) score += 10;
    if (password.length >= 12) score += 10;
    if (password.length >= 16) score += 10;
    
    if (password.contains(RegExp(r'[a-z]'))) score += 10;
    if (password.contains(RegExp(r'[A-Z]'))) score += 10;
    if (password.contains(RegExp(r'[0-9]'))) score += 10;
    if (password.contains(RegExp(r'[!@#\$%^&*()_+\-=\[\]{}|;:,.<>?]'))) score += 10;
    
    if (password.length >= 20) score += 20;
    
    return score.clamp(0, 100);
  }
  
  /// Get password strength description
  static String getPasswordStrengthDescription(String password) {
    final score = getPasswordStrength(password);
    
    if (score >= 80) return 'Strong';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    return 'Weak';
  }
  
  /// Validate ncryptsec format
  static bool isValidNcryptsec(String input) {
    return input.startsWith('ncryptsec1');
  }
  
  /// Test if a password can decrypt a given ncryptsec
  static Future<bool> testPassword(String ncryptsec, String password) async {
    try {
      final decrypted = await NIP49.decrypt(ncryptsec, password);
      return decrypted.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
  
  /// Format private key for display
  static String formatPrivateKeyForDisplay(String privateKey) {
    if (privateKey.length <= 16) return privateKey;
    return '${privateKey.substring(0, 8)}...${privateKey.substring(privateKey.length - 8)}';
  }
  
  /// Format ncryptsec for display
  static String formatNcryptsecForDisplay(String ncryptsec) {
    if (ncryptsec.length <= 20) return ncryptsec;
    return '${ncryptsec.substring(0, 10)}...${ncryptsec.substring(ncryptsec.length - 10)}';
  }
}
