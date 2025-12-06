import 'package:flutter/material.dart';
import '../models/board.dart';
import '../models/piece.dart';
import '../models/game_mode.dart';
import 'dart:math' as math;

class GameStateProvider extends ChangeNotifier {
  Board? _board;
  List<Piece> _hand = [];
  int _score = 0;
  int _combo = 0;
  int _lastBrokenLine = 0;
  GameMode _gameMode = GameMode.classic;
  bool _gameOver = false;

  Board? get board => _board;
  List<Piece> get hand => _hand;
  int get score => _score;
  int get combo => _combo;
  bool get gameOver => _gameOver;
  GameMode get gameMode => _gameMode;

  void startGame(GameMode mode) {
    _gameMode = mode;
    final config = GameModeConfig.fromMode(mode);
    _board = Board(size: config.boardSize);
    _hand = _generateRandomHand(config.handSize);
    _score = 0;
    _combo = 0;
    _lastBrokenLine = 0;
    _gameOver = false;
    notifyListeners();
  }

  List<Piece> _generateRandomHand(int count) {
    final random = math.Random();
    return List.generate(count, (index) {
      final shapeIndex = random.nextInt(PieceLibrary.shapes.length);
      final colorIndex = random.nextInt(PieceLibrary.colors.length);
      return Piece(
        id: 'piece_${DateTime.now().millisecondsSinceEpoch}_$index',
        shape: PieceLibrary.shapes[shapeIndex],
        color: PieceLibrary.colors[colorIndex],
      );
    });
  }

  void clearHoverBlocks() {
    _board?.clearHoverBlocks();
    notifyListeners();
  }

  void showHoverPreview(Piece piece, int x, int y) {
    if (_board == null) return;
    
    _board!.clearHoverBlocks();
    
    if (_board!.canPlacePiece(piece, x, y)) {
      _board!.placePiece(piece, x, y, type: BlockType.hover);
      notifyListeners();
    }
  }

  bool placePiece(Piece piece, int x, int y) {
    if (_board == null) return false;
    if (!_board!.canPlacePiece(piece, x, y)) return false;

    // Clear hover blocks and place the piece
    _board!.clearHoverBlocks();
    _board!.placePiece(piece, x, y, type: BlockType.filled);

    // Calculate score from placing blocks
    final pieceBlockCount = piece.getBlockCount();
    _score += pieceBlockCount;

    // Break lines and calculate combo
    final linesBroken = _board!.breakLines();
    if (linesBroken > 0) {
      _lastBrokenLine = 0;
      _combo++;
      // Score calculation: base points + combo multiplier
      final lineScore = linesBroken * 10;
      final comboBonus = _combo > 1 ? (_combo - 1) * 5 : 0;
      _score += lineScore + comboBonus;
    } else {
      _lastBrokenLine++;
      if (_lastBrokenLine >= 3) {
        _combo = 0;
      }
    }

    // Remove the piece from hand
    _hand.removeWhere((p) => p.id == piece.id);

    // Refill hand if empty
    if (_hand.isEmpty) {
      final config = GameModeConfig.fromMode(_gameMode);
      _hand = _generateRandomHand(config.handSize);
    }

    // Check for game over
    if (!_board!.hasAnyValidMove(_hand)) {
      _gameOver = true;
    }

    notifyListeners();
    return true;
  }

  void resetGame() {
    startGame(_gameMode);
  }
}
