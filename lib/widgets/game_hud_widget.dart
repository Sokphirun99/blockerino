import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/game/game_cubit.dart';
import '../cubits/game/game_state.dart';
import '../cubits/settings/settings_cubit.dart';
import '../models/game_mode.dart';

class GameHudWidget extends StatefulWidget {
  const GameHudWidget({super.key});

  @override
  State<GameHudWidget> createState() => _GameHudWidgetState();
}

class _GameHudWidgetState extends State<GameHudWidget> with SingleTickerProviderStateMixin {
  late AnimationController _comboAnimationController;
  late Animation<double> _comboScaleAnimation;
  late Animation<double> _comboGlowAnimation;
  int _lastCombo = 0;

  @override
  void initState() {
    super.initState();
    _comboAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _comboScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.4)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.4, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50,
      ),
    ]).animate(_comboAnimationController);

    _comboGlowAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
          parent: _comboAnimationController,
          curve: Curves.easeInOut,
        ));
  }

  @override
  void dispose() {
    _comboAnimationController.dispose();
    super.dispose();
  }

  void _triggerComboAnimation(int newCombo) {
    if (newCombo > _lastCombo) {
      _comboAnimationController.forward(from: 0.0);
    }
    _lastCombo = newCombo;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, gameState) {
        if (gameState is! GameInProgress) return const SizedBox.shrink();
        
        // Trigger animation when combo changes
        if (gameState.combo != _lastCombo) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _triggerComboAnimation(gameState.combo);
          });
        }
        
        final settings = context.watch<SettingsCubit>().state;
        final config = GameModeConfig.fromMode(gameState.gameMode);
        final movesLeft = config.handSize - gameState.lastBrokenLine;
        final comboProgress = gameState.combo > 0 ? movesLeft / config.handSize : 0.0;
        final isNewHighScore = gameState.score > settings.highScore;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // High score indicator
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star,
                  color: isNewHighScore 
                      ? const Color(0xFFFFE66D) 
                      : Colors.white38,
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(
                  '${isNewHighScore ? gameState.score : settings.highScore}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isNewHighScore 
                            ? const Color(0xFFFFE66D) 
                            : Colors.white38,
                        fontSize: 10,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              'SCORE',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
            ),
            Text(
              '${gameState.score}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (gameState.combo > 1) ...[
              const SizedBox(height: 4),
              AnimatedBuilder(
                animation: _comboAnimationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _comboScaleAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFFFD700),
                            const Color(0xFFFFE66D),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(
                            alpha: 0.3 + (_comboGlowAnimation.value * 0.7),
                          ),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFE66D).withValues(
                              alpha: 0.3 + (_comboGlowAnimation.value * 0.5),
                            ),
                            blurRadius: 8 + (_comboGlowAnimation.value * 12),
                            spreadRadius: 2 + (_comboGlowAnimation.value * 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            '🔥',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'COMBO',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.black,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'x${gameState.combo}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 4),
              // Combo timer progress bar
              Container(
                width: 80,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: (comboProgress * 100).round(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE66D),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: ((1 - comboProgress) * 100).round(),
                      child: const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$movesLeft moves left',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white60,
                      fontSize: 8,
                    ),
              ),
            ],
          ],
        );
      },
    );
  }
}
