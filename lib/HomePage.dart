
import 'package:flutter/material.dart';
import 'main.dart'; // for LoginPage
import 'ProfilePage.dart'; // for profile page
import 'TrainerTips.dart'; // for trainer tips page
import 'DailyChallengePage.dart'; // for daily challenge page
import 'FeedbackPage.dart'; // for feedback page
import 'WorkoutPlanPage.dart';
import 'MealPlanPage.dart';
import 'GoalProgressPage.dart';
import 'CommunityFeedPage.dart'; // for community feed page
import 'RegisterPage.dart'; // for register page

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const WorkoutPlanPage(),
    const CommunityFeedPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _open(Widget page) {
    Navigator.push(
      context,  
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness App'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.black87),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.play_circle_fill),
              title: const Text('Trainer Tips'),
              onTap: () => _open(const TrainerTipsPage()),
            ),
            ListTile(
              leading: const Icon(Icons.local_dining),
              title: const Text('Meal Plan'),
              onTap: () => _open(const MealPlanPage()),
            ),
            ListTile(
              leading: const Icon(Icons.flag),
              title: const Text('Wellness Goals Progress'),
              onTap: () => _open(const GoalProgressPage()),
            ),
            ListTile(
              leading: const Icon(Icons.bolt),
              title: const Text('Daily Challenge'),
              onTap: () => _open(const DailyChallengePage()),
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Feedback'),
              onTap: () => _open(const FeedbackPage()),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.orangeAccent,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: 'Community Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}