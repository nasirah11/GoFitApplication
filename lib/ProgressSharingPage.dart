import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io' show File;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // for posting date

class ProgressSharingPage extends StatefulWidget {
  const ProgressSharingPage({super.key});

  @override
  State<ProgressSharingPage> createState() => _ProgressSharingPageState();
}

class _ProgressSharingPageState extends State<ProgressSharingPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> posts = [];
  File? _image;
  String mood = "😊";

  Future<void> _pickImage() async {
    // This check prevents image picking on web, which might or might not be
    // what you want depending on the current image_picker support for web.
    // If image_picker supports web fully and you want to use it there, you can remove this `if (kIsWeb)` block.
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image upload is not fully supported on web yet. Please try on a mobile device.")),
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
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text('Progress Sharing', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
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
                  color: Colors.white70, // 👈 Softer than pure white
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
                            ? const Icon(Icons.image_not_supported) // Fallback for web if image not displayed
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
      ),
    );
  }
}