import 'package:flutter/material.dart';
import 'package:gully_11/utils/admin_panel_helper.dart';

import '../../data/models/player.dart';
import '../../data/models/team.dart';

class ViewerLeaderboardTile extends StatelessWidget {
  const ViewerLeaderboardTile({
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
        final rankColor = index == 0
            ? Colors.greenAccent
            : index == 1
            ? Colors.lightGreenAccent
            : index == 2
            ? Colors.limeAccent
            : Colors.grey.shade400;

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey[850]!.withOpacity(0.9),
                Colors.grey[900]!.withOpacity(0.6),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.greenAccent.shade400.withOpacity(0.7),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.greenAccent.shade400.withOpacity(0.25),
                blurRadius: 18,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ExpansionTile(
            collapsedBackgroundColor: Colors.black.withOpacity(0.22),
            backgroundColor: Colors.black.withOpacity(0.1),
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: rankColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: rankColor.withOpacity(0.45),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.shade100.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.people,
                    color: Colors.greenAccent,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        team.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${team.players.length} players',
                        style: TextStyle(
                          color: Colors.greenAccent.shade100,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.greenAccent.shade400,
                        Colors.green.shade700,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.greenAccent.shade400.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    team.overallPoints.toStringAsFixed(0),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
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
                  'Total: ${player.points.toStringAsFixed(1)}',
                  style: TextStyle(color: Colors.blue.shade300, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  'Matchdays: ${player.matchdayPoints.length} / 25',
                  style: TextStyle(
                    color: Colors.blue.shade300.withOpacity(0.8),
                    fontSize: 11,
                  ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  'MDs: ${player.matchdayPoints.length}/25',
                  style: const TextStyle(color: Colors.white60, fontSize: 10),
                ),
              ],
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
