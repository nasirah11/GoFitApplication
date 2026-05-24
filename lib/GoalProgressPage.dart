

import 'package:flutter/material.dart';

class GoalProgressPage extends StatefulWidget {
  const GoalProgressPage({super.key});

  @override
  State<GoalProgressPage> createState() => _GoalProgressPageState();
}

class _GoalProgressPageState extends State<GoalProgressPage> {
  final TextEditingController _goalController = TextEditingController();
  String _selectedCategory = 'Mind'; // Default category
  final List<String> _categories = ['Mind', 'Body', 'Nutrition', 'Sleep'];
  final List<Map<String, dynamic>> goals = [
    {'task': 'Meditate for 10 minutes', 'category': 'Mind', 'done': false},
    {'task': 'Eat a vegetable-based meal', 'category': 'Nutrition', 'done': false},
    {'task': 'Sleep 7 hours', 'category': 'Sleep', 'done': false},
    {'task': 'Practice deep breathing', 'category': 'Mind', 'done': false},
  ];

  final Map<int, int> streakPoints = {};
  bool streakAchievedToday = false;

  int get completedGoals => goals.where((g) => g['done']).length;
  int get totalGoals => goals.length;

  void _addGoal() {
    if (_goalController.text.trim().isNotEmpty) {
      setState(() {
        goals.add({
          'task': _goalController.text.trim(),
          'category': _selectedCategory,
          'done': false
        });
        _goalController.clear();
      });
    }
  }

  void _checkStreakTrigger() {
    int today = DateTime.now().weekday % 7;
    if (!streakAchievedToday && completedGoals == totalGoals) {
      setState(() {
        streakPoints[today] = (streakPoints[today] ?? 0) + 10;
        streakAchievedToday = true;
      });
    } else if (completedGoals < totalGoals && streakAchievedToday) {
      setState(() {
        streakPoints[today] = (streakPoints[today] ?? 0) - 10;
        streakAchievedToday = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = completedGoals / (totalGoals == 0 ? 1 : totalGoals);
    int today = DateTime.now().weekday % 7;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text(
          'Wellness Goals',
          style: TextStyle(color: Colors.white),
          semanticsLabel: ' Wellness Goals',
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Monday's Wellness Journey",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              semanticsLabel: "Monday's Wellness Journey",
            ),
            const SizedBox(height: 10),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey[800],
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.teal),
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    semanticsLabel: '${(progress * 100).toInt()} percent complete',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  ...goals.asMap().entries.map(
                    (entry) => Card(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.grey[850],
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(
                          entry.value['task'],
                          style: TextStyle(
                            color: Colors.white,
                            decoration: entry.value['done']
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                          semanticsLabel: entry.value['task'],
                        ),
                        subtitle: Text(
                          entry.value['category'],
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                          semanticsLabel: 'Category: ${entry.value['category']}',
                        ),
                        trailing: Switch(
                          value: entry.value['done'],
                          onChanged: (val) {
                            setState(() => goals[entry.key]['done'] = val);
                            _checkStreakTrigger();
                          },
                          activeColor: Colors.teal,
                          inactiveThumbColor: Colors.grey,
                          inactiveTrackColor: Colors.grey[600],
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _selectedCategory,
                                items: _categories
                                    .map((category) => DropdownMenuItem(
                                          value: category,
                                          child: Text(
                                            category,
                                            style:
                                                const TextStyle(color: Colors.white),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCategory = value!;
                                  });
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[850],
                                  labelText: 'Category',
                                  labelStyle:
                                      const TextStyle(color: Colors.white70),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                dropdownColor: Colors.grey[850],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _goalController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[850],
                                  hintText: 'Add new goal...',
                                  hintStyle:
                                      const TextStyle(color: Colors.white54),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: _addGoal,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Goal'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white70),
            const Text(
              "🔥 Weekly Wellness Streak",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              semanticsLabel: "Weekly Wellness Streak",
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                final isToday = index == today;
                final isCompleted = (streakPoints[index] ?? 0) > 0;
                final points = streakPoints[index] ?? 0;
                return Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: isCompleted
                          ? Colors.teal
                          : isToday
                              ? Colors.orangeAccent
                              : Colors.grey,
                      radius: 18,
                      child: Text(
                        ['S', 'M', 'T', 'W', 'T', 'F', 'S'][index],
                        style: TextStyle(
                          color: isToday ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '+$points',
                      style: const TextStyle(fontSize: 12, color: Colors.white70),
                      semanticsLabel: '$points points',
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 10),
            if (streakAchievedToday)
              const Center(
                child: Text(
                  "🎉 Streak Achieved! +10 Bonus",
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  semanticsLabel: "Streak Achieved, 10 Bonus Points",
                ),
              ),
          ],
        ),
      ),
    );
  }
}
