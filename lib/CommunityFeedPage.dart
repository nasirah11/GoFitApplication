import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io' show File;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CommunityFeedPage extends StatefulWidget {
  const CommunityFeedPage({super.key});

  @override
  State<CommunityFeedPage> createState() => _CommunityFeedPageState();
}

class _CommunityFeedPageState extends State<CommunityFeedPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text('Community Feed', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.teal,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.teal,
          tabs: const [
            Tab(text: 'Progress Feed'),
            Tab(text: 'Leaderboard'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ProgressFeedTab(),
          LeaderboardTab(),
        ],
      ),
    );
  }
}

class ProgressFeedTab extends StatefulWidget {
  const ProgressFeedTab({super.key});

  @override
  State<ProgressFeedTab> createState() => _ProgressFeedTabState();
}

class _ProgressFeedTabState extends State<ProgressFeedTab> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> posts = [];
  File? _image;
  String mood = "😊";

  Future<void> _pickImage() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image upload is not supported on web.")),
      );
      return;
    }

    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  void _addPost() {
    if (_controller.text.isNotEmpty || _image != null) {
      posts.insert(0, {
        'text': _controller.text,
        'image': _image,
        'mood': mood,
        'time': DateTime.now(),
        'liked': false,
      });
      _controller.clear();
      setState(() => _image = null);
    }
  }

  void _toggleLike(int index) {
    setState(() {
      posts[index]['liked'] = !(posts[index]['liked'] ?? false);
    });
  }

  void _deletePost(int index) {
    setState(() => posts.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'What have you achieved today?',
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Add Image'),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: mood,
                  dropdownColor: Colors.grey[900],
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) => setState(() => mood = value!),
                  items: ["😊", "😐", "😔"]
                      .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                      .toList(),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Post'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Recent Posts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 10),
            ...posts.asMap().entries.map((entry) {
              final index = entry.key;
              final post = entry.value;
              return Card(
                color: Colors.grey[900],
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: post['image'] != null
                      ? (kIsWeb
                          ? const Icon(Icons.image_not_supported)
                          : Image.file(post['image'], width: 50, height: 50, fit: BoxFit.cover))
                      : const Icon(Icons.person, color: Colors.white70),
                  title: Text(post['text'] ?? '', style: const TextStyle(color: Colors.white)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        'Mood: ${post['mood']}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Posted: ${DateFormat('MMM d, h:mm a').format(post['time'])}',
                        style: const TextStyle(fontSize: 12, color: Colors.white54),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              post['liked'] ? Icons.favorite : Icons.favorite_border,
                              color: post['liked'] ? Colors.red : Colors.white,
                            ),
                            onPressed: () => _toggleLike(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.white70),
                            onPressed: () => _deletePost(index),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class LeaderboardTab extends StatelessWidget {
  const LeaderboardTab({super.key});

  static const List<Map<String, dynamic>> leaderboard = [
    {"name": "Ali", "points": 120, "workoutsCompleted": 8},
    {"name": "Sara", "points": 100, "workoutsCompleted": 7},
    {"name": "Jamie Nelson", "points": 95, "workoutsCompleted": 6},
    {"name": "Ravi", "points": 90, "workoutsCompleted": 5},
    {"name": "Maya", "points": 85, "workoutsCompleted": 4},
    {"name": "John", "points": 75, "workoutsCompleted": 3},
  ];

  Color _getNameColor(int index) {
    switch (index) {
      case 0:
        return Colors.orangeAccent;
      case 1:
        return Colors.teal;
      case 2:
        return Colors.white70;
      default:
        return Colors.white;
    }
  }

  Color _getCardColor(int index) {
    return Colors.grey[850]!;
  }

  Color _getPointColor(int index) {
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              final isCurrentUser = user['name'] == 'Jamie Nelson';
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: isCurrentUser ? Colors.teal : Colors.black,
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
                        backgroundColor: isCurrentUser ? Colors.teal : Colors.orangeAccent,
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
                          value: user['points'] / 120.0,
                          backgroundColor: Colors.grey,
                          color: Colors.teal,
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
    );
  }
}