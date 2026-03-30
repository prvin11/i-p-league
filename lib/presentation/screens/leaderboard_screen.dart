import 'package:flutter/material.dart';
import 'package:gully_11/data/services/firestore_service.dart';

import '../../core/constants/colors.dart';
import '../../data/models/team.dart';
import '../widgets/viewer_leaderboard_tile.dart';
import '../widgets/highlight_widgets.dart';

class LeaderboardsPage extends StatefulWidget {
  const LeaderboardsPage({super.key});

  @override
  State<LeaderboardsPage> createState() => _LeaderboardsPageState();
}

class _LeaderboardsPageState extends State<LeaderboardsPage> {
  Stream<List<Team>> _getTeamsStream() {
    return FirestoreService.getTeamNamesStream().asyncExpand((
      teamNames,
    ) async* {
      final List<Team> teams = [];
      for (final name in teamNames) {
        final team = await FirestoreService.getTeamByName(name);
        teams.add(team);
      }
      yield teams;
    });
  }

  Widget _buildTeamsSection() {
    return StreamBuilder<List<Team>>(
      stream: _getTeamsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingHighlightWidget(loadingMessage: 'Loading teams...');
        }
        if (snapshot.hasError) {
          return ErrorHighlightWidget(errorMessage: snapshot.error!);
        }

        final teams = snapshot.data ?? [];
        if (teams.isEmpty) {
          return NoTeamsHighlightWidget();
        }

        // sort teams by overall points descending for leaderboard-style
        final sortedTeams = [...teams]
          ..sort((a, b) => b.overallPoints.compareTo(a.overallPoints));

        return ViewerLeaderboardTile(teams: sortedTeams, mounted: mounted);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: stitchWhite),
        title: const Text('Leaderboards', style: TextStyle(color: stitchWhite)),
        backgroundColor: bgColor,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgColor, bgColor.withOpacity(0.8), bgColor],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [const SizedBox(height: 16), _buildTeamsSection()],
            ),
          ),
        ),
      ),
    );
  }
}
