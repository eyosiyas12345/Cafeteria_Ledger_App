import 'package:flutter/material.dart';
import 'package:helloworld/constants/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final double cardRadius = 16.0;
  @override
  Widget build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(
            "Cafeteria Ledger",
            style: TextStyle(
                color: secondayColor,
                fontSize: 18,
                fontWeight: FontWeight.bold),
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
        ),
        body: Column(
          children: [
            Image.asset(
              'assets/images/uniques/foreground.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Hot Drinks"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: whiteColor,
                  ),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text("Break Fast"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: primaryColor,
                  ),
                ),
                OutlinedButton(
                    onPressed: () {},
                    child: const Text("Lunch"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: primaryColor,
                    )),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                ItemCard(),
                ItemCard(),
                ItemCard(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                ItemCard(),
                ItemCard(),
                ItemCard(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                ItemCard(),
                ItemCard(),
                ItemCard(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard({super.key});

  @override
  Widget build(context) {
    return SizedBox(
      width: 110,
      height: 150,
      child: Card(
        color: primaryColor,
        shadowColor: primaryColor,
        elevation: 5,
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: Column(
            children: [
              Image.asset('assets/images/items/caputuno.jpg'),
              const Text(
                "Caputino",
                style: TextStyle(color: primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
