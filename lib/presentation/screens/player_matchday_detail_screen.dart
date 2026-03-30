import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../data/models/player.dart';

class PlayerMatchdayDetailScreen extends StatelessWidget {
  final Player player;
  final String teamName;

  const PlayerMatchdayDetailScreen({
    super.key,
    required this.player,
    required this.teamName,
  });

  @override
  Widget build(BuildContext context) {
    final sortedMatchdays = player.matchdayPoints.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: stitchWhite),
        title: const Text(
          'Player Matchday Details',
          style: TextStyle(color: stitchWhite),
        ),
        backgroundColor: bgColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Player Info Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.shade900.withOpacity(0.3),
                      Colors.orange.shade800.withOpacity(0.2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange.shade700, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.name,
                      style: const TextStyle(
                        color: stitchWhite,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Team: $teamName',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Points',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              player.points.toStringAsFixed(2),
                              style: TextStyle(
                                color: Colors.orange.shade300,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Matches Played',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${player.matchdayPoints.length}',
                              style: TextStyle(
                                color: Colors.blue.shade300,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Matchday Details Section
              if (sortedMatchdays.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade700, width: 1),
                  ),
                  child: const Center(
                    child: Text(
                      'No matches scores yet',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                )
              else ...[
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.orange.shade400,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Matchday Breakdown',
                      style: TextStyle(
                        color: stitchWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sortedMatchdays.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final matchday = sortedMatchdays[index].key;
                    final points = sortedMatchdays[index].value;

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade900.withOpacity(0.6),
                        border: Border.all(
                          color: Colors.orange.shade700.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Matchday $matchday',
                                style: const TextStyle(
                                  color: stitchWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'MD ${matchday.toString().padLeft(2, '0')}',
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: _getPointColor(points),
                              border: Border.all(
                                color: Colors.orange.shade700,
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              points.toStringAsFixed(1),
                              style: const TextStyle(
                                color: stitchWhite,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
              const SizedBox(height: 24),

              // Summary Stats
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade700, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Summary',
                      style: TextStyle(
                        color: stitchWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSummaryRow(
                      'Average per Matchday',
                      sortedMatchdays.isEmpty
                          ? '0.0'
                          : (player.points / sortedMatchdays.length)
                                .toStringAsFixed(2),
                    ),
                    const SizedBox(height: 8),
                    _buildSummaryRow(
                      'Highest Score',
                      sortedMatchdays.isEmpty
                          ? '0.0'
                          : sortedMatchdays
                                .map((e) => e.value)
                                .reduce((a, b) => a > b ? a : b)
                                .toStringAsFixed(2),
                    ),
                    const SizedBox(height: 8),
                    _buildSummaryRow(
                      'Lowest Score',
                      sortedMatchdays.isEmpty
                          ? '0.0'
                          : sortedMatchdays
                                .map((e) => e.value)
                                .reduce((a, b) => a < b ? a : b)
                                .toStringAsFixed(2),
                    ),
                    const SizedBox(height: 8),
                    _buildSummaryRow(
                      'Matchdays Remaining',
                      '${25 - sortedMatchdays.length}',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.orange.shade300,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getPointColor(double points) {
    if (points >= 20) {
      return Colors.green.shade900.withOpacity(0.4);
    } else if (points >= 10) {
      return Colors.orange.shade900.withOpacity(0.4);
    } else {
      return Colors.red.shade900.withOpacity(0.4);
    }
  }
}
