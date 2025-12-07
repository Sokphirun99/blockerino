class LeaderboardEntry {
  final String playerId;
  final String playerName;
  final int score;
  final int rank;
  final DateTime timestamp;
  final String gameMode;

  const LeaderboardEntry({
    required this.playerId,
    required this.playerName,
    required this.score,
    required this.rank,
    required this.timestamp,
    required this.gameMode,
  });

  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'playerName': playerName,
      'score': score,
      'rank': rank,
      'timestamp': timestamp.toIso8601String(),
      'gameMode': gameMode,
    };
  }

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      score: json['score'] as int,
      rank: json['rank'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      gameMode: json['gameMode'] as String,
    );
  }
}

// Mock leaderboard data for demonstration
class LeaderboardService {
  static List<LeaderboardEntry> getMockLeaderboard(String gameMode) {
    return [
      LeaderboardEntry(
        playerId: 'player1',
        playerName: 'BlockMaster',
        score: 15000,
        rank: 1,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        gameMode: gameMode,
      ),
      LeaderboardEntry(
        playerId: 'player2',
        playerName: 'PuzzlePro',
        score: 12500,
        rank: 2,
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        gameMode: gameMode,
      ),
      LeaderboardEntry(
        playerId: 'player3',
        playerName: 'ComboKing',
        score: 10000,
        rank: 3,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        gameMode: gameMode,
      ),
      LeaderboardEntry(
        playerId: 'player4',
        playerName: 'GridGuru',
        score: 8500,
        rank: 4,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        gameMode: gameMode,
      ),
      LeaderboardEntry(
        playerId: 'player5',
        playerName: 'LineBreaker',
        score: 7000,
        rank: 5,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        gameMode: gameMode,
      ),
    ];
  }
}
