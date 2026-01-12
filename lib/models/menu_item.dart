import 'package:helloworld/data/menu_data.dart';

class MenuItem {
  final int id;
  final String name;
  final double rate;
  final int price;
  final String imagePath;
  bool isFavorited;

  // Constructor
  MenuItem({
    required this.id,
    required this.name,
    required this.rate,
    required this.price,
    required this.imagePath,
    required this.isFavorited,
  });
}
