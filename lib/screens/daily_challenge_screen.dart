import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../models/daily_challenge.dart';
import '../models/game_mode.dart';
import '../models/story_level.dart';
import '../cubits/game/game_cubit.dart';
import '../cubits/settings/settings_cubit.dart';
import '../cubits/settings/settings_state.dart';
import '../widgets/shared_ui_components.dart';
import 'game_screen.dart';

class DailyChallengeScreen extends StatefulWidget {
  const DailyChallengeScreen({super.key});

  @override
  State<DailyChallengeScreen> createState() => _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends State<DailyChallengeScreen> {
  bool _analyticsLogged = false;
  final ScrollController _scrollController = ScrollController();
  LevelTier _selectedTier = LevelTier.beginner;

  @override
  void initState() {
    super.initState();
    // Find the current tier based on progress
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentLevel();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_analyticsLogged) {
      _analyticsLogged = true;
      final settings = context.read<SettingsCubit>();
      settings.analyticsService.logScreenView('block_quest');
    }
  }

  void _scrollToCurrentLevel() {
    final settings = context.read<SettingsCubit>();
    final levelStars = settings.state.storyLevelStars;

    // Find the first incomplete level
    int currentLevel = 1;
    for (int i = 1; i <= AdventureLevels.totalLevels; i++) {
      if ((levelStars[i] ?? 0) == 0) {
        currentLevel = i;
        break;
      }
    }

    // Set the selected tier based on current level
    setState(() {
      _selectedTier = AdventureLevels.getTierForLevel(currentLevel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0a1a),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),

            // Progress bar
            _buildProgressBar(context),

            // Tier tabs
            _buildTierTabs(context),

            // Level grid
            Expanded(
              child: _buildLevelGrid(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),

          // Title
          Expanded(
            child: Column(
              children: [
                const Text(
                  'BLOCK QUEST',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                BlocBuilder<SettingsCubit, SettingsState>(
                  builder: (context, state) {
                    final totalStars = _calculateTotalStars(state.storyLevelStars);
                    const maxStars = AdventureLevels.totalLevels * 3;
                    return Text(
                      '$totalStars / $maxStars stars',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.amber.shade300,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Stars display
          BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber.shade600, Colors.amber.shade800],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.white, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '${_calculateTotalStars(state.storyLevelStars)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final completedLevels = state.storyLevelStars.entries
            .where((e) => e.value > 0)
            .length;
        final progress = completedLevels / AdventureLevels.totalLevels;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Level $completedLevels / ${AdventureLevels.totalLevels}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white12,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(AdventureLevels.getTierColor(_selectedTier)),
                  ),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTierTabs(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: LevelTier.values.map((tier) {
          final isSelected = _selectedTier == tier;
          final tierColor = Color(AdventureLevels.getTierColor(tier));

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => setState(() => _selectedTier = tier),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? tierColor : tierColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: tierColor,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: tierColor.withValues(alpha: 0.4),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AdventureLevels.getTierEmoji(tier),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AdventureLevels.getTierName(tier),
                      style: TextStyle(
                        color: isSelected ? Colors.white : tierColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLevelGrid(BuildContext context) {
    final levels = AdventureLevels.getLevelsByTier(_selectedTier);
    final responsive = ResponsiveUtil(context);
    final crossAxisCount = responsive.isMobile ? 4 : responsive.isTablet ? 6 : 8;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.85,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: levels.length,
          itemBuilder: (context, index) {
            final level = levels[index];
            final stars = state.storyLevelStars[level.levelNumber] ?? 0;
            final isUnlocked = AdventureLevels.isLevelUnlocked(
              level.levelNumber,
              state.storyLevelStars,
            );

            return _buildLevelCard(context, level, stars, isUnlocked);
          },
        );
      },
    );
  }

  Widget _buildLevelCard(
    BuildContext context,
    StoryLevel level,
    int stars,
    bool isUnlocked,
  ) {
    final tier = AdventureLevels.getTierForLevel(level.levelNumber);
    final tierColor = Color(AdventureLevels.getTierColor(tier));
    final isCompleted = stars > 0;

    return GestureDetector(
      onTap: isUnlocked ? () => _showLevelDialog(context, level, stars) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: isUnlocked
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isCompleted
                      ? [
                          tierColor.withValues(alpha: 0.4),
                          tierColor.withValues(alpha: 0.2),
                        ]
                      : [
                          const Color(0xFF2d2d44),
                          const Color(0xFF1a1a2e),
                        ],
                )
              : null,
          color: isUnlocked ? null : Colors.grey.shade900,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUnlocked
                ? (isCompleted ? tierColor : tierColor.withValues(alpha: 0.5))
                : Colors.grey.shade800,
            width: isCompleted ? 2 : 1,
          ),
          boxShadow: isCompleted
              ? [
                  BoxShadow(
                    color: tierColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Level number or lock icon
            if (isUnlocked)
              Text(
                '${level.levelNumber}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isCompleted ? Colors.white : Colors.white70,
                ),
              )
            else
              Icon(
                Icons.lock,
                color: Colors.grey.shade600,
                size: 24,
              ),

            const SizedBox(height: 4),

            // Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                return Icon(
                  i < stars ? Icons.star : Icons.star_border,
                  color: i < stars ? Colors.amber : Colors.grey.shade600,
                  size: 14,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showLevelDialog(BuildContext context, StoryLevel level, int currentStars) {
    final tier = AdventureLevels.getTierForLevel(level.levelNumber);
    final tierColor = Color(AdventureLevels.getTierColor(tier));

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 350),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2d2d44),
                Color(0xFF1a1a2e),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: tierColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: tierColor.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Level header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: tierColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: tierColor.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    'LEVEL ${level.levelNumber}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: tierColor,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Level title
                AutoSizeText(
                  level.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // Tier badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: tierColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    AdventureLevels.getTierName(tier).toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: tierColor,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Objectives
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'OBJECTIVES',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white54,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Target Score
                      _buildObjectiveRow(
                        icon: Icons.stars,
                        label: 'Target Score',
                        value: '${level.targetScore}',
                        color: Colors.amber,
                      ),

                      // Target Lines (if any)
                      if (level.targetLines != null) ...[
                        const SizedBox(height: 8),
                        _buildObjectiveRow(
                          icon: Icons.horizontal_rule,
                          label: 'Clear Lines',
                          value: '${level.targetLines}',
                          color: Colors.cyan,
                        ),
                      ],

                      // Time Limit (if any)
                      if (level.timeLimit != null) ...[
                        const SizedBox(height: 8),
                        _buildObjectiveRow(
                          icon: Icons.timer,
                          label: 'Time Limit',
                          value: _formatTime(level.timeLimit!),
                          color: Colors.orange,
                        ),
                      ],

                      const SizedBox(height: 12),

                      // Game mode indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            level.gameMode == GameMode.chaos
                                ? Icons.flash_on
                                : Icons.grid_4x4,
                            color: level.gameMode == GameMode.chaos
                                ? Colors.orange
                                : Colors.cyan,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            level.gameMode == GameMode.chaos
                                ? 'Chaos Mode (10×10)'
                                : 'Classic Mode (8×8)',
                            style: TextStyle(
                              fontSize: 12,
                              color: level.gameMode == GameMode.chaos
                                  ? Colors.orange
                                  : Colors.cyan,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Star thresholds
                _buildStarThresholds(level, currentStars, tierColor),

                const SizedBox(height: 16),

                // Reward
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.amber.shade600, Colors.amber.shade800],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🪙', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(
                        '+${level.coinReward}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'BACK',
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _startLevel(context, level);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tierColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          currentStars > 0 ? 'REPLAY' : 'PLAY',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildObjectiveRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    if (secs > 0) {
      return '${minutes}m ${secs}s';
    }
    return '$minutes min';
  }

  Widget _buildStarThresholds(StoryLevel level, int currentStars, Color tierColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStarThreshold(1, level.starThreshold1, currentStars >= 1, tierColor),
        _buildStarThreshold(2, level.starThreshold2, currentStars >= 2, tierColor),
        _buildStarThreshold(3, level.starThreshold3, currentStars >= 3, tierColor),
      ],
    );
  }

  Widget _buildStarThreshold(int starCount, int threshold, bool achieved, Color tierColor) {
    return Column(
      children: [
        Icon(
          achieved ? Icons.star : Icons.star_border,
          color: achieved ? Colors.amber : Colors.grey,
          size: 28,
        ),
        const SizedBox(height: 4),
        Text(
          '$threshold',
          style: TextStyle(
            fontSize: 12,
            color: achieved ? Colors.white : Colors.white54,
            fontWeight: achieved ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  /// Start the game with the StoryLevel objectives
  /// This is the key fix - we now pass the full StoryLevel to GameCubit
  void _startLevel(BuildContext context, StoryLevel level) {
    final gameCubit = context.read<GameCubit>();

    // CRITICAL: Start game with storyLevel parameter for proper objective tracking
    // This ensures the game knows about score targets, line targets, time limits, etc.
    gameCubit.startGame(level.gameMode, storyLevel: level);

    // Navigate to game screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GameScreen()),
    );
  }

  int _calculateTotalStars(Map<int, int> levelStars) {
    return levelStars.values.fold(0, (sum, stars) => sum + stars);
  }
}
