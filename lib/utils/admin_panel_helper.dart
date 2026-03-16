import 'package:flutter/material.dart';
import 'package:i_p_league/core/constants/colors.dart';
import 'package:i_p_league/data/services/firestore_service.dart';

import '../data/models/team.dart';

Stream<List<Team>> getTeamsStream() {
  return FirestoreService.getTeamNamesStream().asyncExpand((teamNames) async* {
    final List<Team> teams = [];
    for (final name in teamNames) {
      final team = await FirestoreService.getTeamByName(name);
      teams.add(team);
    }
    yield teams;
  });
}

void showDeletePlayerDialog(
  BuildContext context,
  String teamName,
  String playerName,
  bool mounted,
) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Delete Player',
          style: TextStyle(color: stitchWhite, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete $playerName from $teamName?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () async {
              try {
                await FirestoreService.deletePlayer(teamName, playerName);
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Player deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting player: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}

void showEditPlayerDialog(
  BuildContext context,
  String teamName,
  String oldPlayerName,
  double currentPoints,
  bool mounted,
) {
  final nameController = TextEditingController(text: oldPlayerName);
  final pointsController = TextEditingController(
    text: currentPoints.toString(),
  );

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Edit Player',
          style: TextStyle(color: stitchWhite, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: stitchWhite),
              decoration: InputDecoration(
                labelText: 'Player Name',
                labelStyle: const TextStyle(color: Colors.white70),
                hintText: 'Enter player name',
                hintStyle: const TextStyle(color: Colors.white38),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.orange),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.orange, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.person, color: Colors.orange),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: pointsController,
              style: const TextStyle(color: stitchWhite),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Points',
                labelStyle: const TextStyle(color: Colors.white70),
                hintText: 'Enter points',
                hintStyle: const TextStyle(color: Colors.white38),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.orange),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.orange, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.score, color: Colors.orange),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () async {
              final newName = nameController.text.trim();
              final newPoints =
                  double.tryParse(pointsController.text.trim()) ?? 0.0;

              if (newName.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Player name cannot be empty'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              try {
                await FirestoreService.updatePlayerNameAndPoints(
                  teamName,
                  oldPlayerName,
                  newName,
                  newPoints,
                );

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Player updated successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error updating player: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Save', style: TextStyle(color: Colors.orange)),
          ),
        ],
      );
    },
  );
}
