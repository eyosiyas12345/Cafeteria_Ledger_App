import 'package:flutter/material.dart';
import 'package:helloworld/constants/app_colors.dart';
import 'package:helloworld/pages/app_shell/profile_page.dart';

class CategoryButton extends StatelessWidget {
  final String text_on_button;
  CategoryButton({super.key, required this.text_on_button});

  @override
  Widget build(context) {
    return OutlinedButton(
      onPressed: () {},
      child: Text(text_on_button),
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
      ),
    );
  }
}
