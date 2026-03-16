import 'package:flutter/material.dart';
import 'package:i_p_league/presentation/widgets/Leaderboard_tile.dart';
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
  Widget _buildTeamsSection() {
    return StreamBuilder<List<Team>>(
      stream: getTeamsStream(),
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

        return LeaderboardTile(
          teams: teams,
          mounted: mounted,
          isAdminView: true,
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
        backgroundColor: Colors.black87,
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
              const SizedBox(height: 8),
              const Text(
                'Edit player names and points below',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 24),
              _buildTeamsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
