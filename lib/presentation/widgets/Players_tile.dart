import 'package:flutter/material.dart';

import '../../data/models/player.dart';

class PlayersTile extends StatelessWidget {
  const PlayersTile({super.key, required this.players});

  final List<Player> players;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: players.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final player = players[index];

        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade900.withOpacity(0.85),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.shade600, width: 1),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: index < 3
                  ? Colors.amber.shade700
                  : Colors.orange,
              child: Text(
                '${index + 1}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              player.name,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              'Team: ${player.iplTeam.isNotEmpty ? player.iplTeam : 'Unknown'}',
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Points',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  player.points.toStringAsFixed(1),
                  style: TextStyle(
                    color: player.points >= 50
                        ? Colors.greenAccent
                        : Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
