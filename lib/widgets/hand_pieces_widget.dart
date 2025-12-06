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
          height: 120,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: hand.map((piece) {
              return DraggablePieceWidget(piece: piece);
            }).toList(),
          ),
        );
      },
    );
  }
}
