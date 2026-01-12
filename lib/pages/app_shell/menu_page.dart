import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:helloworld/providers/menu_provider.dart';
import 'package:helloworld/data/menu_data.dart';
import 'package:helloworld/constants/app_colors.dart';
import 'package:helloworld/customWidgets/reusable_card.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final menuProvider = context.watch<MenuProvider>();
    final itemsToShow = menuProvider.filteredItems;

    return SingleChildScrollView(
      child: Column(
        children: [
          // 1. SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) =>
                  context.read<MenuProvider>().updateSearch(value),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search by name...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // 2. HORIZONTAL CATEGORY SCROLL
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                _categoryTab(context, "Drinks", ItemCategory.drinks),
                _categoryTab(context, "Breakfast", ItemCategory.breakfast),
                _categoryTab(context, "Lunch", ItemCategory.lunch),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 3. RESULTS GRID - Adjusted for 3 columns
          itemsToShow.isEmpty
              ? const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Center(
                      child: Text("No items found matching your search.")),
                )
              : Padding(
                  // Reduced horizontal padding to 4.0 to make room for 3 cards
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4.0, vertical: 10.0),
                  child: Wrap(
                    spacing: 6, // Reduced from 12 to 6 to save horizontal space
                    runSpacing: 15,
                    alignment:
                        WrapAlignment.start, // Align to start for a clean grid
                    children: itemsToShow
                        .map((item) => ItemCard(item: item))
                        .toList(),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _categoryTab(
      BuildContext context, String label, ItemCategory category) {
    final provider = context.read<MenuProvider>();
    bool isSelected = provider.selectedCategory == category;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ActionChip(
        label: Text(label),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : primaryColor,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: isSelected ? primaryColor : Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: primaryColor),
          borderRadius: BorderRadius.circular(20),
        ),
        onPressed: () => provider.setCategory(category),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:helloworld/customWidgets/reusable_card.dart';
// import 'package:helloworld/customWidgets/reusable_button.dart';
// import 'package:helloworld/customWidgets/reusable_app_bar.dart';

// class MenuPage extends StatefulWidget {
//   const MenuPage({super.key});

//   @override
//   State<MenuPage> createState() => _MenuPageState();
// }

// class _MenuPageState extends State<MenuPage> {
//   @override
//   Widget build(context) {
//     return Center(
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Padding(
//               padding: EdgeInsets.all(10),
//               child: TextField(
//                 decoration: InputDecoration(
//                   prefixIcon: Icon(Icons.search),
//                   label: Text("Search"),
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ),
//             //CATAGORY BUTTON ----------
//             SizedBox(height: 10),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   CategoryButton(text_on_button: "All"),
//                   CategoryButton(text_on_button: "Break Fast"),
//                   CategoryButton(text_on_button: "Lunch"),
//                   CategoryButton(text_on_button: "Dinner"),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ItemCard(itemImagePath: 'assets/images/items/caputuno.jpg'),
//                 ItemCard(itemImagePath: 'assets/images/items/coffee.jpg'),
//                 ItemCard(itemImagePath: 'assets/images/items/caputuno.jpg'),
//               ],
//             ),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 ItemCard(itemImagePath: 'assets/images/items/coffee.jpg'),
//                 SizedBox(width: 5),
//                 ItemCard(itemImagePath: 'assets/images/items/caputuno.jpg'),
//                 SizedBox(width: 5),
//                 ItemCard(itemImagePath: 'assets/images/items/coffee.jpg'),
//               ],
//             ),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ItemCard(itemImagePath: 'assets/images/items/coffee.jpg'),
//                 ItemCard(itemImagePath: 'assets/images/items/caputuno.jpg'),
//                 ItemCard(itemImagePath: 'assets/images/items/coffee.jpg'),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
