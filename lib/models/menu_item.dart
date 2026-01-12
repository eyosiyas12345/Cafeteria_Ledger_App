import 'package:helloworld/data/menu_data.dart';

class MenuItem {
  final int id;
  final String name;
  final double rate;
  final int price;
  final String imagePath;
  final ItemCategory category; // Add this line
  bool isFavorited;

  MenuItem({
    required this.id,
    required this.name,
    required this.rate,
    required this.price,
    required this.imagePath,
    required this.category, // Add this line
    required this.isFavorited,
  });
}
