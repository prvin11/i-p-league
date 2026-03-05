import 'package:flutter/material.dart';
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
    return FirestoreService.getTeamNamesStream().asyncExpand((teamNames) async* {
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
          return Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.orange),
                  SizedBox(height: 16),
                  Text(
                    'Loading Teams...',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.shade900.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red.shade700),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red.shade400, size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Error loading teams: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }

        final teams = snapshot.data ?? [];
        if (teams.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade700),
            ),
            child: const Center(
              child: Column(
                children: [
                  Icon(Icons.group_off, color: Colors.grey, size: 48),
                  SizedBox(height: 16),
                  Text(
                    'No fantasy teams available yet.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: teams.map((team) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey[900]!.withOpacity(0.8),
                    Colors.grey[850]!.withOpacity(0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange.shade700.withOpacity(0.5), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.shade900.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ExpansionTile(
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade700.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.group,
                          color: Colors.orange.shade400,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          team.name,
                          style: const TextStyle(
                            color: stitchWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade700,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          team.overallPoints.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                children: team.players.map((player) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade800, width: 0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.white70,
                          size: 16,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            player.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade900.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.shade700, width: 0.5),
                          ),
                          child: Text(
                            player.points.toStringAsFixed(1),
                            style: TextStyle(
                              color: Colors.blue.shade300,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        );
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
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange.shade900.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.orange.shade700, width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.person, color: Colors.orange.shade300, size: 16),
                const SizedBox(width: 6),
                Text(
                  context.read<AuthenProvider>().user?.email ?? 'Viewer',
                  style: const TextStyle(color: stitchWhite, fontSize: 12),
                ),
              ],
            ),
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
            colors: [
              bgColor,
              bgColor.withOpacity(0.8),
              Colors.black87,
            ],
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
                      'Fantasy Teams',
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

                const SizedBox(height: 32),

                // Features Section Header
                Row(
                  children: [
                    Icon(Icons.explore, color: Colors.orange.shade400, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Explore Features',
                      style: TextStyle(
                        color: stitchWhite,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Feature Cards Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildFeatureCard(
                      title: 'Leaderboard',
                      subtitle: 'View Rankings',
                      icon: Icons.leaderboard,
                      gradient: [Colors.blue.shade900, Colors.blue.shade700],
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const LeaderboardPage()),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      title: 'Statistics',
                      subtitle: 'Team Analytics',
                      icon: Icons.bar_chart,
                      gradient: [Colors.green.shade900, Colors.green.shade700],
                      onTap: () {
                        _showSnackBar('View Team Statistics');
                      },
                    ),
                    _buildFeatureCard(
                      title: 'Schedule',
                      subtitle: 'Match Timings',
                      icon: Icons.schedule,
                      gradient: [Colors.purple.shade900, Colors.purple.shade700],
                      onTap: () {
                        _showSnackBar('View Match Schedule');
                      },
                    ),
                    _buildFeatureCard(
                      title: 'Players',
                      subtitle: 'Player Profiles',
                      icon: Icons.person_outline,
                      gradient: [Colors.teal.shade900, Colors.teal.shade700],
                      onTap: () {
                        _showSnackBar('View Player Profiles');
                      },
                    ),
                    _buildFeatureCard(
                      title: 'Live Scores',
                      subtitle: 'Real-time Updates',
                      icon: Icons.sports_cricket,
                      gradient: [Colors.red.shade900, Colors.red.shade700],
                      onTap: () {
                        _showSnackBar('View Live Scores');
                      },
                    ),
                    _buildFeatureCard(
                      title: 'Settings',
                      subtitle: 'Preferences',
                      icon: Icons.settings,
                      gradient: [Colors.grey.shade900, Colors.grey.shade700],
                      onTap: () {
                        _showSnackBar('Open Settings');
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange.shade700,
      ),
    );
  }
}

/// Page displaying the leaderboard of teams.
class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  Future<List<Team>> _loadTeams() async {
    final names = await FirestoreService.getTeamNames();
    return FirestoreService.getTeams(names);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.leaderboard, color: Colors.orange.shade400, size: 24),
            const SizedBox(width: 12),
            const Text(
              'Leaderboard',
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
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              bgColor,
              bgColor.withOpacity(0.8),
              Colors.black87,
            ],
          ),
        ),
        child: FutureBuilder<List<Team>>(
          future: _loadTeams(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.orange),
                    SizedBox(height: 16),
                    Text(
                      'Loading Leaderboard...',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade900.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.red.shade700),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade400, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }
            final teams = (snapshot.data ?? [])
              ..sort((a, b) => b.overallPoints.compareTo(a.overallPoints));
            if (teams.isEmpty) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade700),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.leaderboard, color: Colors.grey, size: 48),
                      SizedBox(height: 16),
                      Text(
                        'No teams found',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: teams.length,
              itemBuilder: (context, index) {
                final team = teams[index];
                final isTopThree = index < 3;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isTopThree
                          ? [
                              Colors.orange.shade900.withOpacity(0.3),
                              Colors.orange.shade800.withOpacity(0.2),
                            ]
                          : [
                              Colors.grey[900]!.withOpacity(0.8),
                              Colors.grey[850]!.withOpacity(0.6),
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isTopThree
                          ? Colors.orange.shade700
                          : Colors.grey.shade700,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isTopThree
                              ? Colors.orange.shade700
                              : Colors.grey.shade700,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              team.name,
                              style: TextStyle(
                                color: stitchWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${team.players.length} players',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade700,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          team.overallPoints.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
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
