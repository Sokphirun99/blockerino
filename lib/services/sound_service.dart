import 'package:flutter/services.dart';

/// Sound and haptic feedback service for game events
/// Uses haptic feedback patterns to simulate different game sounds
class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();
  
  bool _soundEnabled = true;
  bool _hapticsEnabled = true;

  bool get soundEnabled => _soundEnabled;
  bool get hapticsEnabled => _hapticsEnabled;

  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  void setHapticsEnabled(bool enabled) {
    _hapticsEnabled = enabled;
  }

  /// Play feedback when placing a piece
  Future<void> playPlace() async {
    if (!_hapticsEnabled) return;
    await HapticFeedback.lightImpact();
  }

  /// Play feedback when clearing lines - more intense for more lines
  Future<void> playClear(int lineCount) async {
    if (!_hapticsEnabled) return;
    
    if (lineCount >= 3) {
      // Triple+ line clear - heavy impact
      await HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 50));
      await HapticFeedback.heavyImpact();
    } else if (lineCount >= 2) {
      // Double line clear - medium impact
      await HapticFeedback.heavyImpact();
    } else {
      // Single line clear
      await HapticFeedback.mediumImpact();
    }
  }

  /// Play feedback for combo - escalating pattern
  Future<void> playCombo(int comboLevel) async {
    if (!_hapticsEnabled) return;
    
    // Rapid clicks for combo feeling
    final clickCount = comboLevel.clamp(1, 5);
    for (int i = 0; i < clickCount; i++) {
      await HapticFeedback.selectionClick();
      if (i < clickCount - 1) {
        await Future.delayed(const Duration(milliseconds: 40));
      }
    }
  }

  /// Play feedback when game is over
  Future<void> playGameOver() async {
    if (!_hapticsEnabled) return;
    
    // Dramatic ending pattern
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 150));
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 150));
    await HapticFeedback.heavyImpact();
  }

  /// Play feedback when piece cannot be placed
  Future<void> playError() async {
    if (!_hapticsEnabled) return;
    await HapticFeedback.vibrate();
  }

  /// Play feedback when hand is refilled
  Future<void> playRefill() async {
    if (!_hapticsEnabled) return;
    await HapticFeedback.selectionClick();
  }
}
