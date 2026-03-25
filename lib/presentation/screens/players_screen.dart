import 'package:flutter/material.dart';
import 'package:i_p_league/data/models/player.dart';
import 'package:i_p_league/data/services/firestore_service.dart';
import 'package:i_p_league/core/constants/colors.dart';
import 'package:i_p_league/presentation/widgets/highlight_widgets.dart';

import '../widgets/Players_tile.dart';

class OverallPlayersPage extends StatelessWidget {
  const OverallPlayersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Overall Players', style: TextStyle(color: stitchWhite)),
        iconTheme: IconThemeData(color: stitchWhite),
        backgroundColor: Colors.black87,
      ),
      body: StreamBuilder<List<Player>>(
        stream: FirestoreService.getAllPlayersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingHighlightWidget(loadingMessage: 'Loading players...');
          }
          if (snapshot.hasError) {
            return ErrorHighlightWidget(errorMessage: snapshot.error!);
          }

          final players = snapshot.data ?? [];
          if (players.isEmpty) {
            return NoTeamsHighlightWidget();
          }

          return PlayersTile(players: players);
        },
      ),
    );
  }
}
