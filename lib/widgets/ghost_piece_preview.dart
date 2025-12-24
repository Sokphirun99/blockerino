import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/piece.dart';
import '../config/app_config.dart';
import '../cubits/game/game_cubit.dart';
import '../cubits/game/game_state.dart';

/// A semi-transparent ghost preview of a piece that shows where it will be placed
/// This makes it instantly obvious if a piece fits
class GhostPiecePreview extends StatelessWidget {
  final Piece? piece;
  final int gridX;
  final int gridY;
  final bool isValid;

  const GhostPiecePreview({
    super.key,
    required this.piece,
    required this.gridX,
    required this.gridY,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    if (piece == null || gridX < 0 || gridY < 0) {
      return const SizedBox.shrink();
    }

    final gameCubit = context.read<GameCubit>();
    final currentState = gameCubit.state;
    if (currentState is! GameInProgress) return const SizedBox.shrink();

    final board = currentState.board;

    // CRITICAL FIX: Calculate cell size to match actual grid layout
    // The Stack (gridKey) is inside Padding(4.0), so available space = boardSize - (padding * 2)
    // Each cell uses Expanded, so cell size = availableSize / gridSize
    // This matches the actual grid cell size used by the Column/Row/Expanded layout
    final boardSize = AppConfig.getSize(context);
    final availableSize = boardSize -
        (AppConfig.boardContainerPadding *
            2); // Subtract padding on both sides (4.0 * 2 = 8.0)
    final cellSize =
        availableSize / board.size; // Size of each grid cell (including margin)
    const blockMargin =
        1.0; // Margin on each side of blocks (matches _BlockCell)

    // Calculate position on the board (relative to the Stack inside Padding)
    // The container should start at the cell boundary, blocks inside will have margins
    final offsetX = gridX * cellSize;
    final offsetY = gridY * cellSize;

    // Block size for individual blocks (cellSize - 2*margin)
    final blockSize = cellSize - (blockMargin * 2);

    // Store piece in local variable to avoid repeated null checks
    final pieceData = piece!;

    return Positioned(
      left: offsetX,
      top: offsetY,
      child: SizedBox(
        width: pieceData.width * cellSize, // Total width
        height: pieceData.height * cellSize, // Total height
        child: Stack(
          children: [
            // Draw the piece shape
            for (int row = 0; row < pieceData.height; row++)
              for (int col = 0; col < pieceData.width; col++)
                if (pieceData.shape[row][col])
                  Positioned(
                    left: col * cellSize + blockMargin,
                    top: row * cellSize + blockMargin,
                    child: Container(
                      width:
                          blockSize, // No extra margin needed - already accounted
                      height:
                          blockSize, // No extra margin needed - already accounted
                      // REMOVED: margin: EdgeInsets.all(1) - this was causing double margin
                      decoration: BoxDecoration(
                        // Improved visibility: higher opacity and better contrast
                        color: isValid
                            ? pieceData.color
                                .withValues(alpha: 0.6) // Increased from 0.4
                            : Colors.red.withValues(
                                alpha:
                                    0.4), // Changed from grey, increased opacity
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isValid
                              ? pieceData.color
                                  .withValues(alpha: 1.0) // More visible border
                              : Colors.red.withValues(
                                  alpha: 0.9), // Strong red border for invalid
                          width: 2.5, // Slightly thicker for visibility
                        ),
                        boxShadow: [
                          // Always show shadow for better visibility
                          BoxShadow(
                            color: isValid
                                ? pieceData.color.withValues(alpha: 0.5)
                                : Colors.red.withValues(alpha: 0.4),
                            blurRadius: isValid ? 12 : 8,
                            spreadRadius: isValid ? 2 : 1,
                          ),
                          // Additional glow for valid placements
                          if (isValid)
                            BoxShadow(
                              color: pieceData.color.withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 4,
                            ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
