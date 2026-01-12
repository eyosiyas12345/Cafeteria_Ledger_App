import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:helloworld/providers/menu_provider.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the list of favorited items from the provider
    final favItems = context.watch<MenuProvider>().favoriteItems;

    return Scaffold(
      appBar: AppBar(title: const Text("My Favorites")),
      body: favItems.isEmpty
          ? const Center(child: Text("No favorites yet!"))
          : ListView.builder(
              itemCount: favItems.length,
              itemBuilder: (context, index) {
                final item = favItems[index];
                return ListTile(
                  leading:
                      CircleAvatar(backgroundImage: AssetImage(item.imagePath)),
                  title: Text(item.name),
                  subtitle: Text("${item.price} ETB"),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () {
                      context.read<MenuProvider>().toggleFavorite(item.id);
                    },
                  ),
                );
              },
            ),
    );
  }
}

// import 'package:flutter/material.dart';

// class Favorites extends StatefulWidget {
//   const Favorites({super.key});

//   @override
//   State<Favorites> createState() => _FavoritesState();
// }

// class _FavoritesState extends State<Favorites> {
//   // A simple way to track favorites for this demo
//   final List<int> _favoritedItems = [0, 1, 2];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Favorites"),
//         backgroundColor: Colors.orange,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Column(
//             mainAxisSize:
//                 MainAxisSize.min, // Keeps the list centered vertically
//             children: [
//               _buildFavoriteItem(0, "Coffee", 'assets/images/items/coffee.jpg'),
//               const Divider(),
//               _buildFavoriteItem(1, "Tea", 'assets/images/items/tea.jpg'),
//               const Divider(),
//               _buildFavoriteItem(2, "Burger", 'assets/images/items/burger.jpg'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFavoriteItem(int id, String name, String imagePath) {
//     bool isFavorited = _favoritedItems.contains(id);

//     return ListTile(
//       contentPadding: EdgeInsets.zero,
//       // 1. Image on the left
//       leading: CircleAvatar(
//         radius: 25,
//         backgroundImage: AssetImage(imagePath),
//         backgroundColor: Colors.grey[200],
//       ),
//       // 2. Name beside the image
//       title: Text(
//         name,
//         style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
//       ),
//       // 3. Clickable heart icon on the right
//       trailing: IconButton(
//         icon: Icon(
//           isFavorited ? Icons.favorite : Icons.favorite_border,
//           color: isFavorited ? Colors.red : Colors.grey,
//         ),
//         onPressed: () {
//           setState(() {
//             if (isFavorited) {
//               _favoritedItems.remove(id);
//             } else {
//               _favoritedItems.add(id);
//             }
//           });
//         },
//       ),
//     );
//   }
// }
