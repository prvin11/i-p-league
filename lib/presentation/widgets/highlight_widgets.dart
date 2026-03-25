import 'package:flutter/material.dart';

class NoTeamsHighlightWidget extends StatelessWidget {
  const NoTeamsHighlightWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: const Center(
        child: Column(
          children: [
            Icon(Icons.group_off, color: Colors.grey, size: 48),
            SizedBox(height: 16),
            Text(
              'No fantasy teams available yet.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorHighlightWidget extends StatelessWidget {
  const ErrorHighlightWidget({super.key, required this.errorMessage});

  final Object errorMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade900.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade700),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade400, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Error loading teams: $errorMessage',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingHighlightWidget extends StatelessWidget {
  const LoadingHighlightWidget({super.key, required this.loadingMessage});

  final String loadingMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.orange),
            SizedBox(height: 16),
            Text(loadingMessage, style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
