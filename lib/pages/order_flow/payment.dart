import 'package:flutter/material.dart';

class Favorites extends StatelessWidget {
  Favorites({super.key});

  @override
  Widget build(context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(children: [
                    CircleAvatar(
                      radius: 10.0,
                      child: Image.asset('assets/images/banks/cbe.jpg'),
                    ),
                    Text("CBE"),
                  ]),
                ),
                Text("10005060709010"),
              ],
            ),
            Divider(
              height: 3,
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 10.0,
                  child: Image.asset('assets/images/banks/cbe.jpg'),
                ),
                Text("Commericail bank of ethiopia"),
              ],
            ),
            Divider(
              height: 3,
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 10.0,
                  child: Image.asset('assets/images/banks/cbe.jpg'),
                ),
                Text("Commericail bank of ethiopia"),
              ],
            ),
            Divider(
              height: 3,
            ),
          ],
        ),
      ),
    );
  }
}
