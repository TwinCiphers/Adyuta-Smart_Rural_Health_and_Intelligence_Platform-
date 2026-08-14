import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

final localSecurityProvider = StateNotifierProvider<LocalSecurityNotifier, LocalSecurityState>((ref) {
  return LocalSecurityNotifier();
});

class LocalSecurityState {
  final bool isLocked;
  final bool hasMpinSet;
  final bool biometricsEnabled;
  final bool isChecking;

  LocalSecurityState({
    this.isLocked = false,
    this.hasMpinSet = false,
    this.biometricsEnabled = false,
    this.isChecking = true,
  });

  LocalSecurityState copyWith({
    bool? isLocked,
    bool? hasMpinSet,
    bool? biometricsEnabled,
    bool? isChecking,
  }) {
    return LocalSecurityState(
      isLocked: isLocked ?? this.isLocked,
      hasMpinSet: hasMpinSet ?? this.hasMpinSet,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
      isChecking: isChecking ?? this.isChecking,
    );
  }
}

class LocalSecurityNotifier extends StateNotifier<LocalSecurityState> {
  final _storage = const FlutterSecureStorage();
  final _localAuth = LocalAuthentication();

  LocalSecurityNotifier() : super(LocalSecurityState()) {
    _init();
  }

  Future<void> _init() async {
    String? mpin = await _storage.read(key: 'user_mpin');
    
    // Migration: If MPIN exists and is exactly 4 digits, it's plaintext. Hash it.
    if (mpin != null && mpin.length == 4 && int.tryParse(mpin) != null) {
      mpin = _hashPin(mpin);
      await _storage.write(key: 'user_mpin', value: mpin);
    }
    
    final biometricsStr = await _storage.read(key: 'biometrics_enabled');
    
    final hasMpin = mpin != null && mpin.isNotEmpty;
    final biometricsEnabled = biometricsStr == 'true';
    
    state = state.copyWith(
      hasMpinSet: hasMpin,
      biometricsEnabled: biometricsEnabled,
      isLocked: hasMpin, // If they have an MPIN, lock the app on boot
      isChecking: false,
    );
  }

  String _hashPin(String pin) {
    // In a real app, use a device-specific salt (like Android ID)
    final bytes = utf8.encode(pin + "ADYUTA_SALT_123");
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> setMpin(String pin) async {
    await _storage.write(key: 'user_mpin', value: _hashPin(pin));
    state = state.copyWith(hasMpinSet: true);
  }

  Future<bool> verifyMpin(String pin) async {
    final storedMpin = await _storage.read(key: 'user_mpin');
    if (storedMpin == _hashPin(pin)) {
      state = state.copyWith(isLocked: false);
      return true;
    }
    return false;
  }

  Future<void> setBiometricsEnabled(bool enabled) async {
    await _storage.write(key: 'biometrics_enabled', value: enabled.toString());
    state = state.copyWith(biometricsEnabled: enabled);
  }

  Future<bool> authenticateWithBiometrics() async {
    if (!state.biometricsEnabled) return false;
    
    try {
      final isAvailable = await _localAuth.canCheckBiometrics || await _localAuth.isDeviceSupported();
      if (!isAvailable) return false;

      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to unlock Adyuta',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      if (didAuthenticate) {
        state = state.copyWith(isLocked: false);
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  void lockApp() {
    if (state.hasMpinSet) {
      state = state.copyWith(isLocked: true);
    }
  }

  void unlockApp() {
    state = state.copyWith(isLocked: false);
  }

  Future<bool> toggleBiometricsWithChallenge(bool enable) async {
    if (!enable) {
      await setBiometricsEnabled(false);
      return true;
    }
    
    try {
      final isAvailable = await _localAuth.canCheckBiometrics || await _localAuth.isDeviceSupported();
      if (!isAvailable) return false;

      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to enable biometric unlock',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      if (didAuthenticate) {
        await setBiometricsEnabled(true);
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }
}
