import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:helloworld/providers/menu_provider.dart';
import 'package:helloworld/models/menu_item.dart';

class ItemCard extends StatelessWidget {
  final MenuItem item; // Pass the whole object now
  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(item.image,
                    height: 80, width: double.infinity, fit: BoxFit.cover),
                Positioned(
                  top: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: () {
                      // Call the provider to toggle status
                      Provider.of<MenuProvider>(context, listen: false)
                          .toggleFavorite(item.id);
                    },
                    child: Icon(
                      item.isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: item.isFavorited ? Colors.red : Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            Text(item.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("${item.price} ETB"),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:helloworld/constants/app_colors.dart';

// class ItemCard extends StatefulWidget {
//   final String itemImagePath;
//   const ItemCard({super.key, required this.itemImagePath});

//   @override
//   State<ItemCard> createState() => _ItemCardState();
// }

// class _ItemCardState extends State<ItemCard> {
//   bool isFavorite = false;

//   @override
//   Widget build(context) {
//     return SizedBox(
//       width: 110,
//       child: Card(
//         color: cardColor,
//         shadowColor: Colors.black,
//         elevation: 5,
//         clipBehavior: Clip.hardEdge,
//         // child: Padding(
//         //   padding: const EdgeInsets.only(bottom: 30),
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 Image.asset(
//                   widget.itemImagePath,
//                   height: 80,
//                   width: 100,
//                   fit: BoxFit.cover,
//                 ),
//                 //position the heart at the top right
//                 Positioned(
//                   top: 5,
//                   right: 5,
//                   child: GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         isFavorite = !isFavorite;
//                       });
//                     },
//                     child: Icon(
//                       isFavorite ? Icons.favorite : Icons.favorite_border,
//                       color: isFavorite ? Colors.red : Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               width: double.infinity,
//               child: const Text(
//                 "Caputino",
//                 style: TextStyle(
//                   color: secondayColor,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//                 textAlign: TextAlign.left,
//                 // ),
//               ),
//             ),
//             const Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Text("rate"),
//                 Text("4.5"),
//               ],
//             ),
//             const Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Text("price"),
//                 Text("10 ETB"),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
