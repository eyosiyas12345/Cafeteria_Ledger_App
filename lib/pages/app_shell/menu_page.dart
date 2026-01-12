import 'package:flutter/material.dart';
import 'package:helloworld/customWidgets/reusable_card.dart';
import 'package:helloworld/customWidgets/reusable_button.dart';
import 'package:helloworld/customWidgets/reusable_app_bar.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  label: Text("Search"),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            //CATAGORY BUTTON ----------
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CategoryButton(text_on_button: "All"),
                  CategoryButton(text_on_button: "Break Fast"),
                  CategoryButton(text_on_button: "Lunch"),
                  CategoryButton(text_on_button: "Dinner"),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ItemCard(itemImagePath: 'assets/images/items/caputuno.jpg'),
                ItemCard(itemImagePath: 'assets/images/items/coffee.jpg'),
                ItemCard(itemImagePath: 'assets/images/items/caputuno.jpg'),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ItemCard(itemImagePath: 'assets/images/items/coffee.jpg'),
                SizedBox(width: 5),
                ItemCard(itemImagePath: 'assets/images/items/caputuno.jpg'),
                SizedBox(width: 5),
                ItemCard(itemImagePath: 'assets/images/items/coffee.jpg'),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ItemCard(itemImagePath: 'assets/images/items/coffee.jpg'),
                ItemCard(itemImagePath: 'assets/images/items/caputuno.jpg'),
                ItemCard(itemImagePath: 'assets/images/items/coffee.jpg'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
