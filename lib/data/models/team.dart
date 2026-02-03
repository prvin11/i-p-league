import 'player.dart';

class Team {
  final String name;
  final List<Player> players;
  final double overallPoints;

  Team({
    required this.name,
    required this.players,
    required this.overallPoints,
  });

  /// Convert Team to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'players': players.map((player) => player.toJson()).toList(),
      'overallPoints': overallPoints,
    };
  }

  /// Create Team from JSON
  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      name: json['name'] as String,
      players: (json['players'] as List<dynamic>?)
              ?.map((player) => Player.fromJson(player as Map<String, dynamic>))
              .toList() ??
          [],
      overallPoints: (json['overallPoints'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Create a copy of Team with modified fields
  Team copyWith({
    String? name,
    List<Player>? players,
    double? overallPoints,
  }) {
    return Team(
      name: name ?? this.name,
      players: players ?? this.players,
      overallPoints: overallPoints ?? this.overallPoints,
    );
  }

  @override
  String toString() =>
      'Team(name: $name, players: ${players.length}, overallPoints: $overallPoints)';
}
