import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/team.dart';
import '../models/player.dart';

class FantasyDataService {
  /// Calculate points based on player role (Captain, VC, or Regular)
  static double _calculatePlayerPoints(Player player, double basePoints) {
    if (player.isCaptain) {
      return basePoints * 2.0; // Captain: 2x multiplier
    } else if (player.isVC) {
      return basePoints * 1.5; // Vice-Captain: 1.5x multiplier
    } else {
      return basePoints * 1.0; // Regular player: 1x multiplier
    }
  }

  /// Load fantasy data from JSON file
  static Future<List<Team>> loadFantasyData() async {
    try {
      final 
      
      uri = Uri.parse(
        'https://prvin11.github.io/host_api/fantasy.json',
      );
      final response = await http.get(uri);
      final Map<String, dynamic> jsonData = json.decode(response.body);

      final List<dynamic> teamsJson = jsonData['teams'] ?? [];

      return teamsJson.map((teamData) {
        List<Player> players = [];
        List<dynamic> playersJson = teamData['players'] ?? [];

        for (var playerData in playersJson) {
          // Each player is a Map with playerName: points
          playerData.forEach((playerName, points) {
            // Extract captain/VC status from player name
            bool isCaptain = playerName.toString().contains('(C)');
            bool isVC = playerName.toString().contains('(VC)');

            // Clean player name
            String cleanName = playerName
                .toString()
                .replaceAll('(C)', '')
                .replaceAll('(VC)', '')
                .trim();

            double basePoints = (points as num?)?.toDouble() ?? 0.0;

            players.add(
              Player(
                name: cleanName,
                isCaptain: isCaptain,
                isVC: isVC,
                points: _calculatePlayerPoints(
                  Player(
                    name: cleanName,
                    isCaptain: isCaptain,
                    isVC: isVC,
                    points: basePoints,
                    iplTeam: '',
                  ),
                  basePoints,
                ),
                iplTeam: '',
              ),
            );
          });
        }

        // Calculate overall team points (sum of all calculated player points)
        double overallPoints = players.fold(
          0.0,
          (sum, player) => sum + player.points,
        );

        return Team(
          name: teamData['team_name'] ?? 'Unknown Team',
          players: players,
          overallPoints: overallPoints,
        );
      }).toList();
    } catch (e) {
      print('Error loading fantasy data: $e');
      return [];
    }
  }

  /// Get sorted team leaderboard by calculated overall points
  static Future<List<Team>> getTeamLeaderboard() async {
    final teams = await loadFantasyData();
    teams.sort((a, b) => b.overallPoints.compareTo(a.overallPoints));
    return teams;
  }

  /// Get sorted player leaderboard across all teams by calculated points
  static Future<List<PlayerWithTeam>> getPlayerLeaderboard() async {
    final teams = await loadFantasyData();
    final List<PlayerWithTeam> allPlayers = [];

    for (var team in teams) {
      for (var player in team.players) {
        allPlayers.add(PlayerWithTeam(player: player, teamName: team.name));
      }
    }

    allPlayers.sort((a, b) => b.player.points.compareTo(a.player.points));
    return allPlayers;
  }
}

/// Helper class to include team name with player
class PlayerWithTeam {
  final Player player;
  final String teamName;

  PlayerWithTeam({required this.player, required this.teamName});
}
