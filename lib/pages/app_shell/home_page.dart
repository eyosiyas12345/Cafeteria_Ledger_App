import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:helloworld/constants/app_colors.dart';
import 'package:helloworld/customWidgets/reusable_card.dart';
import 'package:helloworld/providers/menu_provider.dart';
import 'package:helloworld/data/menu_data.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final menuProvider = context.watch<MenuProvider>();
    final itemsToShow = menuProvider.filteredItems;

    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset(
            'assets/images/uniques/foreground.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          const SizedBox(height: 20),

          // 2. Category Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFilterBtn(context, "Hot Drinks", ItemCategory.drinks),
              _buildFilterBtn(context, "Breakfast", ItemCategory.breakfast),
              _buildFilterBtn(context, "Lunch", ItemCategory.lunch),
            ],
          ),

          const SizedBox(height: 20),

          // 3. Dynamic Grid - Adjusted for 3 columns
          Padding(
            // Reduced horizontal padding to give more room for 3 cards
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
            child: Wrap(
              spacing: 6, // Reduced from 10 to 6 to save horizontal space
              runSpacing: 12,
              alignment: WrapAlignment
                  .start, // Changed to start for consistent 3-column look
              children: itemsToShow.map((item) {
                return ItemCard(item: item);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBtn(BuildContext context, String title, ItemCategory cat) {
    final provider = context.read<MenuProvider>();
    bool isSelected = provider.selectedCategory == cat;

    return isSelected
        ? ElevatedButton(
            onPressed: () => provider.setCategory(cat),
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            child: Text(title,
                style: const TextStyle(color: Colors.white, fontSize: 12)),
          )
        : OutlinedButton(
            onPressed: () => provider.setCategory(cat),
            child: Text(title,
                style: const TextStyle(color: primaryColor, fontSize: 12)),
          );
  }
}
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
//   }
// }

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
