import 'package:flutter/material.dart';

// Assuming these are defined in your app_colors.dart
const Color secondaryColor = Color(0xFF5D4037);
const Color whiteColor = Colors.white;
const Color tableBg = Color(0xFFFDF5E6);

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const TextStyle headerStyle = TextStyle(
    color: secondaryColor,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyStyle = TextStyle(
    color: secondaryColor,
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Top Settings Icon
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.orange),
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(Icons.settings, color: secondaryColor),
              ),
            ),
          ),

          // PROFILE SECTION
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // This Row separates the Info block (Left) from the Button (Right)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Vertically aligns button with info
                  children: [
                    // LEFT BLOCK: Avatar and Texts
                    Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // Centers avatar relative to text
                      children: const [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.grey,
                          // child: Image.asset('assets/images/Users/profile2.jpg'),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Eyosiyas Gezahegn",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text("+251953315160", style: TextStyle(fontSize: 14)),
                        Text(
                          "eyosiyasgezahegn@gmail.com",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),

                    // RIGHT BLOCK: Edit Button
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor,
                        foregroundColor: whiteColor,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Edit Profile"),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // TOTAL AMOUNT SECTION
                const Text(
                  "830 ETB",
                  style: TextStyle(
                      color: secondaryColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
                const Text("Total amount to pay",
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Ledger Title
          const Padding(
            padding: EdgeInsets.only(left: 16, bottom: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Align(
                alignment: Alignment.center,
                child: Text("Ledger",
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
          ),

          // THE TABLE
          Container(
            color: tableBg,
            width: double.infinity,
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2.5),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(1.2),
                3: FlexColumnWidth(1.5),
                4: FlexColumnWidth(1.5),
              },
              children: [
                _buildTableRow(
                    ["Date", "Items", "Qty", "Price", "Total"], headerStyle,
                    isHeader: true),
                _buildDataRow(
                  date: "01/01/2018",
                  items: ["Tea", "Normal Ferfer"],
                  qtys: ["1", "1"],
                  prices: ["20", "100"],
                  totals: ["20", "120"],
                  style: bodyStyle,
                ),
                _buildDataRow(
                  date: "01/01/2018",
                  items: ["Cappuccino", "Sega Ferfer"],
                  qtys: ["2", "1"],
                  prices: ["80", "200"],
                  totals: ["200", "400"],
                  style: bodyStyle,
                ),
                _buildDataRow(
                  date: "02/01/2018",
                  items: ["Cappuccino", "Sega Ferfer"],
                  qtys: ["2", "1"],
                  prices: ["80", "200"],
                  totals: ["200", "400"],
                  style: bodyStyle,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Methods ---

  TableRow _buildTableRow(List<String> cells, TextStyle style,
      {bool isHeader = false}) {
    return TableRow(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: secondaryColor, width: isHeader ? 2 : 1),
        ),
      ),
      children: cells
          .map((text) => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                child: Text(text, style: style, textAlign: TextAlign.center),
              ))
          .toList(),
    );
  }

  TableRow _buildDataRow({
    required String date,
    required List<String> items,
    required List<String> qtys,
    required List<String> prices,
    required List<String> totals,
    required TextStyle style,
  }) {
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0x335D4037), width: 1)),
      ),
      children: [
        Padding(
            padding: const EdgeInsets.all(8), child: Text(date, style: style)),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items.map((i) => Text(i, style: style)).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child:
              Column(children: qtys.map((q) => Text(q, style: style)).toList()),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
              children: prices.map((p) => Text(p, style: style)).toList()),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
              children: totals.map((t) => Text(t, style: style)).toList()),
        ),
      ],
    );
  }
}
