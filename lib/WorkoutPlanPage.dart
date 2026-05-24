import 'package:flutter/material.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';

class WorkoutPlanPage extends StatefulWidget {
  const WorkoutPlanPage({super.key});

  @override
  _WorkoutPlanPageState createState() => _WorkoutPlanPageState();
}

class _WorkoutPlanPageState extends State<WorkoutPlanPage> {
  // Monday workout data aligned with ProfilePage
  // Changed to an instance variable so that each WorkoutPlanPage instance
  // can have its own mutable state for workouts.
  List<Map<String, dynamic>> workouts = [
    {
      "day": "Monday",
      "sessions": [
        {
          "title": "Morning Workout",
          "focus": "Full Body Strength",
          "duration": "45 min",
          "level": "Intermediate",
          "exercises": [
            {"name": "Squats - 3 sets x 15 reps", "completed": false},
            {"name": "Push-ups - 3 sets x 12 reps", "completed": false},
            {"name": "Lunges - 3 sets x 12 reps per leg", "completed": false},
            {"name": "Plank - 3 sets x 1 min", "completed": false},
            {"name": "Deadlifts - 3 sets x 10 reps", "completed": false},
          ],
          "metrics": [9, 6, 7, 8, 5],
          // Initialize 'done' and 'total' to 0; they will be calculated in _initializeProgress
          "progress": {"done": 0, "total": 0}
        },
        {
          "title": "Cardio Workout",
          "focus": "Cardio & Endurance",
          "duration": "30 min",
          "level": "Beginner",
          "exercises": [
            {"name": "Jumping Jacks - 3 sets x 20 reps", "completed": true},
            {"name": "High Knees - 3 sets x 15 reps", "completed": true},
            {"name": "Burpees - 3 sets x 10 reps", "completed": false},
            {"name": "Mountain Climbers - 3 sets x 1 min", "completed": false},
            {"name": "Sprint Intervals - 5 sets x 30 sec", "completed": false},
            {"name": "Bicycle Crunches - 3 sets x 20 reps", "completed": false},
          ],
          "metrics": [6, 8, 9, 7, 6],
          // Initialize 'done' and 'total' to 0; they will be calculated in _initializeProgress
          "progress": {"done": 0, "total": 0}
        }
      ]
    }
  ];

  // Features for the radar chart
  static const List<String> features = [
    "Strength",
    "Flexibility",
    "Endurance",
    "Intensity",
    "Focus",
  ];

  @override
  void initState() {
    super.initState();
    // Calculate initial 'done' and 'total' for all sessions on initState
    _initializeProgress();
    print('WorkoutPlanPage initialized with workouts: ${workouts.length}');
  }

  // Method to initialize or re-calculate progress for all sessions
  void _initializeProgress() {
    for (var dayWorkout in workouts) {
      if (dayWorkout['sessions'] is List) { // Ensure 'sessions' is a List
        for (var session in dayWorkout['sessions']) {
          if (session['exercises'] is List) { // Ensure 'exercises' is a List
            final exercises = session['exercises'] as List;
            session['progress']['done'] = exercises
                .where((exercise) => exercise['completed'] == true)
                .length;
            session['progress']['total'] = exercises.length;
          }
        }
      }
    }
  }

  // Icon for Monday
  IconData _getIcon(String day) {
    switch (day) {
      case "Monday":
        return Icons.fitness_center;
      default:
        // A more general icon for other days if you expand beyond Monday
        return Icons.calendar_today;
    }
  }

  // Update progress for a specific day, session, and exercise
  // Added dayIndex to handle multiple days in the future.
  void _updateProgress(int dayIndex, int sessionIndex, int exerciseIndex, bool? value) {
    if (value == null) return; // Guard against null

    setState(() {
      // Safely access the session data
      final session = workouts[dayIndex]['sessions'][sessionIndex];

      // Update the 'completed' status of the specific exercise
      session['exercises'][exerciseIndex]['completed'] = value;

      // Recalculate 'done' exercises for the current session
      session['progress']['done'] = (session['exercises'] as List)
          .where((exercise) => exercise['completed'] == true)
          .length;

      // The 'total' should ideally be fixed unless exercises are added/removed dynamically.
      // If exercises can be added/removed, uncomment the line below:
      // session['progress']['total'] = (session['exercises'] as List).length;

      print(
          'Updated progress for ${session['title']}: ${session['progress']['done']}/${session['progress']['total']}');
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Building WorkoutPlanPage, workouts: ${workouts.length}');
    // Check if workouts list is empty
    if (workouts.isEmpty) {
      print('Workouts list is empty');
      return Scaffold(
        backgroundColor: const Color(0xFF1E1E2C),
        appBar: AppBar(
          title: const Text(
            'Workout Plan',
            style: TextStyle(color: Colors.white),
            semanticsLabel: 'Workout Plan',
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: const Center(
          child: Text(
            'No workouts available',
            style: TextStyle(color: Colors.white, fontSize: 18),
            semanticsLabel: 'No workouts available',
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text(
          'Workout Plan',
          style: TextStyle(color: Colors.white),
          semanticsLabel: 'Workout Plan',
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, dayIndex) { // Renamed index to dayIndex for clarity
          final dayWorkout = workouts[dayIndex];
          // Ensure sessions is a List<Map<String, dynamic>>
          final sessions = (dayWorkout['sessions'] as List<dynamic>)
              .cast<Map<String, dynamic>>();

          return Card(
            color: Colors.grey[850],
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Semantics(
                      label: '${dayWorkout['day']} workout icon',
                      child: Icon(
                        _getIcon(dayWorkout['day']),
                        color: Colors.orangeAccent,
                      ),
                    ),
                    title: Text(
                      dayWorkout['day'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      semanticsLabel: dayWorkout['day'],
                    ),
                    subtitle: Text(
                      // This subtitle is hardcoded, consider making it dynamic if sessions change
                      'Morning & Cardio Sessions',
                      style: const TextStyle(color: Colors.white70),
                      semanticsLabel: 'Morning and Cardio Sessions',
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Render each session
                  ...sessions.asMap().entries.map((entry) {
                    final sessionIndex = entry.key;
                    final session = entry.value;

                    // Dynamically calculate total for progress bar
                    final int totalExercises = (session['exercises'] as List).length;
                    final int completedExercises = (session['exercises'] as List)
                        .where((exercise) => exercise['completed'] == true)
                        .length;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          semanticsLabel: session['title'],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Semantics(
                              label: 'Duration',
                              child: const Icon(
                                Icons.schedule,
                                color: Colors.white70,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              session['duration'],
                              style: const TextStyle(color: Colors.white70),
                              semanticsLabel: 'Duration: ${session['duration']}',
                            ),
                            const SizedBox(width: 20),
                            Semantics(
                              label: 'Level',
                              child: const Icon(
                                Icons.bar_chart,
                                color: Colors.white70,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              session['level'],
                              style: const TextStyle(color: Colors.white70),
                              semanticsLabel: 'Level: ${session['level']}',
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              // Use dynamically calculated completedExercises and totalExercises
                              'Exercises: ($completedExercises/$totalExercises done)',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              semanticsLabel:
                                  'Exercises: $completedExercises of $totalExercises done',
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: LinearProgressIndicator(
                                // Use dynamically calculated values
                                value: totalExercises > 0 ? completedExercises / totalExercises : 0.0,
                                backgroundColor: Colors.grey,
                                color: Colors.teal,
                                minHeight: 4,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ...List.generate(
                          (session['exercises'] as List).length,
                          (i) {
                            final exercise = session['exercises'][i];
                            return CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(
                                exercise['name'],
                                style: TextStyle(
                                  color: Colors.white70,
                                  decoration: exercise['completed']
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              value: exercise['completed'],
                              onChanged: (value) =>
                                  _updateProgress(dayIndex, sessionIndex, i, value), // Pass dayIndex
                              checkColor: Colors.white,
                              activeColor: Colors.teal,
                              dense: true,
                              visualDensity: VisualDensity.compact,
                              // Semantics label for checkbox should generally be on the title.
                              // Removed the secondary semantics label as it's redundant here.
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '🏆 ${session['title']} Metrics',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          semanticsLabel: '${session['title']} Metrics',
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: RadarChart.light(
                            ticks: const [2, 4, 6, 8, 10],
                            features: features,
                            data: [List<int>.from(session['metrics'])],
                            reverseAxis: false,
                            useSides: true,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}