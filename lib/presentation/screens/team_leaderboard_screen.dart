import 'package:flutter/material.dart';
import '../../data/models/team.dart';
import '../../data/services/fantasy_data_service.dart';
import '../widgets/leader_board.dart';

class TeamLeaderboardScreen extends StatefulWidget {
  const TeamLeaderboardScreen({super.key});

  @override
  State<TeamLeaderboardScreen> createState() => _TeamLeaderboardScreenState();
}

class _TeamLeaderboardScreenState extends State<TeamLeaderboardScreen> {
  late Future<List<Team>> _teamLeaderboardFuture;

  @override
  void initState() {
    super.initState();
    _teamLeaderboardFuture = FantasyDataService.getTeamLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Leaderboard'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF1A1A1A),
      ),
      body: Container(
        color: const Color(0xFF0A0A0A),
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

            if (teams.isEmpty) {
              return const Center(
                child: Text(
                  'No teams found',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: teams.length,
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
    );
  }
}
