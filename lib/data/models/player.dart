class Player {
  final String name;
  final bool isCaptain;
  final bool isVC;
  final Map<int, double> matchdayPoints;
  final double points;
  final String iplTeam;

  Player({
    required this.name,
    required this.isCaptain,
    required this.isVC,
    required this.matchdayPoints,
    required this.points,
    required this.iplTeam,
  });

  /// Convert Player to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isCaptain': isCaptain,
      'isVC': isVC,
      'matchdayPoints': matchdayPoints.map((k, v) => MapEntry(k.toString(), v)),
      'points': points,
      'iplTeam': iplTeam,
    };
  }

  /// Create Player from JSON
  factory Player.fromJson(Map<String, dynamic> json) {
    final rawMatchdayPoints = json['matchdayPoints'];
    final parsedMatchdayPoints = <int, double>{};

    if (rawMatchdayPoints is Map<String, dynamic>) {
      rawMatchdayPoints.forEach((key, value) {
        final idx = int.tryParse(key);
        if (idx != null) {
          parsedMatchdayPoints[idx] = (value as num?)?.toDouble() ?? 0.0;
        }
      });
    }

    final pointsFromPayload = (json['points'] as num?)?.toDouble();
    final totalFromMatchdays = parsedMatchdayPoints.values.fold(0.0, (sum, value) => sum + value);

    return Player(
      name: json['name'] as String,
      isCaptain: json['isCaptain'] as bool? ?? false,
      isVC: json['isVC'] as bool? ?? false,
      matchdayPoints: parsedMatchdayPoints,
      points: pointsFromPayload ?? totalFromMatchdays,
      iplTeam: json['iplTeam'] as String? ?? '',
    );
  }

  /// Create a copy of Player with modified fields
  Player copyWith({
    String? name,
    bool? isCaptain,
    bool? isVC,
    Map<int, double>? matchdayPoints,
    double? points,
    String? iplTeam,
  }) {
    return Player(
      name: name ?? this.name,
      isCaptain: isCaptain ?? this.isCaptain,
      isVC: isVC ?? this.isVC,
      matchdayPoints: matchdayPoints ?? this.matchdayPoints,
      points: points ?? this.points,
      iplTeam: iplTeam ?? this.iplTeam,
    );
  }

  @override
  String toString() =>
      'Player(name: $name, isCaptain: $isCaptain, isVC: $isVC, matchdayPoints: $matchdayPoints, points: $points, iplTeam: $iplTeam)';
}
