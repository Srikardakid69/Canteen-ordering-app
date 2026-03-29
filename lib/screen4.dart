import 'package:flutter/material.dart';

class Screen4 extends StatefulWidget {
  @override
  _Screen4State createState() => _Screen4State();
}

class _Screen4State extends State<Screen4> {
  String selectedFoodCourt = '';
  int _currentIndex = 1;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),

          // Map image
          Image.asset(
            'assets/map.png',
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),

          // FC buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      selectedFoodCourt == 'FC1' ? Colors.black : Colors.white,
                  foregroundColor:
                      selectedFoodCourt == 'FC1' ? Colors.white : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    selectedFoodCourt = 'FC1';
                  });
                },
                child: Text('FC1'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      selectedFoodCourt == 'FC2' ? Colors.black : Colors.white,
                  foregroundColor:
                      selectedFoodCourt == 'FC2' ? Colors.white : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    selectedFoodCourt = 'FC2';
                  });
                },
                child: Text('FC2'),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Stall list
         Expanded(
  child: ListView(
    children: [
      if (selectedFoodCourt == 'FC1' || selectedFoodCourt == '')
        ...[
          foodTile('Chicken Rice', '/chicken'),
          foodTile('Nasi Padang', '/nasipadang'),
        ],
      if (selectedFoodCourt == 'FC2' || selectedFoodCourt == '')
        ...[
          foodTile('Indian Cuisine', '/indian'),
          foodTile('Beverages', '/beverages'),
        ],
    ],
  ),
),
        ],
      ),

      // Bottom navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
         onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          if (index == 0) {
            Navigator.pushNamed(context, '/screen3');
          }
          else if(index == 2){
             Navigator.pushNamed(context, '/profile');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu_outlined), label: 'Food'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  // Stall card with image and name
  Widget foodTile(String name, String routeName) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            'assets/$name Image.png',
            height: 160,
            fit: BoxFit.cover,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey[100],
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ),
  );
}
}