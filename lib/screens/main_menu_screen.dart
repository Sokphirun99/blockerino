import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_mode.dart';
import '../providers/game_state_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/animated_background_widget.dart';
import 'game_screen.dart';
import 'story_mode_screen.dart';
import 'daily_challenge_screen.dart';
import 'store_screen.dart';
import 'leaderboard_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    
    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          const Positioned.fill(
            child: AnimatedBackgroundWidget(),
          ),
          
          // Main content
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.purple.shade900.withOpacity(0.2),
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Text(
                  'BLOCKERINO',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 32,
                        letterSpacing: 2,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  '8x8 grid, break lines!',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                ),
                const SizedBox(height: 12),
                
                // Coins Display
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFffd700), Color(0xFFffa500)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFffd700).withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🪙', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        '${settings.coins}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                
                // High Score Display
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'HIGH SCORE',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${settings.highScore}',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: const Color(0xFFFFD700),
                              fontSize: 24,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Story Mode Button (NEW!)
                _MenuButton(
                  text: '📖 STORY MODE',
                  subtitle: 'Journey Through Challenges',
                  color: const Color(0xFF9d4edd),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const StoryModeScreen()),
                    );
                  },
                ),
                const SizedBox(height: 12),
                
                // Daily Challenge Button (NEW!)
                _MenuButton(
                  text: '⭐ DAILY CHALLENGE',
                  subtitle: 'Complete Today\'s Quest',
                  color: const Color(0xFFffd700),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DailyChallengeScreen()),
                    );
                  },
                ),
                const SizedBox(height: 12),
                
                // Classic Mode Button
                _MenuButton(
                  text: 'CLASSIC MODE',
                  subtitle: '8x8 Grid • 3 Pieces',
                  color: const Color(0xFF4ECDC4),
                  onPressed: () {
                    _startGame(context, GameMode.classic);
                  },
                ),
                const SizedBox(height: 12),
                
                // Chaos Mode Button
                _MenuButton(
                  text: 'CHAOS MODE',
                  subtitle: '10x10 Grid • 5 Pieces',
                  color: const Color(0xFFFF6B6B),
                  onPressed: () {
                    _startGame(context, GameMode.chaos);
                  },
                ),
                const SizedBox(height: 12),
                
                // Store Button (NEW!)
                _MenuButton(
                  text: '🏪 STORE',
                  subtitle: 'Power-Ups & Themes',
                  color: const Color(0xFF06b6d4),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const StoreScreen()),
                    );
                  },
                ),
                const SizedBox(height: 12),
                
                // High Scores Button
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LeaderboardScreen()),
                    );
                  },
                  child: Text(
                    'LEADERBOARD',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                  ),
                ),
              ],
            ), // Column
                ), // Padding
              ), // SingleChildScrollView
            ), // SafeArea
          ), // Container
        ],
      ),
    );
  }

  void _startGame(BuildContext context, GameMode mode) {
    final gameState = Provider.of<GameStateProvider>(context, listen: false);
    gameState.startGame(mode);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GameScreen()),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String text;
  final String subtitle;
  final Color color;
  final VoidCallback onPressed;

  const _MenuButton({
    required this.text,
    required this.subtitle,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: color,
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
