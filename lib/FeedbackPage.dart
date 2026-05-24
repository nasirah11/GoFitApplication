import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _controller = TextEditingController();
  int _stars = 0; // Overall app/experience rating
  String? _selectedFeedbackCategory; // Selected GoFit module for specific feedback
  String submittedFeedbackText = ""; // To show the submitted text
  bool _showFeedbackCategories = false; // Controls which view is shown

  // List of GoFit modules for feedback
  final List<String> goFitModules = [
    'Workout Plan',
    'Meal Plan',
    'Goal Progress',
    'Daily Challenge',
    'Trainer Tips',
    'Community Feed',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C), // Your dark background color
      appBar: AppBar(
        title: const Text('Feedback', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _showFeedbackCategories // Only show back button if on category selection
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _showFeedbackCategories = false; // Go back to star rating
                    _selectedFeedbackCategory = null; // Clear selected category
                    _controller.clear(); // Clear text field on back
                    submittedFeedbackText = ""; // Clear submitted text
                  });
                },
              )
            : null, // No back button on initial star rating screen
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
          children: [
            // Conditionally render star rating or category selection
            _showFeedbackCategories
                ? _buildFeedbackCategoriesContent()
                : _buildStarRatingContent(),

            if (_selectedFeedbackCategory != null) ...[
              // Show text field only if a category is selected
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Write your feedback for $_selectedFeedbackCategory...',
                  hintStyle: const TextStyle(color: Colors.white60),
                  filled: true,
                  fillColor: Colors.grey[850],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      submittedFeedbackText =
                          "🎉 Thanks for your $_stars-star feedback for $_selectedFeedbackCategory: \"${_controller.text}\"!";
                      _controller.clear();
                      // Optionally, you might want to reset the state or navigate away
                      // For now, it just shows the confirmation message
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Submit'),
                ),
              ),
            ],

            const SizedBox(height: 30),
            if (submittedFeedbackText.isNotEmpty)
              Center(
                child: Text(
                  submittedFeedbackText,
                  style: const TextStyle(color: Colors.tealAccent, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRatingContent() {
    return Column(
      children: [
        // Using an Icon instead of an Image.asset for the GoFit representation
        const Icon(
          Icons.fitness_center_sharp, // A good general icon for a fitness app
          size: 100,
          color: Colors.orangeAccent, // A contrasting color for the icon
        ),
        const SizedBox(height: 20),
        const Text(
          'How was your GoFit experience?', // More specific to GoFit
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                Icons.star,
                color: index < _stars ? Colors.amber : Colors.grey[700], // Adjust color for dark theme
                size: 40,
              ),
              onPressed: () {
                setState(() {
                  _stars = index + 1;
                  _showFeedbackCategories = true; // Move to category selection after rating
                });
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildFeedbackCategoriesContent() {
    return Expanded( // Use Expanded to give GridView available space
      child: Column(
        children: [
          const Text(
            'Every feedback helps. What can we improve on?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Expanded( // Expanded for GridView
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 modules per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.0, // Make items square
              ),
              itemCount: goFitModules.length,
              itemBuilder: (context, index) {
                final module = goFitModules[index];
                final isSelected = _selectedFeedbackCategory == module;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFeedbackCategory = module;
                      submittedFeedbackText = ""; // Clear submitted message when selecting new category
                    });
                  },
                  child: Card(
                    color: isSelected ?const Color.fromARGB(255, 226, 94, 18) : Colors.grey[800], // Darker colors for dark theme
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: isSelected ?const Color.fromARGB(255, 233, 186, 125) : Colors.grey.shade600, // Lighter border when selected
                        width: 2,
                      ),
                    ),
                    elevation: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _getModuleIcon(module),
                        const SizedBox(height: 8),
                        Flexible(
                          child: Text(
                            module,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.blue.shade100 : Colors.white70, // Text color for dark theme
                            ),
                          ),
                        ),
                      ],
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

  // Helper function to get an icon based on the module name
  Widget _getModuleIcon(String moduleName) {
    IconData iconData;
    switch (moduleName) {
      case 'Workout Plan':
        iconData = Icons.fitness_center;
        break;
      case 'Meal Plan':
        iconData = Icons.restaurant_menu;
        break;
      case 'Goal Progress':
        iconData = Icons.track_changes;
        break;
      case 'Daily Challenge':
        iconData = Icons.emoji_events;
        break;
      case 'Trainer Tips':
        iconData = Icons.lightbulb_outline;
        break;
      case 'Community Feed':
        iconData = Icons.people_outline;
        break;
      default:
        iconData = Icons.help_outline; // Default icon
    }
    return Icon(iconData, size: 40, color: Colors.orangeAccent); // Icon color for dark theme
  }
}