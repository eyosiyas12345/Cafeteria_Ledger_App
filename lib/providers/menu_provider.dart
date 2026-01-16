import 'package:flutter/material.dart';
import 'package:helloworld/data/menu_data.dart';
import 'package:helloworld/models/menu_item.dart';

class MenuProvider extends ChangeNotifier {
  // Current state variables
  ItemCategory _selectedCategory = ItemCategory.drinks;
  String _searchQuery = "";

  ItemCategory get selectedCategory => _selectedCategory;

  // Method called by the TextField in MenuPage
  void updateSearch(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners(); // Refresh the list as the user types
  }

  // Method called by the Category buttons/chips
  void setCategory(ItemCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // The main getter that MenuPage and HomePage use to display items
  List<MenuItem> get filteredItems {
    return _allItems.where((item) {
      final matchesCategory = item.category == _selectedCategory;
      final matchesSearch = item.name.toLowerCase().contains(_searchQuery);

      // Only show if BOTH conditions are true
      return matchesCategory && matchesSearch;
    }).toList();
  }

  // Initial mapping of your raw data into the MenuItem model
  final List<MenuItem> _allItems = drinkItems.map((item) {
    return MenuItem(
      id: item['id'],
      name: item['name'],
      rate: item['rate'],
      price: item['price'],
      imagePath: item['image'],
      category: item['catagory'],
      isFavorited: item['isFavorited'] ?? false,
    );
  }).toList();

  List<MenuItem> get allItems => _allItems;

  // Returns only items marked as favorite for the Favorites page
  List<MenuItem> get favoriteItems =>
      _allItems.where((item) => item.isFavorited).toList();

  void toggleFavorite(int id) {
    final index = _allItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      _allItems[index].isFavorited = !_allItems[index].isFavorited;
      notifyListeners();
    }
  }

  // Inside your MenuProvider class
  List<Map<String, dynamic>> _ledgerOrders = [];

  List<Map<String, dynamic>> get ledgerOrders => _ledgerOrders;

  void addToLedger(MenuItem item, int quantity) {
    _ledgerOrders.add({
      'date':
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year % 100}",
      'name': item.name,
      'qty': quantity.toString(),
      'price': item.price.toString(),
      'total': (item.price * quantity).toString(),
    });
    notifyListeners(); // This tells the Profile Page to rebuild the table
  }

  double get totalDue {
    return _ledgerOrders.fold(
        0, (sum, item) => sum + double.parse(item['total']));
  }
}
