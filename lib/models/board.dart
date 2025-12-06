import 'package:flutter/material.dart';
import 'piece.dart';

enum BlockType {
  empty,
  filled,
  hover,
  hoverBreak,
}

class BoardBlock {
  final BlockType type;
  final Color? color;

  BoardBlock({
    required this.type,
    this.color,
  });

  BoardBlock copyWith({BlockType? type, Color? color}) {
    return BoardBlock(
      type: type ?? this.type,
      color: color ?? this.color,
    );
  }
}

class Board {
  final int size;
  late List<List<BoardBlock>> grid;

  Board({required this.size}) {
    grid = List.generate(
      size,
      (i) => List.generate(
        size,
        (j) => BoardBlock(type: BlockType.empty),
      ),
    );
  }

  Board.fromGrid(this.size, this.grid);

  bool canPlacePiece(Piece piece, int x, int y) {
    if (x < 0 || y < 0) return false;
    if (x + piece.width > size || y + piece.height > size) return false;

    for (int row = 0; row < piece.height; row++) {
      for (int col = 0; col < piece.width; col++) {
        if (piece.shape[row][col]) {
          final boardX = x + col;
          final boardY = y + row;
          if (grid[boardY][boardX].type == BlockType.filled) {
            return false;
          }
        }
      }
    }
    return true;
  }

  void placePiece(Piece piece, int x, int y, {BlockType type = BlockType.filled}) {
    for (int row = 0; row < piece.height; row++) {
      for (int col = 0; col < piece.width; col++) {
        if (piece.shape[row][col]) {
          final boardX = x + col;
          final boardY = y + row;
          grid[boardY][boardX] = BoardBlock(
            type: type,
            color: piece.color,
          );
        }
      }
    }
  }

  void clearHoverBlocks() {
    for (int row = 0; row < size; row++) {
      for (int col = 0; col < size; col++) {
        if (grid[row][col].type == BlockType.hover ||
            grid[row][col].type == BlockType.hoverBreak) {
          grid[row][col] = BoardBlock(type: BlockType.empty);
        }
      }
    }
  }

  int breakLines() {
    List<int> rowsToClear = [];
    List<int> colsToClear = [];

    // Check rows
    for (int row = 0; row < size; row++) {
      bool isFull = true;
      for (int col = 0; col < size; col++) {
        if (grid[row][col].type != BlockType.filled) {
          isFull = false;
          break;
        }
      }
      if (isFull) rowsToClear.add(row);
    }

    // Check columns
    for (int col = 0; col < size; col++) {
      bool isFull = true;
      for (int row = 0; row < size; row++) {
        if (grid[row][col].type != BlockType.filled) {
          isFull = false;
          break;
        }
      }
      if (isFull) colsToClear.add(col);
    }

    // Clear lines
    for (int row in rowsToClear) {
      for (int col = 0; col < size; col++) {
        grid[row][col] = BoardBlock(type: BlockType.empty);
      }
    }

    for (int col in colsToClear) {
      for (int row = 0; row < size; row++) {
        grid[row][col] = BoardBlock(type: BlockType.empty);
      }
    }

    return rowsToClear.length + colsToClear.length;
  }

  Board clone() {
    final newGrid = List.generate(
      size,
      (row) => List.generate(
        size,
        (col) => grid[row][col].copyWith(),
      ),
    );
    return Board.fromGrid(size, newGrid);
  }

  bool hasAnyValidMove(List<Piece> hand) {
    for (var piece in hand) {
      for (int row = 0; row < size; row++) {
        for (int col = 0; col < size; col++) {
          if (canPlacePiece(piece, col, row)) {
            return true;
          }
        }
      }
    }
    return false;
  }
}
