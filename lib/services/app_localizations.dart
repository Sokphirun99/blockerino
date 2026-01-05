import 'package:flutter/material.dart';

/// Centralized localization service for the app
/// English only
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, String> _localizedValues = {
    // App Name & General
    'app_name': 'BLOCKERINO',
    'app_tagline': '8x8 grid, break lines!',

    // Main Menu
    'classic_mode': 'CLASSIC',
    'classic_subtitle': '8×8 Grid • Match Lines',
    'chaos_mode': 'CHAOS MODE',
    'chaos_subtitle': '10×10 Grid • 5 Pieces',
    'story_mode': 'STORY MODE',
    'story_subtitle': 'Progress Through Levels',
    'daily_challenge': 'DAILY CHALLENGE',
    'daily_subtitle': 'Today\'s Challenge',
    'daily_missions': 'DAILY MISSIONS',
    'daily_missions_subtitle': 'Complete tasks for rewards',
    'adventure_mode': 'ADVENTURE',
    'adventure_subtitle': '200 Levels to Conquer',
    'block_quest': 'BLOCK QUEST',
    'block_quest_subtitle': '200 Puzzle Levels',
    'store': 'STORE',
    'store_subtitle': 'Power-Ups & Themes',
    'leaderboard': 'LEADERBOARD',
    'settings': 'SETTINGS',
    'sign_in': 'Sign In',
    'guest_player': 'Guest Player',
    'tap_to_sign_in': 'Tap to sign in',

    // Game UI
    'score': 'Score',
    'high_score': 'High Score',
    'moves': 'Moves',
    'moves_left': 'moves left',
    'level': 'Level',
    'target': 'Target',
    'coins': 'Coins',
    'combo': 'COMBO',
    'objectives': 'OBJECTIVES',
    'complete': '✓ COMPLETE',
    'score_label': 'Score:',
    'lines_label': 'Lines:',

    // Game Over
    'game_over': 'GAME OVER',
    'final_score': 'Final Score',
    'new_high_score': 'New High Score!',
    'play_again': 'Play Again',
    'main_menu': 'Main Menu',

    // Power-Ups
    'power_ups': 'Power-Ups',
    'bomb': 'Bomb',
    'wild_piece': 'Wild Piece',
    'line_clear': 'Line Clear',
    'color_bomb': 'Color Bomb',
    'shuffle': 'Shuffle',
    'use': 'Use',
    'buy': 'Buy',

    // Store
    'themes': 'Themes',
    'purchase': 'Purchase',
    'equipped': 'Equipped',
    'locked': 'Locked',
    'classic_theme': 'Classic',
    'neon_theme': 'Neon',
    'nature_theme': 'Nature',
    'galaxy_theme': 'Galaxy',

    // Settings
    'game_settings': 'Game Settings',
    'sound': 'Sound',
    'haptics': 'Haptics',
    'animations': 'Animations',
    'account': 'Account',
    'appearance': 'Appearance',
    'current_theme': 'Current Theme',
    'browse_themes': 'Browse Themes',
    'statistics': 'Statistics',
    'total_coins': 'Total Coins',
    'story_progress': 'Story Progress',
    'themes_unlocked': 'Themes Unlocked',
    'data_management': 'Data Management',
    'sync_data': 'Sync Data',
    'clear_all_data': 'Clear All Data',
    'app_info': 'App Info',
    'version': 'Version',
    'sign_out': 'Sign Out',

    // Dialogs
    'confirm': 'Confirm',
    'cancel': 'Cancel',
    'ok': 'OK',
    'yes': 'Yes',
    'no': 'No',
    'warning': 'Warning',
    'sign_in_prompt': 'Sign in to sync your progress across devices and compete on the global leaderboard!',
    'sign_out_confirm': 'Are you sure you want to sign out?',
    'clear_data_warning': 'This will delete all your game progress, inventory, and settings. This action cannot be undone!',
    'clear_data_confirm': 'Are you sure you want to clear all data?',

    // Story Mode
    'locked_level': 'Locked',
    'completed': 'Completed',
    'play': 'Play',
    'replay': 'Replay',
    'stars': 'Stars',
    'reward': 'Reward',

    // Leaderboard
    'all_time': 'All Time',
    'this_week': 'This Week',
    'your_rank': 'Your Rank',
    'rank': 'Rank',
    'player': 'Player',
    'no_scores': 'No scores yet',
    'sign_in_to_compete': 'Sign in to compete on the leaderboard!',

    // Achievements
    'achievement_unlocked': 'Achievement Unlocked!',
    'continue': 'Continue',

    // Errors
    'error': 'Error',
    'network_error': 'Network error. Please check your connection.',
    'sign_in_failed': 'Sign in failed. Please try again.',
    'purchase_failed': 'Purchase failed. Please try again.',
    'insufficient_coins': 'Insufficient coins!',

    // Tutorial
    'skip_tutorial': 'SKIP TUTORIAL',
    'tutorial_welcome_title': 'Welcome to Blockerino!',
    'tutorial_welcome_desc': 'Match and clear lines to score points. Let\'s learn how to play!',
    'tutorial_lets_go': 'LET\'S GO!',
    'tutorial_drag_title': 'Drag Pieces',
    'tutorial_drag_desc': 'Drag pieces from the tray to the board. Place them strategically!',
    'tutorial_drag_hint': 'Try dragging a piece now!',
    'tutorial_clear_title': 'Clear Lines',
    'tutorial_clear_desc': 'Complete full rows or columns to clear them and earn points.',
    'tutorial_clear_hint': 'Fill a complete row or column!',
    'tutorial_combo_title': 'Combo System',
    'tutorial_combo_desc': 'Clear multiple lines in a row for combo bonuses! More combos = more points!',
    'tutorial_got_it': 'GOT IT!',
    'tutorial_gameover_title': 'Game Over',
    'tutorial_gameover_desc': 'The game ends when no pieces can fit on the board. Plan ahead!',
    'tutorial_start_playing': 'START PLAYING!',
  };

  String translate(String key) {
    return _localizedValues[key] ?? key;
  }

  // Convenience getters for common translations
  String get appName => translate('app_name');
  String get appTagline => translate('app_tagline');
  String get classicMode => translate('classic_mode');
  String get chaosMode => translate('chaos_mode');
  String get storyMode => translate('story_mode');
  String get dailyChallenge => translate('daily_challenge');
  String get store => translate('store');
  String get leaderboard => translate('leaderboard');
  String get settings => translate('settings');
  String get signIn => translate('sign_in');
  String get guestPlayer => translate('guest_player');
  String get score => translate('score');
  String get highScore => translate('high_score');
  String get coins => translate('coins');
  String get gameOver => translate('game_over');
  String get playAgain => translate('play_again');
  String get mainMenu => translate('main_menu');
  String get confirm => translate('confirm');
  String get cancel => translate('cancel');
  String get ok => translate('ok');
  String get warning => translate('warning');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
