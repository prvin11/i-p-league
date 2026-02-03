import 'package:flutter/material.dart';

import '../../data/models/team.dart';
import '../../data/services/fantasy_data_service.dart';
import 'leader_board.dart';

class CardView extends StatefulWidget {
  const CardView({super.key});

  @override
  State<CardView> createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  late Future<List<Team>> _teamLeaderboardFuture;

  @override
  void initState() {
    super.initState();
    _teamLeaderboardFuture = FantasyDataService.getTeamLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 500,
      child: Card(
        color: const Color(0xFF121212),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Team Leaderboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Team>>(
                future: _teamLeaderboardFuture,
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

                  final teams = snapshot.data ?? [];

                  return ListView.builder(
                    itemCount: teams.take(10).length,
                    itemBuilder: (context, index) {
                      final team = teams[index];
                      return LeaderboardRow(
                        rank: index + 1,
                        teamName: team.name,
                        points: team.overallPoints.toInt(),
                        iconPath: 'assets/login_bg.png',
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
