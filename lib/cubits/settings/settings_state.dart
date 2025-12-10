import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../models/power_up.dart';
import '../../models/theme.dart';

class SettingsState extends Equatable {
  final bool soundEnabled;
  final bool hapticsEnabled;
  final bool animationsEnabled;
  final int highScore;
  final int coins;
  final String currentThemeId;
  final List<String> unlockedThemeIds;
  final Map<PowerUpType, int> powerUpInventory;
  final List<String> completedChallengeIds;
  final Map<int, int> storyLevelStars;
  final int currentStoryLevel;
  final Locale currentLocale;

  const SettingsState({
    required this.soundEnabled,
    required this.hapticsEnabled,
    required this.animationsEnabled,
    required this.highScore,
    required this.coins,
    required this.currentThemeId,
    required this.unlockedThemeIds,
    required this.powerUpInventory,
    required this.completedChallengeIds,
    required this.storyLevelStars,
    required this.currentStoryLevel,
    required this.currentLocale,
  });

  factory SettingsState.initial() {
    return const SettingsState(
      soundEnabled: true,
      hapticsEnabled: true,
      animationsEnabled: true,
      highScore: 0,
      coins: 0,
      currentThemeId: 'default',
      unlockedThemeIds: ['default'],
      powerUpInventory: {},
      completedChallengeIds: [],
      storyLevelStars: {},
      currentStoryLevel: 1,
      currentLocale: Locale('en', ''),
    );
  }

  GameTheme get currentTheme => GameTheme.fromId(currentThemeId) ?? GameTheme.defaultTheme;

  int get totalStarsEarned {
    return storyLevelStars.values.fold(0, (sum, stars) => sum + stars);
  }

  SettingsState copyWith({
    bool? soundEnabled,
    bool? hapticsEnabled,
    bool? animationsEnabled,
    int? highScore,
    int? coins,
    String? currentThemeId,
    List<String>? unlockedThemeIds,
    Map<PowerUpType, int>? powerUpInventory,
    List<String>? completedChallengeIds,
    Map<int, int>? storyLevelStars,
    int? currentStoryLevel,
    Locale? currentLocale,
  }) {
    return SettingsState(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
      highScore: highScore ?? this.highScore,
      coins: coins ?? this.coins,
      currentThemeId: currentThemeId ?? this.currentThemeId,
      unlockedThemeIds: unlockedThemeIds ?? this.unlockedThemeIds,
      powerUpInventory: powerUpInventory ?? this.powerUpInventory,
      completedChallengeIds: completedChallengeIds ?? this.completedChallengeIds,
      storyLevelStars: storyLevelStars ?? this.storyLevelStars,
      currentStoryLevel: currentStoryLevel ?? this.currentStoryLevel,
      currentLocale: currentLocale ?? this.currentLocale,
    );
  }

  @override
  List<Object?> get props => [
        soundEnabled,
        hapticsEnabled,
        animationsEnabled,
        highScore,
        coins,
        currentThemeId,
        unlockedThemeIds,
        powerUpInventory,
        completedChallengeIds,
        storyLevelStars,
        currentStoryLevel,
        currentLocale,
      ];
}
