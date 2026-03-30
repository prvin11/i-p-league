import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gully_11/utils/helper.dart';
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
  /// Teams can be in legacy flat format (playerName: points) or new nested format:
  /// players: { playerName: { matchdayPoints: {1: 10.0, ...}, totalPoints: 70.0 } }
  static Future<Team> getTeamByName(String teamName) async {
    try {
      final DocumentSnapshot doc = await _db
          .collection('Teams')
          .doc(teamName)
          .get();
      if (!doc.exists) {
        return Team(name: teamName, players: [], overallPoints: 0.0);
      }

      final data = (doc.data() as Map<String, dynamic>?) ?? {};
      final players = <Player>[];

      if (data.containsKey('players') && data['players'] is Map) {
        final rawPlayers = Map<String, dynamic>.from(data['players'] as Map);
        rawPlayers.forEach((playerName, playerData) {
          final isCaptain = playerName.contains('(C)');
          final isVC = playerName.contains('(VC)');
          if (playerData is num) {
            players.add(
              Player(
                name: playerName,
                isCaptain: isCaptain,
                isVC: isVC,
                matchdayPoints: {},
                points: (playerData).toDouble(),
                iplTeam: '',
              ),
            );
          } else if (playerData is Map) {
            final map = Map<String, dynamic>.from(playerData);
            final rawMatchdayPoints = map['matchdayPoints'];
            final matchdayPoints = <int, double>{};

            if (rawMatchdayPoints is Map) {
              rawMatchdayPoints.forEach((k, v) {
                final idx = int.tryParse(k.toString());
                if (idx != null) {
                  matchdayPoints[idx] = (v as num?)?.toDouble() ?? 0.0;
                }
              });
            }

            final totalPoints =
                (map['totalPoints'] as num?)?.toDouble() ??
                matchdayPoints.values.fold<double>(
                  0.0,
                  (double sum, double v) => sum + v,
                );

            players.add(
              Player(
                name: playerName,
                isCaptain: isCaptain,
                isVC: isVC,
                matchdayPoints: matchdayPoints,
                points: totalPoints,
                iplTeam: '',
              ),
            );
          }
        });
      } else {
        data.forEach((key, value) {
          final isCaptain = key.contains('(C)');
          final isVC = key.contains('(VC)');
          if (value is num) {
            players.add(
              Player(
                name: key,
                isCaptain: isCaptain,
                isVC: isVC,
                matchdayPoints: {},
                points: value.toDouble(),
                iplTeam: '',
              ),
            );
          }
        });
      }

      final overall = players.fold<double>(
        0.0,
        (double sum, Player p) => sum + calculatePlayerPoints(p.isCaptain, p.isVC, p.points),
      );
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
    String teamName,
    String playerName,
    double points,
  ) async {
    try {
      await _db.collection('Teams').doc(teamName).update({playerName: points});
    } catch (e) {
      print('Error updating $playerName in $teamName: $e');
      rethrow;
    }
  }

  /// Replace an entire team document with given playerPoints map.
  /// keys are player names, values are point totals.
  static Future<void> setTeamPoints(
    String teamName,
    Map<String, double> playerPoints,
  ) async {
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

      if (data.containsKey('players') && data['players'] is Map) {
        final rawPlayers = Map<String, dynamic>.from(data['players'] as Map);
        rawPlayers.forEach((playerName, playerData) {
          final isCaptain = playerName.contains('(C)');
          final isVC = playerName.contains('(VC)');
          if (playerData is num) {
            players.add(
              Player(
                name: playerName,
                isCaptain: isCaptain,
                isVC: isVC,
                matchdayPoints: {},
                points: playerData.toDouble(),
                iplTeam: teamName,
              ),
            );
          } else if (playerData is Map) {
            final map = Map<String, dynamic>.from(playerData);
            final rawMatchdayPoints = map['matchdayPoints'];
            final matchdayPoints = <int, double>{};

            if (rawMatchdayPoints is Map) {
              rawMatchdayPoints.forEach((k, v) {
                final idx = int.tryParse(k.toString());
                if (idx != null) {
                  matchdayPoints[idx] = (v as num?)?.toDouble() ?? 0.0;
                }
              });
            }

            final totalPoints =
                (map['totalPoints'] as num?)?.toDouble() ??
                matchdayPoints.values.fold<double>(
                  0.0,
                  (double sum, double v) => sum + v,
                );

            players.add(
              Player(
                name: playerName,
                isCaptain: isCaptain,
                isVC: isVC,
                matchdayPoints: matchdayPoints,
                points: totalPoints,
                iplTeam: teamName,
              ),
            );
          }
        });
      } else {
        data.forEach((key, value) {
          final isCaptain = key.contains('(C)');
          final isVC = key.contains('(VC)');
          if (value is num) {
            players.add(
              Player(
                name: key,
                isCaptain: isCaptain,
                isVC: isVC,
                matchdayPoints: {},
                points: value.toDouble(),
                iplTeam: teamName,
              ),
            );
          }
        });
      }

      final overall = players.fold<double>(
        0.0,
        (double sum, Player p) => sum + calculatePlayerPoints(p.isCaptain, p.isVC, p.points),
      );
      return Team(name: teamName, players: players, overallPoints: overall);
    });
  }

  /// Streams all players from all teams, sorted by points descending.
  static Stream<List<Player>> getAllPlayersStream() {
    return getTeamNamesStream().asyncExpand((teamNames) async* {
      final allPlayers = <Player>[];

      for (final teamName in teamNames) {
        final team = await getTeamByName(teamName);
        allPlayers.addAll(
          team.players.map((p) => p.copyWith(iplTeam: teamName)).toList(),
        );
      }

      allPlayers.sort((a, b) => b.points.compareTo(a.points));
      yield allPlayers;
    });
  }

  /// Update a player's matchday score and keep totalPoints up to date.
  static Future<void> updatePlayerMatchdayPoints(
    String teamName,
    String oldPlayerName,
    String newPlayerName,
    int matchday,
    double matchdayPoints,
  ) async {
    if (matchday < 1 || matchday > 25) {
      throw ArgumentError('Matchday must be between 1 and 25');
    }

    final docRef = _db.collection('Teams').doc(teamName);
    final snap = await docRef.get();
    final data = snap.data() ?? {};

    Map<String, dynamic> playersMap = {};
    if (data.containsKey('players') && data['players'] is Map) {
      playersMap = Map<String, dynamic>.from(data['players'] as Map);
    } else {
      // Legacy format: top-level keys are players with total points.
      data.forEach((key, value) {
        if (value is num) {
          playersMap[key] = {
            'matchdayPoints': {},
            'totalPoints': (value).toDouble(),
          };
        }
      });
    }

    final oldRecord = playersMap[oldPlayerName];

    Map<int, double> matchdayMap = {};
    if (oldRecord is Map) {
      final existingMatchdays = oldRecord['matchdayPoints'];
      if (existingMatchdays is Map) {
        existingMatchdays.forEach((k, v) {
          final idx = int.tryParse(k.toString());
          if (idx != null) {
            matchdayMap[idx] = (v as num?)?.toDouble() ?? 0.0;
          }
        });
      }
    }

    matchdayMap[matchday] = matchdayPoints;
    final newTotal = matchdayMap.values.fold(0.0, (sum, v) => sum + v);

    final updatedRecord = {
      'matchdayPoints': matchdayMap.map((k, v) => MapEntry(k.toString(), v)),
      'totalPoints': newTotal,
    };

    if (oldPlayerName != newPlayerName) {
      playersMap.remove(oldPlayerName);
    }
    playersMap[newPlayerName] = updatedRecord;

    await docRef.set({'players': playersMap}, SetOptions(merge: true));
  }

  /// Update a player's name and total points in a team document.
  /// Keeps backward compatibility with legacy one-value format.
  static Future<void> updatePlayerNameAndPoints(
    String teamName,
    String oldPlayerName,
    String newPlayerName,
    double newPoints,
  ) async {
    try {
      final docRef = _db.collection('Teams').doc(teamName);
      final snap = await docRef.get();
      final data = snap.data() ?? {};

      if (data.containsKey('players')) {
        final playersMap = Map<String, dynamic>.from(data['players'] as Map);
        final oldRecord = playersMap[oldPlayerName];

        Map<int, double> matchdayMap = {};
        if (oldRecord is Map && oldRecord['matchdayPoints'] is Map) {
          (oldRecord['matchdayPoints'] as Map).forEach((k, v) {
            final idx = int.tryParse(k.toString());
            if (idx != null) {
              matchdayMap[idx] = (v as num?)?.toDouble() ?? 0.0;
            }
          });
        }

        // preserve matchdayPoints if present; otherwise, set a default matchday 1 value
        if (matchdayMap.isEmpty) {
          matchdayMap[1] = newPoints;
        }

        final updatedRecord = {
          'matchdayPoints': matchdayMap.map(
            (k, v) => MapEntry(k.toString(), v),
          ),
          'totalPoints': newPoints,
        };

        if (oldPlayerName != newPlayerName) {
          playersMap.remove(oldPlayerName);
        }
        playersMap[newPlayerName] = updatedRecord;

        await docRef.set({'players': playersMap}, SetOptions(merge: true));
      } else {
        // Legacy direct format
        if (oldPlayerName != newPlayerName) {
          await docRef.update({
            oldPlayerName: FieldValue.delete(),
            newPlayerName: newPoints,
          });
        } else {
          await docRef.update({newPlayerName: newPoints});
        }
      }
    } catch (e) {
      print('Error updating player in $teamName: $e');
      rethrow;
    }
  }

  /// Delete a player from a team document.
  static Future<void> deletePlayer(String teamName, String playerName) async {
    try {
      final docRef = _db.collection('Teams').doc(teamName);
      final snap = await docRef.get();
      final data = snap.data() ?? {};

      if (data.containsKey('players') && data['players'] is Map) {
        final playersMap = Map<String, dynamic>.from(data['players'] as Map);
        playersMap.remove(playerName);
        await docRef.set({'players': playersMap}, SetOptions(merge: true));
      } else {
        // Legacy format
        await docRef.update({playerName: FieldValue.delete()});
      }
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
      final docRef = _db.collection('Teams').doc(teamName);
      final snap = await docRef.get();
      final data = snap.data() ?? {};

      if (data.containsKey('players') && data['players'] is Map) {
        final playersMap = Map<String, dynamic>.from(data['players'] as Map);
        playersMap[playerName] = {'matchdayPoints': {}, 'totalPoints': points};
        await docRef.set({'players': playersMap}, SetOptions(merge: true));
      } else {
        // Legacy one-value format
        await docRef.update({playerName: points});
      }
    } catch (e) {
      print('Error adding player $playerName to $teamName: $e');
      rethrow;
    }
  }
}