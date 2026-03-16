import 'package:flutter/material.dart';
import 'package:i_p_league/presentation/widgets/Leaderboard_tile.dart';
import 'package:i_p_league/presentation/widgets/highlight_widgets.dart';
import 'package:provider/provider.dart';

import '../state/auth_provider.dart';
import '../../core/constants/colors.dart';
import '../../data/services/firestore_service.dart';
import '../../data/models/team.dart';

class ViewerPanel extends StatefulWidget {
  const ViewerPanel({super.key});

  @override
  State<ViewerPanel> createState() => _ViewerPanelState();
}

class _ViewerPanelState extends State<ViewerPanel> {
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
          return LoadingHighlightWidget();
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

        return LeaderboardTile(teams: sortedTeams, mounted: mounted);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.sports_cricket, color: Colors.orange.shade400, size: 28),
            const SizedBox(width: 12),
            const Text(
              'Viewer Panel',
              style: TextStyle(
                color: stitchWhite,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black87,
        elevation: 0,
        actions: [
          Row(
            children: [
              Icon(Icons.person, color: Colors.orange.shade300, size: 16),
              const SizedBox(width: 6),
              Text(
                context.read<AuthenProvider>().userDisplayName().toUpperCase(),
                style: const TextStyle(color: stitchWhite, fontSize: 12),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: stitchWhite),
            onPressed: () async {
              await context.read<AuthenProvider>().logout();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgColor, bgColor.withOpacity(0.8), Colors.black87],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.shade900.withOpacity(0.3),
                        Colors.orange.shade800.withOpacity(0.2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.orange.shade700, width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade700,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.waving_hand,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome Back!',
                              style: TextStyle(
                                color: Colors.orange.shade300,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Explore the IPL Fantasy League',
                              style: TextStyle(
                                color: stitchWhite,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Teams Section Header
                Row(
                  children: [
                    Icon(Icons.groups, color: Colors.orange.shade400, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Leaderboard',
                      style: TextStyle(
                        color: stitchWhite,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTeamsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
