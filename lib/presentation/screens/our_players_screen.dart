import 'package:flutter/material.dart';
import 'package:i_p_league/presentation/widgets/highlight_widgets.dart';
import 'package:provider/provider.dart';
import 'package:i_p_league/core/constants/colors.dart';
import 'package:i_p_league/data/models/team.dart';
import 'package:i_p_league/data/services/firestore_service.dart';
import 'package:i_p_league/presentation/state/auth_provider.dart';

class PlayerDetailsPage extends StatelessWidget {
  const PlayerDetailsPage({super.key});

  static String _normalizeEmail(String email) => email.trim().toLowerCase();

  static String _bestTeamMatch(String email, List<String> teamNames) {
    final normalizedEmail = _normalizeEmail(email);
    final localPart = normalizedEmail.split('@').first;

    if (teamNames.contains(normalizedEmail)) {
      return normalizedEmail;
    }
    if (teamNames.contains(localPart)) {
      return localPart;
    }

    final lowerTeams = teamNames.map((t) => t.toLowerCase()).toList();
    final exactContains = lowerTeams.firstWhere(
      (t) => t == localPart || t.contains(localPart) || localPart.contains(t),
      orElse: () => '',
    );

    if (exactContains.isNotEmpty) {
      final original = teamNames.firstWhere(
        (t) => t.toLowerCase() == exactContains,
      );
      return original;
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthenProvider>();
    final user = auth.user;

    if (user == null || user.email == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Our Player Details')),
        body: const Center(child: Text('Please sign in to view your details.')),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: stitchWhite),
        title: const Text('Our Player Details', style: TextStyle(color: stitchWhite)),
        backgroundColor: Colors.black87,
        elevation: 0,
      ),
      body: StreamBuilder<List<String>>(
        stream: FirestoreService.getTeamNamesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingHighlightWidget(loadingMessage: 'Loading players...');
          }
          if (snapshot.hasError) {
            return ErrorHighlightWidget(errorMessage: snapshot.error!);
          }

          final teamNames = snapshot.data ?? [];
          if (teamNames.isEmpty) {
            return NoTeamsHighlightWidget();
          }

          final teamName = _bestTeamMatch(user.email!, teamNames);
          if (teamName.isEmpty) {
            return const Center(child: Text('No team found for your account.'));
          }

          return StreamBuilder<Team>(
            stream: FirestoreService.getTeamStream(teamName),
            builder: (context, teamSnapshot) {
              if (teamSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (teamSnapshot.hasError) {
                return Center(child: Text('Error: ${teamSnapshot.error}'));
              }

              final team = teamSnapshot.data;
              if (team == null || team.players.isEmpty) {
                return const Center(
                  child: Text('No player data found for your team.'),
                );
              }

              final sortedPlayers = [...team.players]
                ..sort((a, b) => b.points.compareTo(a.points));

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: sortedPlayers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final player = sortedPlayers[index];

                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade900.withOpacity(0.85),
                      border: Border.all(
                        color: Colors.orange.shade600,
                        width: 1,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: index < 3
                            ? Colors.amber.shade700
                            : Colors.orange,
                        child: Text('${index + 1}'),
                      ),
                      title: Text(
                        player.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Team: ${team.name}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: Text(
                        player.points.toStringAsFixed(1),
                        style: TextStyle(
                          color: player.points >= 50
                              ? Colors.greenAccent
                              : Colors.orangeAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
