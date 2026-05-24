import 'package:flutter/material.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  // Leaderboard data including the ProfilePage user (Jamie Nelson)
  // In a real application, this data would come from a backend service.
  static const List<Map<String, dynamic>> leaderboard = [
    {"name": "Ali", "points": 120, "workoutsCompleted": 8},
    {"name": "Sara", "points": 100, "workoutsCompleted": 7},
    {"name": "Jamie Nelson", "points": 95, "workoutsCompleted": 6}, // Profile user
    {"name": "Ravi", "points": 90, "workoutsCompleted": 5},
    {"name": "Maya", "points": 85, "workoutsCompleted": 4},
    {"name": "John", "points": 75, "workoutsCompleted": 3},
  ];

  // Placeholder for the current user's name.
  // In a real app, this would be passed in or retrieved from a user management system.
  static const String _currentUserName = 'Jamie Nelson';

  // Colors for top 3 ranks and others, aligned with ProfilePage/WorkplanPage theme
  Color _getNameColor(int index) {
    switch (index) {
      case 0:
        return Colors.orangeAccent; // Matches orange accents
      case 1:
        return Colors.teal; // Matches ProfilePage teal
      case 2:
        return Colors.white70; // Slightly dimmed white for consistency
      default:
        return Colors.white;
    }
  }

  // No change needed for card color, consistent with theme
  Color _getCardColor(int index) {
    return Colors.grey[850]!; // Consistent with ProfilePage/WorkplanPage cards
  }

  // No change needed for point color, consistent with theme
  Color _getPointColor(int index) {
    return Colors.white; // White for all points to match theme
  }

  @override
  Widget build(BuildContext context) {
    // Determine the maximum points for progress bar normalization
    final double maxPoints = leaderboard.isNotEmpty
        ? leaderboard.map((user) => user['points'] as int).reduce((a, b) => a > b ? a : b).toDouble()
        : 1.0; // Avoid division by zero if leaderboard is empty

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C), // Matches ProfilePage/WorkplanPage
      appBar: AppBar(
        title: const Text(
          'Friends Leaderboard',
          style: TextStyle(color: Colors.white),
          semanticsLabel: 'Friends Leaderboard',
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            '🏆 Top Performers of the Week',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            semanticsLabel: 'Top Performers of the Week',
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: leaderboard.length,
              itemBuilder: (context, index) {
                final user = leaderboard[index];
                // Use the static _currentUserName for comparison
                final isCurrentUser = user['name'] == _currentUserName;
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      // Highlight current user with a distinct border color
                      color: isCurrentUser ? Colors.orangeAccent : Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: _getCardColor(index),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Semantics(
                        label: 'Rank ${index + 1}',
                        child: CircleAvatar(
                          // Current user's avatar might have a distinct color
                          backgroundColor: isCurrentUser ? Colors.teal : Colors.deepOrangeAccent, // Changed a bit for current user
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      title: Text(
                        user['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getNameColor(index),
                          fontSize: 16,
                        ),
                        semanticsLabel: user['name'],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            '${user['workoutsCompleted']} workouts completed',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                            semanticsLabel: '${user['workoutsCompleted']} workouts completed',
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            // Dynamically normalize to maxPoints
                            value: maxPoints > 0 ? (user['points'] as int) / maxPoints : 0.0,
                            backgroundColor: Colors.grey,
                            color: Colors.teal, // Matches ProfilePage
                            minHeight: 4,
                          ),
                        ],
                      ),
                      trailing: Semantics(
                        label: '${user['points']} points',
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: Colors.orangeAccent, size: 20),
                            const SizedBox(width: 5),
                            Text(
                              '${user['points']} pts',
                              style: TextStyle(
                                color: _getPointColor(index),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}