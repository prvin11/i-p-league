import 'package:flutter/material.dart';
import 'package:gully_11/presentation/widgets/Leaderboard_tile.dart';
import 'package:provider/provider.dart';

import '../../data/models/team.dart';
import '../../utils/admin_panel_helper.dart';
import '../state/auth_provider.dart';
import '../../core/constants/colors.dart';
import '../widgets/highlight_widgets.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildSearchSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900]!.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.orange.shade700.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Search & Update Players',
            style: TextStyle(
              color: stitchWhite,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            style: const TextStyle(color: stitchWhite),
            decoration: InputDecoration(
              hintText: 'Search players by name...',
              hintStyle: TextStyle(color: Colors.white38),
              prefixIcon: const Icon(Icons.search, color: Colors.orange),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white70),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.grey[800]!.withOpacity(0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.orange.shade700),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.orange.shade700.withOpacity(0.5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.orange, width: 2),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<Team> teams) {
    if (_searchQuery.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<Map<String, dynamic>> matchingPlayers = [];

    for (final team in teams) {
      for (final player in team.players) {
        if (player.name.toLowerCase().contains(_searchQuery)) {
          matchingPlayers.add({
            'player': player,
            'team': team,
          });
        }
      }
    }

    if (matchingPlayers.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900]!.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.orange.shade700.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: const Center(
          child: Text(
            'No players found matching your search',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.grey[900]!.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.orange.shade700.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Found ${matchingPlayers.length} player${matchingPlayers.length == 1 ? '' : 's'}:',
              style: const TextStyle(
                color: stitchWhite,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...matchingPlayers.map((match) {
            final player = match['player'] as dynamic;
            final team = match['team'] as Team;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade800, width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.person, color: Colors.white70, size: 18),
                  const SizedBox(width: 12),
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
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Team: ${team.name}',
                          style: TextStyle(color: Colors.blue.shade300, fontSize: 12),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Total: ${player.points.toStringAsFixed(1)} | Matchdays: ${player.matchdayPoints.length}/25',
                          style: TextStyle(color: Colors.blue.shade300.withOpacity(0.8), fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  // Quick Edit Button
                  Tooltip(
                    message: 'Quick Edit Player',
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () {
                        showEditPlayerDialog(
                          context,
                          team.name,
                          player.name,
                          player.points,
                          mounted,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.admin_panel_settings,
              color: Colors.orange.shade400,
              size: 28,
            ),
            const SizedBox(width: 8),
            const Text(
              'Admin Panel',
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Center(
              child: Text(
                context.read<AuthenProvider>().userDisplayName().toUpperCase(),
                style: const TextStyle(color: stitchWhite, fontSize: 14),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.logout, color: stitchWhite),
              onPressed: () async {
                await context.read<AuthenProvider>().logout();
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Manage Teams & Players',
                style: TextStyle(
                  color: stitchWhite,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildSearchSection(),
              StreamBuilder<List<Team>>(
                stream: getTeamsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingHighlightWidget(loadingMessage: 'Loading Teams...');
                  }
                  if (snapshot.hasError) {
                    return ErrorHighlightWidget(errorMessage: snapshot.error!);
                  }

                  final teams = snapshot.data ?? [];
                  if (teams.isEmpty) {
                    return NoTeamsHighlightWidget();
                  }

                  return Column(
                    children: [
                      _buildSearchResults(teams),
                      const SizedBox(height: 16),
                      const Text(
                        'All Teams',
                        style: TextStyle(
                          color: stitchWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      LeaderboardTile(
                        teams: teams,
                        mounted: mounted,
                        isAdminView: true,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
