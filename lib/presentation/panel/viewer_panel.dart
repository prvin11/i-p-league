import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/services/auth_service.dart';
import '../../utils/admin_panel_helper.dart';
import '../screens/leaderboard_screen.dart';
import '../screens/our_players_screen.dart';
import '../screens/players_screen.dart';
import '../state/auth_provider.dart';
import '../../core/constants/colors.dart';

class ViewerPanel extends StatefulWidget {
  const ViewerPanel({super.key});

  @override
  State<ViewerPanel> createState() => _ViewerPanelState();
}

class _ViewerPanelState extends State<ViewerPanel> {
  @override
  Widget build(BuildContext context) {
    final String teamName = context
        .read<AuthenProvider>()
        .userDisplayName()
        .toUpperCase();
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
        backgroundColor: bgColor,
        elevation: 0,
        actions: [
          Row(
            children: [
              Icon(Icons.person, color: Colors.orange.shade300, size: 16),
              const SizedBox(width: 6),
              Text(
                teamName,
                style: const TextStyle(color: stitchWhite, fontSize: 12),
              ),
            ],
          ),
          SizedBox(width: 10),
          IconButton(
            tooltip: 'Logout',
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
            colors: [bgColor, bgColor.withOpacity(0.8), bgColor],
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
                              'Welcome $teamName',
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
                      'Features',
                      style: TextStyle(
                        color: stitchWhite,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildCardWrapWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardWrapWidget() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        buildFeatureCard(
          context: context,
          title: 'Leaderboards',
          subtitle: 'View top-ranked teams and points table',
          icon: Icons.emoji_events,
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const LeaderboardsPage()));
          },
        ),
        buildFeatureCard(
          context: context,
          title: 'Overall Players',
          subtitle: 'See scores of all players in the league',
          icon: Icons.people_alt,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const OverallPlayersPage()),
            );
          },
        ),
        buildFeatureCard(
          context: context,
          title: 'Our Player Details',
          subtitle: 'Check your selected player performance',
          icon: Icons.person_search,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider(
                  create: (BuildContext context) =>
                      AuthenProvider(AuthRepository(AuthService())),
                  child: const PlayerDetailsPage(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
