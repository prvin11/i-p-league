class Player {
  final String name;
  final bool isCaptain;
  final bool isVC;
  final double points;

  Player({
    required this.name,
    required this.isCaptain,
    required this.isVC,
    required this.points,
  });

  /// Convert Player to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isCaptain': isCaptain,
      'isVC': isVC,
      'points': points,
    };
  }

  /// Create Player from JSON
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'] as String,
      isCaptain: json['isCaptain'] as bool? ?? false,
      isVC: json['isVC'] as bool? ?? false,
      points: (json['points'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Create a copy of Player with modified fields
  Player copyWith({
    String? name,
    bool? isCaptain,
    bool? isVC,
    double? points,
  }) {
    return Player(
      name: name ?? this.name,
      isCaptain: isCaptain ?? this.isCaptain,
      isVC: isVC ?? this.isVC,
      points: points ?? this.points,
    );
  }

  @override
  String toString() =>
      'Player(name: $name, isCaptain: $isCaptain, isVC: $isVC, points: $points)';
}
