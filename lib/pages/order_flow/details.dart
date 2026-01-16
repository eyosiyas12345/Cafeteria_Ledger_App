import 'package:flutter/material.dart';
import 'package:helloworld/pages/app_shell/profile_page.dart';
import 'package:provider/provider.dart';
import 'package:helloworld/models/menu_item.dart';
import 'package:helloworld/constants/app_colors.dart';
import 'package:helloworld/providers/menu_provider.dart';

class ItemDetailsPage extends StatefulWidget {
  final MenuItem item;
  const ItemDetailsPage({super.key, required this.item});

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  int selectedQuantity = 1; // Default quantity

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: secondaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(widget.item.imagePath,
                  fit: BoxFit.cover, height: 200, width: double.infinity),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFB74D),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.item.name,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      Text("${widget.item.price} ETB",
                          style: const TextStyle(fontSize: 20)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text("Description",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const Text(
                      "Freshly prepared item from our cafeteria ledger system."),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text("Amount: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 10),
                      // QUANTITY DROPDOWN
                      DropdownButton<int>(
                        value: selectedQuantity,
                        items: [1, 2, 3, 4, 5].map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedQuantity = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: secondaryColor),
                onPressed: () {
                  // SAVE TO PROVIDER
                  Provider.of<MenuProvider>(context, listen: false)
                      .addToLedger(widget.item, selectedQuantity);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Added to Ledger!")),
                  );
                  Navigator.pop(context);
                },
                child: const Text("Add To Ledger",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
