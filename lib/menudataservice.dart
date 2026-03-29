import 'menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuDataService {
  static List<MenuItem> menuList = [];

  static int getCount() => menuList.length;

  static void addMenuItem(String id, String name, double price, String stallId) {
    menuList.add(MenuItem(id, name, price, stallId));
  }

  static MenuItem getItemAt(int index) => menuList[index];

  static List<MenuItem> getItemsForStall(String stallId) {
    return menuList.where((item) => item.stallId == stallId).toList();
  }

  static void removeItemAt(int index) {
    menuList.removeAt(index);
  }

  static void removeItemById(String id) {
    for (int i = 0; i < menuList.length; i++) {
      if (menuList[i].id == id) {
        menuList.removeAt(i);
        break;
      }
    }
  }

  static void updateItemAt(int index, String newName, double newPrice) {
    menuList[index].name = newName;
    menuList[index].price = newPrice;
  }

  static void updateItemById(String id, String newName, double newPrice) {
    for (int i = 0; i < menuList.length; i++) {
      if (menuList[i].id == id) {
        menuList[i].name = newName;
        menuList[i].price = newPrice;
        break;
      }
    }
  }


  static Future<void> loadItemsFromFirebase() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('menuItems')
        .get();

    menuList = [];

    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data();
      String id = doc.id;
      String name = data['Name'];
      double price = (data['Price'] as num).toDouble();
      String stallId = data['Stall id'];

      menuList.add(MenuItem(id, name, price, stallId));
    }
  }
}