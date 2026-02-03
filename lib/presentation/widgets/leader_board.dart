import 'package:flutter/material.dart';

class LeaderboardRow extends StatelessWidget {
  final int rank;
  final String teamName;
  final int points;
  final String iconPath;

  const LeaderboardRow({
    super.key,
    required this.rank,
    required this.teamName,
    required this.points,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // 1️⃣ S.No
          SizedBox(
            width: 30,
            child: Text(
              '$rank',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // 2️⃣ Icon
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF7A2E24),
            child: Image.asset(
              iconPath,
              width: 18,
              height: 18,
            ),
          ),

          const SizedBox(width: 12),

          // 3️⃣ Team Name
          Expanded(
            child: Text(
              teamName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // 4️⃣ Points
          Text(
            '$points pts',
            style: const TextStyle(
              color: Color(0xFFD6D1CC),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}