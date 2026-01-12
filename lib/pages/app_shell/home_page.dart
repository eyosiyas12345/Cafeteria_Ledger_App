import 'package:flutter/material.dart';
import 'package:helloworld/constants/app_colors.dart';
import 'package:helloworld/customWidgets/reusable_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double cardRadius = 16.0;

  @override
  Widget build(context) {
    return SingleChildScrollView(
      child: Column(
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
              ItemCard(
                itemImagePath: 'assets/images/items/coffee.jpg',
              ),
              ItemCard(
                itemImagePath: 'assets/images/items/caputuno.jpg',
              ),
              ItemCard(
                itemImagePath: 'assets/images/items/milk.jpg',
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              ItemCard(
                itemImagePath: 'assets/images/items/full.jpg',
              ),
              ItemCard(
                itemImagePath: 'assets/images/items/ferfer.jpg',
              ),
              ItemCard(
                itemImagePath: 'assets/images/items/quanta firfir.jpg',
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              ItemCard(
                itemImagePath: 'assets/images/items/tibs.webp',
              ),
              ItemCard(
                itemImagePath: 'assets/images/items/shiro.webp',
              ),
              ItemCard(
                itemImagePath: 'assets/images/items/enkulal firfer.jpg',
              ),
            ],
          ),
        ],
      ),
    );
    // bottomNavigationBar: BottomNavigationBar(
    //   // onTap: changePage(),
    //   items: [
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.home),
    //       label: "Home",
    //       backgroundColor: primaryColor,
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.book),
    //       label: "Menu",
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.man),
    //       label: "profile",
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(
    //         Icons.book_online_outlined,
    //       ),
    //       label: "ledger",
    //       backgroundColor: secondayColor,
    //     ),
    //   ],
    // ),
  }
}

// class ItemCard extends StatelessWidget {
//   const ItemCard({super.key});

//   @override
//   Widget build(context) {
//     return SizedBox(
//       width: 110,
//       height: 150,
//       child: Card(
//         color: primaryColor,
//         shadowColor: primaryColor,
//         elevation: 5,
//         clipBehavior: Clip.hardEdge,
//         child: Padding(
//           padding: const EdgeInsets.only(bottom: 50),
//           child: Column(
//             children: [
//               Image.asset('assets/images/items/caputuno.jpg'),
//               const Text(
//                 "Caputino",
//                 style: TextStyle(color: primaryColor),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//app bar
//MaterialApp(
// debugShowCheckedModeBanner: false,
// home: Scaffold(
//   appBar: AppBar(
//     backgroundColor: primaryColor,
//     title: Text(
//       "Cafeteria Ledger",
//       style: TextStyle(
//           color: secondayColor,
//           fontSize: 18,
//           fontWeight: FontWeight.bold),
//     ),
//     actions: [
//       IconButton(
//         onPressed: () {},
//         icon: const Icon(Icons.menu),
//       ),
//       IconButton(
//         onPressed: () {},
//         icon: const Icon(Icons.notification_add_outlined),
//       ),
//     ],
//   ),
//   body:
