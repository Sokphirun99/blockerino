import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import '../models/piece.dart';
import '../providers/game_state_provider.dart';
import '../providers/settings_provider.dart';

class DraggablePieceWidget extends StatefulWidget {
  final Piece piece;

  const DraggablePieceWidget({super.key, required this.piece});

  @override
  State<DraggablePieceWidget> createState() => _DraggablePieceWidgetState();
}

class _DraggablePieceWidgetState extends State<DraggablePieceWidget> {
  @override
  Widget build(BuildContext context) {
    return Draggable<Piece>(
      data: widget.piece,
      feedback: Material(
        color: Colors.transparent,
        child: _PieceVisual(
          piece: widget.piece,
          blockSize: 30,
          opacity: 0.8,
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _PieceVisual(
          piece: widget.piece,
          blockSize: 28,
          opacity: 0.5,
        ),
      ),
      child: _PieceVisual(
        piece: widget.piece,
        blockSize: 28,
        opacity: 1.0,
      ),
      onDragStarted: () {
        // Optional: Add haptic feedback on drag start
        final settings = Provider.of<SettingsProvider>(context, listen: false);
        if (settings.hapticsEnabled) {
          Vibration.vibrate(duration: 10);
        }
      },
      onDragEnd: (details) {
        if (!details.wasAccepted) {
          // Optional: Add haptic feedback on failed drop
          final settings = Provider.of<SettingsProvider>(context, listen: false);
          if (settings.hapticsEnabled) {
            Vibration.vibrate(duration: 50);
          }
        }
      },
    );
  }
}

class _PieceVisual extends StatelessWidget {
  final Piece piece;
  final double blockSize;
  final double opacity;

  const _PieceVisual({
    required this.piece,
    required this.blockSize,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(piece.height, (row) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(piece.width, (col) {
            final isBlock = piece.shape[row][col];
            return Container(
              width: blockSize,
            height: blockSize,
            margin: const EdgeInsets.all(1),
            decoration: isBlock
                ? BoxDecoration(
                    color: piece.color.withValues(alpha: opacity),
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: piece.color.withValues(alpha: 0.5),
                        blurRadius: 4,
                        spreadRadius: 1,
                        ),
                      ],
                    )
                  : null,
            );
          }),
        );
      }),
    );
  }
}

// Drag target overlay for the board
class BoardDragTarget extends StatelessWidget {
  final Widget child;

  const BoardDragTarget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DragTarget<Piece>(
      onWillAcceptWithDetails: (details) => true,
      onAcceptWithDetails: (details) {
        final gameState = Provider.of<GameStateProvider>(context, listen: false);
        final settings = Provider.of<SettingsProvider>(context, listen: false);
        
        // Calculate grid position from drop location
        // This is a simplified version - you'll need to implement precise grid mapping
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final localPosition = renderBox.globalToLocal(details.offset);
        
        // Convert to grid coordinates (simplified)
        final board = gameState.board!;
        final screenWidth = MediaQuery.of(context).size.width;
        final maxSize = screenWidth * 0.85;
        final blockSize = maxSize / board.size;
        
        final gridX = (localPosition.dx / blockSize).floor();
        final gridY = (localPosition.dy / blockSize).floor();
        
        final success = gameState.placePiece(details.data, gridX, gridY);
        
        if (success && settings.hapticsEnabled) {
          Vibration.vibrate(duration: 30);
        }
      },
      builder: (context, candidateData, rejectedData) {
        return child;
      },
    );
  }
}
