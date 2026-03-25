import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/player.dart';
import '../models/team.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Fetch all team names from Firestore.
  /// Each document in the 'Teams' collection corresponds to a team and
  /// the document ID itself is the team name.
  static Future<List<String>> getTeamNames() async {
    try {
      final QuerySnapshot snapshot = await _db.collection('Teams').get();
      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('Error fetching team names: $e');
      return [];
    }
  }

  /// Stream of team names (real-time updates)
  static Stream<List<String>> getTeamNamesStream() {
    return _db.collection('Teams').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  /// Fetch a single fantasy team by name.
  /// In the 'Teams' collection each team document has player names as
  /// fields; the field value is the player's points (number).
  static Future<Team> getTeamByName(String teamName) async {
    try {
      final DocumentSnapshot doc =
          await _db.collection('Teams').doc(teamName).get();
      if (!doc.exists) {
        return Team(name: teamName, players: [], overallPoints: 0.0);
      }

      final data = doc.data() as Map<String, dynamic>? ?? {};
      final players = <Player>[];

      data.forEach((key, value) {
        final points = value.toDouble();
        players.add(
          Player(
            name: key,
            isCaptain: false,
            isVC: false,
            points: points,
            iplTeam: '',
          ),
        );
      });

      final overall = players.fold<double>(0.0, (sum, p) => sum + p.points);
      return Team(name: teamName, players: players, overallPoints: overall);
    } catch (e) {
      print('Error fetching team $teamName: $e');
      return Team(name: teamName, players: [], overallPoints: 0.0);
    }
  }

  /// Fetch multiple teams given a list of collection names.
  static Future<List<Team>> getTeams(List<String> teamNames) async {
    final List<Team> teams = [];
    for (final name in teamNames) {
      final team = await getTeamByName(name);
      teams.add(team);
    }
    return teams;
  }

  /// Update a single player's points in a team document.
  static Future<void> updatePlayerPoints(
      String teamName, String playerName, double points) async {
    try {
      await _db
          .collection('Teams')
          .doc(teamName)
          .update({playerName: points});
    } catch (e) {
      print('Error updating $playerName in $teamName: $e');
      rethrow;
    }
  }

  /// Replace an entire team document with given playerPoints map.
  /// keys are player names, values are point totals.
  static Future<void> setTeamPoints(
      String teamName, Map<String, double> playerPoints) async {
    try {
      await _db.collection('Teams').doc(teamName).set(playerPoints);
    } catch (e) {
      print('Error setting team $teamName points: $e');
      rethrow;
    }
  }

  /// Stream a single team (realtime updates) from the Teams document.
  static Stream<Team> getTeamStream(String teamName) {
    return _db.collection('Teams').doc(teamName).snapshots().map((doc) {
      final data = doc.data() ?? {};
      final players = <Player>[];

      data.forEach((key, value) {
        final points = (value as num?)?.toDouble() ?? 0.0;
        players.add(Player(
          name: key,
          isCaptain: false,
          isVC: false,
          points: points,
          iplTeam: teamName,
        ));
      });

      final overall = players.fold<double>(0.0, (sum, p) => sum + p.points);
      return Team(name: teamName, players: players, overallPoints: overall);
    });
  }

  /// Streams all players from all teams, sorted by points descending.
  static Stream<List<Player>> getAllPlayersStream() {
    return getTeamNamesStream().asyncExpand((teamNames) async* {
      final allPlayers = <Player>[];

      for (final teamName in teamNames) {
        final team = await getTeamByName(teamName);
        allPlayers.addAll(team.players
            .map((p) => p.copyWith(iplTeam: teamName))
            .toList());
      }

      allPlayers.sort((a, b) => b.points.compareTo(a.points));
      yield allPlayers;
    });
  }

  /// Update a player's name and points in a team document.
  /// This deletes the old player entry and creates a new one with the updated name and points.
  static Future<void> updatePlayerNameAndPoints(
    String teamName,
    String oldPlayerName,
    String newPlayerName,
    double newPoints,
  ) async {
    try {
      final docRef = _db.collection('Teams').doc(teamName);
      
      // If name changed, delete old entry and create new one
      if (oldPlayerName != newPlayerName) {
        await docRef.update({
          oldPlayerName: FieldValue.delete(),
          newPlayerName: newPoints,
        });
      } else {
        // Only points changed
        await docRef.update({newPlayerName: newPoints});
      }
    } catch (e) {
      print('Error updating player in $teamName: $e');
      rethrow;
    }
  }

  /// Delete a player from a team document.
  static Future<void> deletePlayer(String teamName, String playerName) async {
    try {
      await _db.collection('Teams').doc(teamName).update({
        playerName: FieldValue.delete(),
      });
    } catch (e) {
      print('Error deleting player $playerName from $teamName: $e');
      rethrow;
    }
  }

  /// Add a new player to a team document.
  static Future<void> addPlayer(
    String teamName,
    String playerName,
    double points,
  ) async {
    try {
      await _db.collection('Teams').doc(teamName).update({
        playerName: points,
      });
    } catch (e) {
      print('Error adding player $playerName to $teamName: $e');
      rethrow;
    }
  }
}
