import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// Enum to distinguish content types
// Only 'video' remains as 'tip' is removed
enum ContentType { video }

// Base class for all content items
abstract class ContentItem {
  final String title;
  final String category;
  final ContentType type;

  ContentItem({required this.title, required this.category, required this.type});
}

// Specific class for Video content
class VideoContentItem extends ContentItem {
  final String videoId;

  VideoContentItem({
    required String title,
    required String category,
    required this.videoId,
  }) : super(title: title, category: category, type: ContentType.video);
}

// TipContentItem class has been removed

class TrainerTipsPage extends StatefulWidget {
  const TrainerTipsPage({super.key});

  @override
  State<TrainerTipsPage> createState() => _TrainerTipsPageState();
}

class _TrainerTipsPageState extends State<TrainerTipsPage> {
  String? selectedCategory;
  String searchQuery = '';
  List<String> savedItems = []; // This will store titles of saved items

  // Master list of all content items (now only videos)
  late final List<ContentItem> _allContent;

  // Map to hold YoutubePlayerControllers, keyed by videoId
  final Map<String, YoutubePlayerController> _youtubeControllersMap = {};

  // List of unique categories for the dropdown
  late final List<String> _availableCategories;

  @override
  void initState() {
    super.initState();

    // Populate _allContent with only video content
    _allContent = [
      VideoContentItem(
        videoId: 'cbKkB3POqaY',
        title: 'EASY WORKOUT AT HOME . 25 MINUTES FULL BODY WORKOUT',
        category: 'Simple Workout', // Assigned to Simple Workout
      ),
      VideoContentItem(
        videoId: 'UIPvIYsjfpo',
        title: '30 Min FULL BODY WORKOUT with WARM UP | No Equipment & No Repeat',
        category: 'Simple Workout',
      ),
      VideoContentItem(
        videoId: 'Ki605EYP7_Q',
        title: '11 Min Easy Workout To Do At Home Everyday',
        category: 'Simple Workout',
      ),
      VideoContentItem(
        videoId: 'VpHz8Mb13_Y',
        title: '5 Minute Meditation for Relaxation & Positive Energy | 30 Day Meditation Challenge',
        category: 'Meditation', // Assigned to Meditation
      ),
      VideoContentItem(
        videoId: 'LDs7jglje_U',
        title: '5 Min Meditation Anyone Can Do Anywhere | Re-Center & Clear Your Mind',
        category: 'Meditation', // Assigned to Meditation
      ),
      VideoContentItem(
        videoId: 'vj0JDwQLof4',
        title: '10-Minute Guided Meditation: Self-Love | SELF',
        category: 'Meditation', // Assigned to Meditation
      ),
      VideoContentItem(
        videoId: 'r1OSDnCDoGQ',
        title: 'MEAL PLANNING for Beginners | 6 Easy Steps',
        category: 'Meal Plan', // Assigned to Meal Plan
      ),
      VideoContentItem(
        videoId: 'Zl5_EfYrIeo',
        title: '7 Ways to Improve GUT HEALTH',
        category: 'Meal Plan',
      ),
      VideoContentItem(
        videoId: 'FLSA2DVEKlE',
        title: 'HEALTH HACKS | 11 small ways to improve your health',
        category: 'Meal Plan',
      ),
    ];

    // Initialize YoutubePlayerControllers for all video items
    for (var item in _allContent) {
      final videoItem = item as VideoContentItem; // Directly cast as _allContent now only contains videos
      _youtubeControllersMap[videoItem.videoId] = YoutubePlayerController(
        initialVideoId: videoItem.videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
        ),
      );
    }

    // Extract unique categories from _allContent
    _availableCategories = _allContent.map((item) => item.category).toSet().toList();
    _availableCategories.insert(0, 'All Categories'); // Add an "All" option
    selectedCategory = _availableCategories[0]; // Set default selection
  }

  @override
  void deactivate() {
    // Pause all video controllers
    for (var controller in _youtubeControllersMap.values) {
      controller.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    // Dispose all video controllers
    for (var controller in _youtubeControllersMap.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });
  }

  void _saveItem(String itemTitle) {
    if (!savedItems.contains(itemTitle)) {
      setState(() {
        savedItems.add(itemTitle);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$itemTitle saved!'),
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item already saved!', style: TextStyle(color: Colors.white)),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _viewSavedItems() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      builder: (context) => ListView(
        children: savedItems
            .map((item) => ListTile(
                  title: Text(item, style: const TextStyle(color: Colors.white)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.white70),
                    onPressed: () {
                      setState(() {
                        savedItems.remove(item);
                      });
                      Navigator.pop(context);
                      if (savedItems.isNotEmpty) {
                        _viewSavedItems();
                      }
                    },
                  ),
                ))
            .toList(),
      ),
    );
  }

  // _getCategoryColor and _getCategoryIcon methods have been removed as they are no longer used.

  @override
  Widget build(BuildContext context) {
    // Filter content based on selected category and search query
    final List<ContentItem> filteredContent = _allContent.where((item) {
      final matchesCategory = selectedCategory == 'All Categories' || item.category == selectedCategory;
      final matchesSearch = item.title.toLowerCase().contains(searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCategory,
                  hint: const Text('Categories', style: TextStyle(color: Colors.white)),
                  dropdownColor: Colors.black87,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                      searchQuery = ''; // Clear search when category changes
                    });
                  },
                  items: _availableCategories
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category, style: const TextStyle(color: Colors.white)),
                          ))
                      .toList(),
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                ),
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: Colors.grey[900],
                    title: const Text('Search Content', style: TextStyle(color: Colors.white)),
                    content: TextField(
                      style: const TextStyle(color: Colors.white),
                      onChanged: _onSearch,
                      decoration: const InputDecoration(
                        hintText: 'Enter keyword',
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.bookmark, color: Colors.white),
              onPressed: _viewSavedItems,
            ),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: filteredContent.isEmpty
          ? const Center(
              child: Text(
                'No content found for this category or search.',
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: filteredContent.length,
              itemBuilder: (context, index) {
                final item = filteredContent[index];

                // Since we removed TipContentItem, we can directly assume it's a VideoContentItem
                final videoItem = item as VideoContentItem;
                final controller = _youtubeControllersMap[videoItem.videoId];

                if (controller == null) return const SizedBox.shrink(); // Should not happen

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 220,
                        child: YoutubePlayer(
                          controller: controller,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: Colors.blueAccent,
                          onReady: () {},
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              videoItem.title,
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                              softWrap: true,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              savedItems.contains(videoItem.title) ? Icons.bookmark_added : Icons.bookmark_add,
                              color: savedItems.contains(videoItem.title) ? Colors.lightBlue : Colors.white,
                            ),
                            onPressed: () => _saveItem(videoItem.title),
                          ),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.grey, height: 1),
                  ],
                );
              },
            ),
      backgroundColor: Colors.black,
    );
  }
}