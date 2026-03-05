class Player {
  final String name;
  final bool isCaptain;
  final bool isVC;
  final double points;
  final String iplTeam;

  Player({
    required this.name,
    required this.isCaptain,
    required this.isVC,
    required this.points,
    required this.iplTeam,
  });

  /// Convert Player to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isCaptain': isCaptain,
      'isVC': isVC,
      'points': points,
      'iplTeam': iplTeam,
    };
  }

  /// Create Player from JSON
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'] as String,
      isCaptain: json['isCaptain'] as bool? ?? false,
      isVC: json['isVC'] as bool? ?? false,
      points: (json['points'] as num?)?.toDouble() ?? 0.0,
      iplTeam: json['iplTeam'] as String? ?? '',
    );
  }

  /// Create a copy of Player with modified fields
  Player copyWith({
    String? name,
    bool? isCaptain,
    bool? isVC,
    double? points,
    String? iplTeam,
  }) {
    return Player(
      name: name ?? this.name,
      isCaptain: isCaptain ?? this.isCaptain,
      isVC: isVC ?? this.isVC,
      points: points ?? this.points,
      iplTeam: iplTeam ?? this.iplTeam,
    );
  }

  @override
  String toString() =>
      'Player(name: $name, isCaptain: $isCaptain, isVC: $isVC, points: $points, iplTeam: $iplTeam)';
}
