import 'package:flutter/material.dart';
import 'package:helloworld/constants/app_colors.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  AppHeader({super.key});

  @override
  Widget build(context) {
    return AppBar(
      backgroundColor: primaryColor,
      title: Text(
        "Cafeteria Ledger",
        style: TextStyle(
            color: secondayColor, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notification_add_outlined),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
