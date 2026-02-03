import 'package:flutter/material.dart';
import '../../data/services/fantasy_data_service.dart';

class PlayerLeaderboardScreen extends StatefulWidget {
  const PlayerLeaderboardScreen({super.key});

  @override
  State<PlayerLeaderboardScreen> createState() =>
      _PlayerLeaderboardScreenState();
}

class _PlayerLeaderboardScreenState extends State<PlayerLeaderboardScreen> {
  late Future<List<PlayerWithTeam>> _playerLeaderboardFuture;

  @override
  void initState() {
    super.initState();
    _playerLeaderboardFuture = FantasyDataService.getPlayerLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Player Leaderboard'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF1A1A1A),
      ),
      body: Container(
        color: const Color(0xFF0A0A0A),
        child: FutureBuilder<List<PlayerWithTeam>>(
          future: _playerLeaderboardFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }

            final players = snapshot.data ?? [];

            if (players.isEmpty) {
              return const Center(
                child: Text(
                  'No players found',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: players.length,
              itemBuilder: (context, index) {
                final playerWithTeam = players[index];
                final player = playerWithTeam.player;

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF121212),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Rank
                      SizedBox(
                        width: 30,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Player badge (Captain/VC)
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: player.isCaptain
                            ? const Color(0xFFD4AF37) // Gold for Captain
                            : player.isVC
                                ? const Color(0xFFC0C0C0) // Silver for VC
                                : const Color(0xFF7A2E24),
                        child: Center(
                          child: Text(
                            player.isCaptain
                                ? 'C'
                                : player.isVC
                                    ? 'V'
                                    : player.name.isNotEmpty
                                        ? player.name[0]
                                        : '?',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Player info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              player.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              playerWithTeam.teamName,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Points with multiplier indicator
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${player.points.toInt()} pts',
                            style: const TextStyle(
                              color: Color(0xFFD6D1CC),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            player.isCaptain
                                ? '(2x)'
                                : player.isVC
                                    ? '(1.5x)'
                                    : '(1x)',
                            style: TextStyle(
                              color: player.isCaptain
                                  ? const Color(0xFFD4AF37)
                                  : player.isVC
                                      ? const Color(0xFFC0C0C0)
                                      : Colors.grey,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
