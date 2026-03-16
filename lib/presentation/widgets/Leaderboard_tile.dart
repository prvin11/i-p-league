import 'package:flutter/material.dart';
import 'package:i_p_league/utils/admin_panel_helper.dart';

import '../../core/constants/colors.dart';
import '../../data/models/player.dart';
import '../../data/models/team.dart';

class LeaderboardTile extends StatelessWidget {
  const LeaderboardTile({
    super.key,
    required this.teams,
    required this.mounted,
    this.isAdminView = false,
  });

  final List<Team> teams;
  final bool mounted;
  final bool isAdminView;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: teams.asMap().entries.map((entry) {
        final index = entry.key;
        final team = entry.value;
        final rankColor = index < 3
            ? Colors.orange.shade700
            : Colors.grey.shade700;

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
            border: Border.all(
              color: Colors.orange.shade700.withOpacity(0.5),
              width: 1,
            ),
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
                  // rank badge
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: rankColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
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
              return isAdminView
                  ? AdminPanelSubTile(
                      player: player,
                      team: team,
                      mounted: mounted,
                    )
                  : ViewerPanelSubTile(player: player);
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

class AdminPanelSubTile extends StatelessWidget {
  const AdminPanelSubTile({
    super.key,
    required this.player,
    required this.team,
    required this.mounted,
  });

  final Team team;
  final Player player;
  final bool mounted;

  @override
  Widget build(BuildContext context) {
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
                  'Points: ${player.points.toStringAsFixed(1)}',
                  style: TextStyle(color: Colors.blue.shade300, fontSize: 12),
                ),
              ],
            ),
          ),
          // Edit Button
          Tooltip(
            message: 'Edit Player',
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
          // Delete Button
          Tooltip(
            message: 'Delete Player',
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                showDeletePlayerDialog(
                  context,
                  team.name,
                  player.name,
                  mounted,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ViewerPanelSubTile extends StatelessWidget {
  const ViewerPanelSubTile({super.key, required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade800, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.person, color: Colors.white70, size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              player.name,
              style: const TextStyle(color: Colors.white, fontSize: 14),
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
  }
}
