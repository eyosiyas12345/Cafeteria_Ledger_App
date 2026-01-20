import 'package:flutter/material.dart';
import 'package:helloworld/pages/app_shell/home_page.dart';
import 'package:helloworld/pages/app_shell/menu_page.dart';
import 'package:helloworld/pages/app_shell/profile_page.dart';
import 'package:helloworld/pages/app_shell/feed_back.dart';
import 'package:helloworld/constants/app_colors.dart';
import 'package:helloworld/pages/order_flow/favorites.dart' as favorites;
import 'package:helloworld/pages/order_flow/pay.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    MenuPage(),
    ProfilePage(),
    FeedbackScreen(),
  ];

  Widget _buildHeader() {
    return const DrawerHeader(
      decoration: BoxDecoration(color: primaryColor),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage('assets/users/profile.jpg'),
          ),
          SizedBox(width: 15),
          Text(
            "user name",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: secondaryColor),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, color: secondaryColor),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => favorites.Favorites()), // Use alias here
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          "Cafeteria Ledger",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: primaryColor,
          child: Column(
            children: [
              _buildHeader(),
              _buildMenuItem(Icons.person_outline, "Account"),
              _buildMenuItem(Icons.favorite_border, "Favorites"),
              _buildMenuItem(
                  Icons.account_balance_wallet_outlined, "Payment methods"),
              const Spacer(), // Pushes the logout to the bottom
              _buildMenuItem(Icons.logout, "Logout"),
            ],
          ),
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            backgroundColor: Color(0xffc15027),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.book,
              color: secondaryColor,
            ),
            label: "Menu",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: secondaryColor),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online, color: secondaryColor),
            label: "Comment",
          ),
        ],
      ),
    );
  }
}
