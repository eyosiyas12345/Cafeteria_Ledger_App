import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:helloworld/constants/app_colors.dart';
import 'package:helloworld/providers/menu_provider.dart';
import 'package:helloworld/models/menu_item.dart';
import 'package:helloworld/pages/order_flow/details.dart'; // Ensure this path matches your file structure

class ItemCard extends StatelessWidget {
  final MenuItem item;

  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      child: Card(
        color: cardColor, // UI: Preserved your color
        shadowColor: Colors.black, // UI: Preserved your shadow
        elevation: 5, // UI: Preserved your elevation
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          // Logic: Opens details page when any part of the card (except the heart) is clicked
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemDetailsPage(item: item),
              ),
            );
          },
          child: Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    item.imagePath,
                    height: 80,
                    width: 110,
                    fit: BoxFit.cover,
                  ),
                  // Heart Icon Logic
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      // Logic: The 'onTap' here captures the click so it doesn't trigger the InkWell below it
                      onTap: () {
                        Provider.of<MenuProvider>(context, listen: false)
                            .toggleFavorite(item.id);
                      },
                      child: Icon(
                        item.isFavorited
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: item.isFavorited ? Colors.red : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              // UI: Preserved your specific Text styling and alignment
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    item.name,
                    style: const TextStyle(
                      color: secondayColor, // Fixed your previous spelling typo
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              // UI: Preserved your Rating Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text("rate", style: TextStyle(fontSize: 12)),
                  Text(item.rate.toString(),
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
              // UI: Preserved your Price Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text("price", style: TextStyle(fontSize: 12)),
                  Text("${item.price} ETB",
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:helloworld/constants/app_colors.dart';
// import 'package:helloworld/providers/menu_provider.dart';
// import 'package:helloworld/models/menu_item.dart';

// class ItemCard extends StatelessWidget {
//   final MenuItem item; // Logic: Uses the dynamic model
//   const ItemCard({super.key, required this.item});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 110,
//       child: Card(
//         color: cardColor, // UI: Restored your color
//         shadowColor: Colors.black, // UI: Restored your shadow
//         elevation: 5, // UI: Restored your elevation
//         clipBehavior: Clip.hardEdge,
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 Image.asset(
//                   item.imagePath, // Logic: Dynamic path
//                   height: 80,
//                   width: 110, // Matches card width
//                   fit: BoxFit.cover,
//                 ),
//                 // Position the heart at the top right
//                 Positioned(
//                   top: 5,
//                   right: 5,
//                   child: GestureDetector(
//                     onTap: () {
//                       // Logic: Updates global state instead of local setState
//                       Provider.of<MenuProvider>(context, listen: false)
//                           .toggleFavorite(item.id);
//                     },
//                     child: Icon(
//                       item.isFavorited ? Icons.favorite : Icons.favorite_border,
//                       color: item.isFavorited ? Colors.red : Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             // UI: Restored your specific Text styling and alignment
//             SizedBox(
//               width: double.infinity,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                 child: Text(
//                   item.name, // Logic: Dynamic name
//                   style: const TextStyle(
//                     color:
//                         secondayColor, // Make sure spelling matches constants
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                   textAlign: TextAlign.left,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ),
//             // UI: Restored your specific Row for Rating
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 const Text("rate", style: TextStyle(fontSize: 12)),
//                 Text(item.rate.toString(),
//                     style: const TextStyle(fontSize: 12)),
//               ],
//             ),
//             // UI: Restored your specific Row for Price
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 const Text("price", style: TextStyle(fontSize: 12)),
//                 Text("${item.price} ETB", style: const TextStyle(fontSize: 12)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
