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
