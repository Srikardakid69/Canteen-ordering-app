import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage({super.key});

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  String orderNumber = "F${Random().nextInt(900) + 100}"; // Random F100–F999
  int _currentIndex = 1;

  Future<List<Map<String, dynamic>>> fetchCartItems() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cart')
        .get();

    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<Map<String, dynamic>> fetchPickupInfo() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('pickupInfo')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    return snapshot.docs.first.data();
  }

  double calculateTotal(List<Map<String, dynamic>> items) {
    double total = 0;
    for (var item in items) {
      total += (item['price'] ?? 0) * (item['quantity'] ?? 1);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thank you"),
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
      body: FutureBuilder(
        future: Future.wait([fetchCartItems(), fetchPickupInfo()]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final cartItems = snapshot.data![0] as List<Map<String, dynamic>>;
          final pickupInfo = snapshot.data![1] as Map<String, dynamic>;
          final total = calculateTotal(cartItems);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Icon(Icons.check_circle, size: 100, color: Colors.green),
                const SizedBox(height: 10),
                const Text("Your Order is confirmed",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSummaryBox("Summary", [
                      "Order No. : $orderNumber",
                      "Order Date : ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                      "Order Total : \$${total.toStringAsFixed(2)}",
                    ]),
                    _buildSummaryBox("Pickup Info", [
                      
                      "Pickup Date : ${pickupInfo['pickupDate'] ?? '-'}",
                      "Pickup Time : ${pickupInfo['breakStart'] ?? '-'}",
                    ]),
                  ],
                ),
                const SizedBox(height: 20),
                _buildCartTable(cartItems),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          if (index == 0) {
            Navigator.pushNamed(context, '/screen3');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/screen4');
          } else if (index == 2) {
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

  Widget _buildSummaryBox(String title, List<String> lines) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 5),
            for (var line in lines)
              Text(line, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildCartTable(List<Map<String, dynamic>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Text("Items Ordered", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Qty", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Price", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const Divider(),
        for (var item in items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(item['name'] ?? ""),
                Text("${item['quantity'] ?? 1}"),
                Text("\$${(item['price'] * (item['quantity'] ?? 1)).toStringAsFixed(2)}"),
              ],
            ),
          ),
      ],
    );
  }
}