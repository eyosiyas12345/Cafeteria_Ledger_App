import 'package:flutter/material.dart';

final Color _primary_color = Colors.orange;
final Color _seconday_color = Color(0xff903829);
final Color _white_color = Colors.white;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final double cardRadius = 16.0;
  @override
  Widget build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: _primary_color,
          title: Text(
            "Cafeteria Ledger",
            style: TextStyle(
                color: _seconday_color,
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
              'assets/images/foreground.jpg',
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
                    backgroundColor: _primary_color,
                    foregroundColor: _white_color,
                  ),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text("Break Fast"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: _primary_color,
                  ),
                ),
                OutlinedButton(
                    onPressed: () {},
                    child: const Text("Lunch"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: _primary_color,
                    )),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const ItemCard(),
                const ItemCard(),
                const ItemCard(),
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
        color: _primary_color,
        shadowColor: _primary_color,
        elevation: 5,
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: Column(
            children: [
              Image.asset('assets/images/caputuno.jpg'),
              Text("Caputino", style: TextStyle(color: _primary_color)),
            ],
          ),
        ),
      ),
    );
  }
}
