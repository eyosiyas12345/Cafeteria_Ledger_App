import 'package:flutter/material.dart';
import 'package:helloworld/data/menu_data.dart';
import 'package:helloworld/models/menu_item.dart';

class MenuProvider extends ChangeNotifier {
  // Convert your raw Map data into a List of MenuItem objects
  final List<MenuItem> _allItems = drinkItems.map((item) {
    return MenuItem(
      id: item['id'],
      name: item['name'],
      rate: item['rate'],
      price: item['price'],
      imagePath:
          item['image'], // Ensure you added 'image' to your MenuItem model
      isFavorited: false,
    );
  }).toList();

  List<MenuItem> get allItems => _allItems;

  // This returns only the items where isFavorited is true
  List<MenuItem> get favoriteItems =>
      _allItems.where((item) => item.isFavorited).toList();

  void toggleFavorite(int id) {
    final index = _allItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      _allItems[index].isFavorited = !_allItems[index].isFavorited;
      notifyListeners(); // This is the magic! It refreshes the UI everywhere.
    }
  }
}
