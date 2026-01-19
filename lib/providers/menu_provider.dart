import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // REQUIRED FOR FirebaseAuth
import 'package:cloud_firestore/cloud_firestore.dart'; // REQUIRED FOR FirebaseFirestore
import 'package:helloworld/data/menu_data.dart';
import 'package:helloworld/models/menu_item.dart';

class MenuProvider extends ChangeNotifier {
  ItemCategory _selectedCategory = ItemCategory.drinks;
  String _searchQuery = "";

  ItemCategory get selectedCategory => _selectedCategory;

  // We no longer keep a local _ledgerOrders list here because
  // the ProfilePage now listens to Firestore directly.

  void clearData() {
    _searchQuery = "";
    // Reset favorites in the local list
    for (var item in _allItems) {
      item.isFavorited = false;
    }
    notifyListeners();
  }

  void updateSearch(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  void setCategory(ItemCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  List<MenuItem> get filteredItems {
    return _allItems.where((item) {
      final matchesCategory = item.category == _selectedCategory;
      final matchesSearch = item.name.toLowerCase().contains(_searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();
  }

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

  List<MenuItem> get favoriteItems =>
      _allItems.where((item) => item.isFavorited).toList();

  void toggleFavorite(int id) {
    final index = _allItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      _allItems[index].isFavorited = !_allItems[index].isFavorited;
      notifyListeners();
    }
  }

  // UPDATED: This now correctly sends data to the cloud
  Future<void> addToLedger(MenuItem item, int quantity) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('ledger').add({
        'uid': user.uid,
        'name': item.name,
        'qty': quantity,
        'price': item.price,
        'total': (item.price * quantity),
        'date':
            "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year % 100}",
        'timestamp': FieldValue.serverTimestamp(),
      });
      // No need to notifyListeners() here because the Stream in ProfilePage
      // will automatically detect this new database entry and update the UI.
    } catch (e) {
      debugPrint("Error adding to ledger: $e");
    }
  }
}
