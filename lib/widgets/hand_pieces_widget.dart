import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';
import 'draggable_piece_widget.dart';

class HandPiecesWidget extends StatelessWidget {
  const HandPiecesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameStateProvider>(
      builder: (context, gameState, child) {
        final hand = gameState.hand;
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          constraints: const BoxConstraints(
            minHeight: 140,
            maxHeight: 220,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: hand.map((piece) {
              return Expanded(
                child: Center(
                  child: DraggablePieceWidget(piece: piece),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
