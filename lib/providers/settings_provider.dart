import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/power_up.dart';
import '../models/theme.dart';
import '../models/story_level.dart';

class SettingsProvider extends ChangeNotifier {
  bool _soundEnabled = true;
  bool _hapticsEnabled = true;
  bool _animationsEnabled = true;
  int _highScore = 0;
  int _coins = 0;
  String _currentThemeId = 'default';
  List<String> _unlockedThemeIds = ['default'];
  Map<PowerUpType, int> _powerUpInventory = {};
  List<String> _completedChallengeIds = [];
  Map<int, int> _storyLevelStars = {}; // levelNumber -> stars earned
  int _currentStoryLevel = 1;

  bool get soundEnabled => _soundEnabled;
  bool get hapticsEnabled => _hapticsEnabled;
  bool get animationsEnabled => _animationsEnabled;
  int get highScore => _highScore;
  int get coins => _coins;
  String get currentThemeId => _currentThemeId;
  GameTheme get currentTheme => GameTheme.fromId(_currentThemeId) ?? GameTheme.defaultTheme;
  List<String> get unlockedThemeIds => List.from(_unlockedThemeIds);
  Map<PowerUpType, int> get powerUpInventory => Map.from(_powerUpInventory);
  List<String> get completedChallengeIds => List.from(_completedChallengeIds);
  Map<int, int> get storyLevelStars => Map.from(_storyLevelStars);
  int get currentStoryLevel => _currentStoryLevel;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _soundEnabled = prefs.getBool('soundEnabled') ?? true;
    _hapticsEnabled = prefs.getBool('hapticsEnabled') ?? true;
    _animationsEnabled = prefs.getBool('animationsEnabled') ?? true;
    _highScore = prefs.getInt('highScore') ?? 0;
    _coins = prefs.getInt('coins') ?? 0;
    _currentThemeId = prefs.getString('currentTheme') ?? 'default';
    _unlockedThemeIds = prefs.getStringList('unlockedThemes') ?? ['default'];
    _completedChallengeIds = prefs.getStringList('completedChallenges') ?? [];
    _currentStoryLevel = prefs.getInt('currentStoryLevel') ?? 1;
    
    // Load power-up inventory
    for (var powerUp in PowerUp.allPowerUps) {
      final key = 'powerup_${powerUp.type.name}';
      _powerUpInventory[powerUp.type] = prefs.getInt(key) ?? 0;
    }
    
    // Load story level stars
    for (var level in StoryLevel.allLevels) {
      final key = 'story_stars_${level.levelNumber}';
      _storyLevelStars[level.levelNumber] = prefs.getInt(key) ?? 0;
    }
    
    notifyListeners();
  }

  // Coins management
  Future<void> addCoins(int amount) async {
    _coins += amount;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('coins', _coins);
    notifyListeners();
  }

  Future<void> spendCoins(int amount) async {
    if (_coins >= amount) {
      _coins -= amount;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('coins', _coins);
      notifyListeners();
    }
  }

  // Theme management
  Future<void> setTheme(String themeId) async {
    if (_unlockedThemeIds.contains(themeId)) {
      _currentThemeId = themeId;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('currentTheme', themeId);
      notifyListeners();
    }
  }

  Future<bool> unlockTheme(String themeId) async {
    final theme = GameTheme.fromId(themeId);
    if (theme == null || _unlockedThemeIds.contains(themeId)) {
      return false;
    }
    
    if (_coins >= theme.unlockCost) {
      await spendCoins(theme.unlockCost);
      _unlockedThemeIds.add(themeId);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('unlockedThemes', _unlockedThemeIds);
      notifyListeners();
      return true;
    }
    return false;
  }

  bool isThemeUnlocked(String themeId) {
    return _unlockedThemeIds.contains(themeId);
  }

  // Power-up management
  Future<void> addPowerUp(PowerUpType type, int count) async {
    _powerUpInventory[type] = (_powerUpInventory[type] ?? 0) + count;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('powerup_${type.name}', _powerUpInventory[type]!);
    notifyListeners();
  }

  Future<bool> usePowerUp(PowerUpType type) async {
    if ((_powerUpInventory[type] ?? 0) > 0) {
      _powerUpInventory[type] = _powerUpInventory[type]! - 1;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('powerup_${type.name}', _powerUpInventory[type]!);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> buyPowerUp(PowerUpType type) async {
    final powerUp = PowerUp.fromType(type);
    if (powerUp == null) return false;
    
    if (_coins >= powerUp.cost) {
      await spendCoins(powerUp.cost);
      await addPowerUp(type, 1);
      return true;
    }
    return false;
  }

  int getPowerUpCount(PowerUpType type) {
    return _powerUpInventory[type] ?? 0;
  }

  // Challenge management
  Future<void> completeChallenge(String challengeId, int coinReward) async {
    if (!_completedChallengeIds.contains(challengeId)) {
      _completedChallengeIds.add(challengeId);
      await addCoins(coinReward);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('completedChallenges', _completedChallengeIds);
      notifyListeners();
    }
  }

  bool isChallengeCompleted(String challengeId) {
    return _completedChallengeIds.contains(challengeId);
  }

  // Story mode management
  Future<void> completeStoryLevel(int levelNumber, int stars, int coinReward) async {
    final currentStars = _storyLevelStars[levelNumber] ?? 0;
    if (stars > currentStars) {
      _storyLevelStars[levelNumber] = stars;
      await addCoins(coinReward);
      
      // Unlock next level
      if (levelNumber >= _currentStoryLevel) {
        _currentStoryLevel = levelNumber + 1;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('currentStoryLevel', _currentStoryLevel);
      }
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('story_stars_$levelNumber', stars);
      notifyListeners();
    }
  }

  int getStarsForLevel(int levelNumber) {
    return _storyLevelStars[levelNumber] ?? 0;
  }

  bool isStoryLevelUnlocked(int levelNumber) {
    return levelNumber <= _currentStoryLevel;
  }

  int get totalStarsEarned {
    return _storyLevelStars.values.fold(0, (sum, stars) => sum + stars);
  }

  Future<void> setSoundEnabled(bool value) async {
    _soundEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('soundEnabled', value);
    notifyListeners();
  }

  Future<void> setHapticsEnabled(bool value) async {
    _hapticsEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hapticsEnabled', value);
    notifyListeners();
  }

  Future<void> setAnimationsEnabled(bool value) async {
    _animationsEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('animationsEnabled', value);
    notifyListeners();
  }

  Future<void> updateHighScore(int newScore) async {
    if (newScore > _highScore) {
      _highScore = newScore;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('highScore', newScore);
      notifyListeners();
    }
  }

  Future<void> resetHighScore() async {
    _highScore = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('highScore', 0);
    notifyListeners();
  }
}
