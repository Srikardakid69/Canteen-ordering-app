import 'package:flutter/material.dart';
import 'menudataservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Nasipadang extends StatefulWidget {
  const Nasipadang({super.key});

  @override
  State<Nasipadang> createState() => _NasipadangState();
}

class _NasipadangState extends State<Nasipadang> {
  int _currentIndex = 1;
  Set<String> selectedItemIds = {};      
  Set<String> favouriteItemIds = {};     

  @override
  void initState() {
    super.initState();
    loadFavouritesFromFirebase(); 
  }

  Future<void> loadFavouritesFromFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favourites')
        .get();

    setState(() {
      favouriteItemIds = snapshot.docs.map((doc) => doc.id).toSet();
    });

    print("⭐ Favourites restored: ${favouriteItemIds.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: MenuDataService.loadItemsFromFirebase(),
        builder: (context, snapshot) {
          final items = MenuDataService.getItemsForStall("Stall 2");

          return Column(
            children: [
              Image.asset(
                'assets/Nasi Padang Image.png',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              const Text(
                "Nasi Padang",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text("Menu", style: TextStyle(fontWeight: FontWeight.w500)),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      leading: Checkbox(
                        value: selectedItemIds.contains(item.id),
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              selectedItemIds.add(item.id);
                            } else {
                              selectedItemIds.remove(item.id);
                            }
                          });
                        },
                      ),
                      title: Text("${item.name}  -- \$${item.price}"),
                      trailing: IconButton(
                        icon: Icon(
                          favouriteItemIds.contains(item.id)
                              ? Icons.star
                              : Icons.star_border,
                          color: favouriteItemIds.contains(item.id)
                              ? Colors.amber
                              : null,
                        ),
                        onPressed: () async {
                          final uid = FirebaseAuth.instance.currentUser!.uid;
                          final favRef = FirebaseFirestore.instance
                              .collection('users')
                              .doc(uid)
                              .collection('favourites')
                              .doc(item.id);

                          if (favouriteItemIds.contains(item.id)) {
                            setState(() {
                              favouriteItemIds.remove(item.id);
                            });
                            await favRef.delete(); 
                            print("❌ Removed favourite for ${item.name}");
                          } else {
                            setState(() {
                              favouriteItemIds.add(item.id);
                            });
                            await favRef.set({
                              'name': item.name,
                              'price': item.price,
                              'stallId': item.stallId,
                            }); 
                            print("⭐ Added favourite for ${item.name}");
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async{
                        final uid = FirebaseAuth.instance.currentUser!.uid;
                    final cartRef = FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .collection('cart');

                   
                    final existing = await cartRef.get();
                    for (var doc in existing.docs) {
                      await doc.reference.delete();
                    }

                    
                    final items = MenuDataService.menuList
                        .where((item) => selectedItemIds.contains(item.id))
                        .toList();

                    for (var item in items) {
                      await cartRef.doc(item.id).set({
                        'name': item.name,
                        'price': item.price,
                        'stallId': item.stallId,
                        'quantity': 1, 
                      });
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("✅ Items added to cart!")),
                    );
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text("Add to Cart"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/time');
                    },
                    child: const Text("Finish"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
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
