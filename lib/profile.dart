import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_info.dart';
import 'globals.dart'; 

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _currentIndex = 1;

 
  Color getTextColor(bool isDarkMode) {
    return isDarkMode ? Colors.white : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, _) {
        return Scaffold(
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          appBar: AppBar(
            leading: Icon(Icons.arrow_back, color: getTextColor(isDarkMode)),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context, '/screen1');
                  },
                  child: Icon(Icons.logout, color: getTextColor(isDarkMode)),
                ),
              ),
            ],
            elevation: 0,
            backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
            centerTitle: true,
            title: Text(
              'Profile',
              style: TextStyle(color: getTextColor(isDarkMode), fontWeight: FontWeight.bold),
            ),
          ),
          body: Column(
            children: [
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                ' ${UserInfoHelper.emailUsername}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: getTextColor(isDarkMode),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Enable Dark Mode', style: TextStyle(color: getTextColor(isDarkMode))),
                  const SizedBox(width: 10),
                  Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      isDarkModeNotifier.value = value; 
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/favourites');
                    },
                    icon: Icon(Icons.star_border, color: getTextColor(isDarkMode)),
                    label: Text("Favourites", style: TextStyle(color: getTextColor(isDarkMode))),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });

              if (index == 1) {
                Navigator.pushNamed(context, '/screen4');
              } else if (index == 0) {
                Navigator.pushNamed(context, '/screen3');
              }
            },
            selectedItemColor: getTextColor(isDarkMode),
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.restaurant_menu),
                label: 'Food',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}