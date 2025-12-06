import 'package:flutter/material.dart';

class Piece {
  final String id;
  final List<List<bool>> shape;
  final Color color;

  Piece({
    required this.id,
    required this.shape,
    required this.color,
  });

  int get width => shape[0].length;
  int get height => shape.length;

  int getBlockCount() {
    int count = 0;
    for (var row in shape) {
      for (var cell in row) {
        if (cell) count++;
      }
    }
    return count;
  }

  Piece copyWith({String? id, List<List<bool>>? shape, Color? color}) {
    return Piece(
      id: id ?? this.id,
      shape: shape ?? this.shape,
      color: color ?? this.color,
    );
  }
}

// Predefined piece shapes (Tetromino-style pieces)
class PieceLibrary {
  static final List<List<List<bool>>> shapes = [
    // Single block
    [
      [true]
    ],
    // 2x1 horizontal
    [
      [true, true]
    ],
    // 2x1 vertical
    [
      [true],
      [true]
    ],
    // 3x1 horizontal
    [
      [true, true, true]
    ],
    // 3x1 vertical
    [
      [true],
      [true],
      [true]
    ],
    // 2x2 square
    [
      [true, true],
      [true, true]
    ],
    // L shape
    [
      [true, false],
      [true, false],
      [true, true]
    ],
    // L shape mirrored
    [
      [false, true],
      [false, true],
      [true, true]
    ],
    // T shape
    [
      [true, true, true],
      [false, true, false]
    ],
    // 3x3 square
    [
      [true, true, true],
      [true, true, true],
      [true, true, true]
    ],
    // Z shape
    [
      [true, true, false],
      [false, true, true]
    ],
    // S shape
    [
      [false, true, true],
      [true, true, false]
    ],
    // Small L
    [
      [true, false],
      [true, true]
    ],
    // Small L mirrored
    [
      [false, true],
      [true, true]
    ],
  ];

  static final List<Color> colors = [
    const Color(0xFFFF6B6B), // Red
    const Color(0xFF4ECDC4), // Teal
    const Color(0xFFFFE66D), // Yellow
    const Color(0xFF95E1D3), // Mint
    const Color(0xFFF38181), // Pink
    const Color(0xFFAA96DA), // Purple
    const Color(0xFFFCBF49), // Orange
    const Color(0xFF06FFA5), // Green
  ];

  static Piece createRandomPiece() {
    final random = DateTime.now().millisecondsSinceEpoch;
    final shapeIndex = random % shapes.length;
    final colorIndex = random % colors.length;
    
    return Piece(
      id: 'piece_$random',
      shape: shapes[shapeIndex],
      color: colors[colorIndex],
    );
  }

  static List<Piece> createRandomHand(int count) {
    return List.generate(count, (index) {
      // Add slight delay to ensure different random values
      return createRandomPiece();
    });
  }
}
