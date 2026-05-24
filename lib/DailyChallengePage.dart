import 'dart:math';
import 'package:flutter/material.dart';

class DailyChallengePage extends StatefulWidget {
  const DailyChallengePage({super.key});

  @override
  State<DailyChallengePage> createState() => _DailyChallengePageState();
}

class _DailyChallengePageState extends State<DailyChallengePage> {
  final List<String> challenges = const [
    "🔥 Do 20 squats",
    "🏃‍♂️ Run for 15 minutes",
    "🧘‍♂️ Hold a plank for 1 minute",
    "🤸‍♀️ Do 50 jumping jacks",
    "🚶 Walk 5,000 steps",
    "💧 Drink 8 glasses of water",
    "🧠 Meditate for 5 minutes",
    "🪷 Stretch for 10 minutes",
  ];

  String currentChallenge = "";
  bool completed = false;
  int dailyPoints = 0;
  int streak = 0;

  void generateChallenge() {
    final random = Random();
    setState(() {
      currentChallenge = challenges[random.nextInt(challenges.length)];
      completed = false;
    });
  }

  void completeChallenge() {
    setState(() {
      completed = true;
      dailyPoints += 10;
      streak += 1;
    });
  }

  @override
  void initState() {
    super.initState();
    generateChallenge();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text(
          'Daily Challenge',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Today's Challenge",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              color: completed ? Colors.teal : Colors.grey[850],
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Text(
                  currentChallenge,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: completed ? null : completeChallenge,
              icon: const Icon(Icons.check_circle),
              label: const Text('Complete Challenge'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: generateChallenge,
              icon: const Icon(Icons.refresh),
              label: const Text('New Challenge'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 30),
            Divider(color: Colors.grey[700]),
            Text('🔥 Streak: $streak days',
                style: const TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text('🎯 Points Earned: $dailyPoints',
                style: const TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
