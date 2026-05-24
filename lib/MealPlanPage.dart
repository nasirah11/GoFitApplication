import 'package:flutter/material.dart';

class MealPlanPage extends StatefulWidget {
  const MealPlanPage({super.key});

  @override
  State<MealPlanPage> createState() => _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlanPage> {
  String selectedType = 'Balanced';

  final Map<String, List<Map<String, dynamic>>> mealPlans = {
    'Balanced': [
      {'meal': 'Breakfast', 'item': 'Oatmeal + Fruits', 'calories': 300, 'protein': 8, 'fat': 5, 'carbs': 55},
      {'meal': 'Lunch', 'item': 'Grilled Chicken + Rice + Veggies', 'calories': 600, 'protein': 35, 'fat': 10, 'carbs': 60},
      {'meal': 'Dinner', 'item': 'Fish + Sweet Potato + Broccoli', 'calories': 500, 'protein': 30, 'fat': 12, 'carbs': 45},
      {'meal': 'Snack', 'item': 'Yogurt + Almonds', 'calories': 200, 'protein': 10, 'fat': 9, 'carbs': 12},
    ],
    'Vegetarian': [
      {'meal': 'Breakfast', 'item': 'Tofu Scramble + Toast', 'calories': 280, 'protein': 12, 'fat': 6, 'carbs': 40},
      {'meal': 'Lunch', 'item': 'Lentil Soup + Salad', 'calories': 400, 'protein': 20, 'fat': 8, 'carbs': 45},
      {'meal': 'Dinner', 'item': 'Vegetable Curry + Rice', 'calories': 500, 'protein': 15, 'fat': 18, 'carbs': 55},
      {'meal': 'Snack', 'item': 'Fruit Smoothie', 'calories': 180, 'protein': 4, 'fat': 2, 'carbs': 30},
    ],
    'Barbaric': [
      {'meal': 'Breakfast', 'item': 'Steak + Eggs', 'calories': 600, 'protein': 40, 'fat': 30, 'carbs': 5},
      {'meal': 'Lunch', 'item': 'Chicken Thighs + Potatoes', 'calories': 700, 'protein': 35, 'fat': 20, 'carbs': 50},
      {'meal': 'Dinner', 'item': 'Beef Ribs + Rice', 'calories': 800, 'protein': 50, 'fat': 35, 'carbs': 45},
      {'meal': 'Snack', 'item': 'Jerky + Boiled Eggs', 'calories': 300, 'protein': 25, 'fat': 15, 'carbs': 3},
    ],
    'Greek': [
      {'meal': 'Breakfast', 'item': 'Greek Yogurt + Honey + Berries', 'calories': 320, 'protein': 15, 'fat': 8, 'carbs': 35},
      {'meal': 'Lunch', 'item': 'Feta omelet + Diced Tomato', 'calories': 350, 'protein': 20, 'fat': 25, 'carbs': 5},
      {'meal': 'Dinner', 'item': 'Stuffed Peppers + Feta Cheese', 'calories': 500, 'protein': 20, 'fat': 18, 'carbs': 45},
      {'meal': 'Snack', 'item': 'Hummus + Veggies', 'calories': 250, 'protein': 8, 'fat': 20, 'carbs': 2},
    ]
  };

  @override
  Widget build(BuildContext context) {
    final meals = mealPlans[selectedType]!;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text('Meal Plan', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Select your diet type:',
                style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton<String>(
              value: selectedType,
              dropdownColor: Colors.grey[900],
              style: const TextStyle(color: Colors.white),
              isExpanded: true,
              onChanged: (value) => setState(() => selectedType = value!),
              items: mealPlans.keys.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.grey[900],
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text('${meal['meal']}: ${meal['item']}',
                        style: const TextStyle(color: Colors.white)),
                    subtitle: Text(
                      'Calories: ${meal['calories']} kcal | Protein: ${meal['protein']}g | Fat: ${meal['fat']}g | Carbs: ${meal['carbs']}g',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    leading: const Icon(Icons.restaurant_menu, color: Colors.orangeAccent),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}