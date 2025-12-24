import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/game/game_cubit.dart';
import '../cubits/game/game_state.dart';

/// Combo overlay that appears in the center of the board
/// Shows "COMBO x2", "COMBO x3", etc. with animated effects
class ComboOverlayWidget extends StatefulWidget {
  const ComboOverlayWidget({super.key});

  @override
  State<ComboOverlayWidget> createState() => _ComboOverlayWidgetState();
}

class _ComboOverlayWidgetState extends State<ComboOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  int _lastCombo = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Scale animation - starts big, bounces to normal
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 65,
      ),
    ]).animate(_controller);

    // Glow intensity animation
    _glowAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Get combo color based on combo level
  Color _getComboColor(int combo) {
    if (combo >= 15) return const Color(0xFFFF00FF); // Magenta
    if (combo >= 10) return const Color(0xFFFF1493); // Deep Pink
    if (combo >= 7) return const Color(0xFFFF4500); // Red-Orange
    if (combo >= 5) return const Color(0xFFFFA500); // Orange
    if (combo >= 3) return const Color(0xFFFFD700); // Gold
    return const Color(0xFFFFFF00); // Yellow
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      buildWhen: (previous, current) {
        // Only rebuild when combo changes
        if (previous is GameInProgress && current is GameInProgress) {
          return previous.combo != current.combo;
        }
        return true;
      },
      builder: (context, gameState) {
        if (gameState is! GameInProgress) {
          return const SizedBox.shrink();
        }

        final combo = gameState.combo;

        // Only show if combo > 1
        if (combo <= 1) {
          // Combo reset - stop animation and hide
          if (_controller.isAnimating) {
            _controller.stop();
            _controller.reset();
          }
          _lastCombo = combo;
          return const SizedBox.shrink();
        }

        // Trigger animation when combo increases
        if (combo > _lastCombo) {
          _controller.forward(from: 0.0).then((_) {
            // After initial pop, loop the pulse animation
            if (mounted && combo > 1) {
              _controller.repeat(reverse: true);
            }
          });
          _lastCombo = combo;
        } else if (combo < _lastCombo && combo <= 1) {
          // Combo decreased to 0 or 1 (reset) - stop and hide
          _controller.stop();
          _controller.reset();
          _lastCombo = combo;
        } else if (combo < _lastCombo) {
          // Combo decreased but still > 1 - just update lastCombo
          _lastCombo = combo;
        }

        final comboColor = _getComboColor(combo);

        return Center(
          child: IgnorePointer(
            // Don't intercept touches
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                // Use scale animation for initial pop (first 40%), then subtle pulse
                final currentScale = _controller.value < 0.4
                    ? _scaleAnimation.value
                    : 1.0 * (0.98 + (_controller.value * 0.04)); // Subtle pulse 0.98-1.02
                final glowIntensity = _glowAnimation.value.clamp(0.6, 1.0);

                return Transform.scale(
                  scale: currentScale.clamp(0.8, 1.2),
                  child: Opacity(
                    opacity: _controller.value < 0.3 ? _controller.value * 3.33 : 1.0,
                    child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          comboColor,
                          comboColor.withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(
                          alpha: 0.5 + (glowIntensity * 0.5),
                        ),
                        width: 2.5,
                      ),
                      boxShadow: [
                        // Main glow shadow
                        BoxShadow(
                          color: comboColor.withValues(
                            alpha: 0.4 + (glowIntensity * 0.4),
                          ),
                          blurRadius: 20 + (glowIntensity * 20),
                          spreadRadius: 4 + (glowIntensity * 4),
                        ),
                        // White glow shadow
                        BoxShadow(
                          color: Colors.white.withValues(
                            alpha: 0.3 + (glowIntensity * 0.3),
                          ),
                          blurRadius: 15 + (glowIntensity * 15),
                          spreadRadius: 2 + (glowIntensity * 2),
                        ),
                        // Outer shadow for depth
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 30,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Fire emoji
                        Text(
                          '🔥',
                          style: TextStyle(
                            fontSize: 28 + (glowIntensity * 4),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // COMBO text
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'COMBO',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 2),
                            // Multiplier badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                'x$combo',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  shadows: [
                                    Shadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.6),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

