import 'package:flutter/material.dart';

class GameTheme {
  final String id;
  final String name;
  final String description;
  final Color primaryColor;
  final Color secondaryColor;
  final Color boardColor;
  final Color blockColor;
  final Color backgroundColor;
  final List<Color> pieceColors;
  final int unlockCost; // 0 = default/unlocked
  final String emoji;

  const GameTheme({
    required this.id,
    required this.name,
    required this.description,
    required this.primaryColor,
    required this.secondaryColor,
    required this.boardColor,
    required this.blockColor,
    required this.backgroundColor,
    required this.pieceColors,
    required this.unlockCost,
    required this.emoji,
  });

  static const GameTheme defaultTheme = GameTheme(
    id: 'default',
    name: 'Midnight Purple',
    description: 'The classic look',
    primaryColor: Color(0xFF9d4edd),
    secondaryColor: Color(0xFF7b2cbf),
    boardColor: Color(0xFF1a1a2e),
    blockColor: Color(0xFF9d4edd),
    backgroundColor: Color(0xFF0f0f1e),
    pieceColors: [
      Color(0xFF9d4edd),
      Color(0xFF7b2cbf),
      Color(0xFF5a189a),
    ],
    unlockCost: 0,
    emoji: '🌙',
  );

  static const List<GameTheme> allThemes = [
    defaultTheme,
    GameTheme(
      id: 'ocean',
      name: 'Ocean Breeze',
      description: 'Calm blue waters',
      primaryColor: Color(0xFF00b4d8),
      secondaryColor: Color(0xFF0096c7),
      boardColor: Color(0xFF023e8a),
      blockColor: Color(0xFF00b4d8),
      backgroundColor: Color(0xFF03045e),
      pieceColors: [
        Color(0xFF00b4d8),
        Color(0xFF0096c7),
        Color(0xFF0077b6),
      ],
      unlockCost: 500,
      emoji: '🌊',
    ),
    GameTheme(
      id: 'forest',
      name: 'Forest Green',
      description: 'Natural and fresh',
      primaryColor: Color(0xFF52b788),
      secondaryColor: Color(0xFF40916c),
      boardColor: Color(0xFF1b4332),
      blockColor: Color(0xFF52b788),
      backgroundColor: Color(0xFF081c15),
      pieceColors: [
        Color(0xFF52b788),
        Color(0xFF40916c),
        Color(0xFF2d6a4f),
      ],
      unlockCost: 500,
      emoji: '🌲',
    ),
    GameTheme(
      id: 'sunset',
      name: 'Sunset Glow',
      description: 'Warm evening colors',
      primaryColor: Color(0xFFff6b35),
      secondaryColor: Color(0xFFf77f00),
      boardColor: Color(0xFF5c2018),
      blockColor: Color(0xFFff6b35),
      backgroundColor: Color(0xFF370617),
      pieceColors: [
        Color(0xFFff6b35),
        Color(0xFFf77f00),
        Color(0xFFd62828),
      ],
      unlockCost: 750,
      emoji: '🌅',
    ),
    GameTheme(
      id: 'neon',
      name: 'Neon Lights',
      description: 'Electric and vibrant',
      primaryColor: Color(0xFFff006e),
      secondaryColor: Color(0xFF8338ec),
      boardColor: Color(0xFF000000),
      blockColor: Color(0xFFff006e),
      backgroundColor: Color(0xFF000000),
      pieceColors: [
        Color(0xFFff006e),
        Color(0xFF8338ec),
        Color(0xFF3a86ff),
      ],
      unlockCost: 1000,
      emoji: '✨',
    ),
    GameTheme(
      id: 'candy',
      name: 'Candy Land',
      description: 'Sweet and colorful',
      primaryColor: Color(0xFFff69eb),
      secondaryColor: Color(0xFFa855f7),
      boardColor: Color(0xFFfda4af),
      blockColor: Color(0xFFff69eb),
      backgroundColor: Color(0xFFfce7f3),
      pieceColors: [
        Color(0xFFff69eb),
        Color(0xFFa855f7),
        Color(0xFF06b6d4),
      ],
      unlockCost: 750,
      emoji: '🍬',
    ),
    GameTheme(
      id: 'cyberpunk',
      name: 'Cyberpunk',
      description: 'Futuristic and bold',
      primaryColor: Color(0xFF00ffff),
      secondaryColor: Color(0xFFff00ff),
      boardColor: Color(0xFF1a1a1a),
      blockColor: Color(0xFF00ffff),
      backgroundColor: Color(0xFF0a0a0a),
      pieceColors: [
        Color(0xFF00ffff),
        Color(0xFFff00ff),
        Color(0xFFffff00),
      ],
      unlockCost: 1500,
      emoji: '🤖',
    ),
    GameTheme(
      id: 'gold',
      name: 'Golden Hour',
      description: 'Luxurious gold',
      primaryColor: Color(0xFFffd700),
      secondaryColor: Color(0xFFffa500),
      boardColor: Color(0xFF4a3728),
      blockColor: Color(0xFFffd700),
      backgroundColor: Color(0xFF2c1810),
      pieceColors: [
        Color(0xFFffd700),
        Color(0xFFffa500),
        Color(0xFFff8c00),
      ],
      unlockCost: 2000,
      emoji: '👑',
    ),
  ];

  static GameTheme? fromId(String id) {
    try {
      return allThemes.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}
