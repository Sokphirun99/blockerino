enum PowerUpType {
  bomb,      // Clears 3x3 area
  wildPiece, // Can be placed anywhere
  lineClear, // Clears random row or column
  colorBomb, // Clears all blocks of one color
  shuffle,   // Reshuffles hand pieces
}

class PowerUp {
  final PowerUpType type;
  final String name;
  final String description;
  final String icon;
  final int cost; // Cost in coins to purchase

  const PowerUp({
    required this.type,
    required this.name,
    required this.description,
    required this.icon,
    required this.cost,
  });

  static const List<PowerUp> allPowerUps = [
    PowerUp(
      type: PowerUpType.bomb,
      name: 'Bomb',
      description: 'Clears a 3x3 area',
      icon: '💣',
      cost: 50,
    ),
    PowerUp(
      type: PowerUpType.wildPiece,
      name: 'Wild Piece',
      description: 'Place anywhere on board',
      icon: '🃏',
      cost: 30,
    ),
    PowerUp(
      type: PowerUpType.lineClear,
      name: 'Line Clear',
      description: 'Clears a random line',
      icon: '⚡',
      cost: 40,
    ),
    PowerUp(
      type: PowerUpType.colorBomb,
      name: 'Color Bomb',
      description: 'Clears all of one color',
      icon: '🌈',
      cost: 60,
    ),
    PowerUp(
      type: PowerUpType.shuffle,
      name: 'Shuffle',
      description: 'Get new pieces',
      icon: '🔄',
      cost: 25,
    ),
  ];

  static PowerUp? fromType(PowerUpType type) {
    try {
      return allPowerUps.firstWhere((p) => p.type == type);
    } catch (_) {
      return null;
    }
  }
}
