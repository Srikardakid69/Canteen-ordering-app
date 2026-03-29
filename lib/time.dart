import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PickupTimePage extends StatefulWidget {
  const PickupTimePage({super.key}); 

  @override
  State<PickupTimePage> createState() => _PickupTimePageState();
}

class _PickupTimePageState extends State<PickupTimePage> {
  final dateController = TextEditingController();
  final breakStartController = TextEditingController();
  final breakEndController = TextEditingController();
  int _currentIndex = 1;

  void goToCart() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final pickupRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('pickupInfo');

    
    final existing = await pickupRef.get();
    for (var doc in existing.docs) {
      await doc.reference.delete();
    }

    
    await pickupRef.add({
      'pickupDate': dateController.text,
      'breakStart': breakStartController.text,
      'breakEnd': breakEndController.text,
      'timestamp': DateTime.now()
    });

    Navigator.pushNamed(context, '/cart'); 
  }

  Widget _buildStyledTextField(TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pickup Time"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.shopping_cart_outlined),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          _buildStyledTextField(dateController, "Enter Date"),
          const SizedBox(height: 20),
          _buildStyledTextField(breakStartController, "Enter Your Break Start Time"),
          const SizedBox(height: 20),
          _buildStyledTextField(breakEndController, "Enter Your Break End Time"),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
                onPressed: goToCart,
                child: const Text(
                  "Enter",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          if (index == 0) {
            Navigator.pushNamed(context, '/screen3');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/profile');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/screen4');
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
}