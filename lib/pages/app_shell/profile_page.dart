import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:helloworld/providers/menu_provider.dart';
import 'package:helloworld/pages/auth/login.dart';

const Color secondaryColor = Color(0xFF5D4037);
const Color whiteColor = Colors.white;
const Color tableBg = Color(0xFFFDF5E6);

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (r) => false);
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    // LISTEN TO PROVIDER
    final menuProvider = Provider.of<MenuProvider>(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: user?.photoURL != null
                              ? NetworkImage(user!.photoURL!)
                              : null,
                          child: user?.photoURL == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        Text(user?.displayName ?? "User",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    // DYNAMIC TOTAL DUE
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          Text("${menuProvider.totalDue.toInt()}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold)),
                          const Text("ETB",
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: 5,
                  right: 5,
                  child: IconButton(
                      icon: const Icon(Icons.logout, color: Colors.red),
                      onPressed: () => _showLogoutDialog(context))),
            ],
          ),
          const Divider(height: 40),
          const Text("Ledger History",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: secondaryColor)),
          const SizedBox(height: 10),

          // DYNAMIC TABLE
          Container(
            color: tableBg,
            width: double.infinity,
            child: Table(
              border: TableBorder.all(color: secondaryColor.withOpacity(0.2)),
              children: [
                _buildHeader(),
                ...menuProvider.ledgerOrders
                    .map((order) => _buildDataRow(order))
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildHeader() {
    return TableRow(
      decoration: BoxDecoration(color: secondaryColor.withOpacity(0.1)),
      children: ["Date", "Item", "Qty", "Price", "Total"]
          .map((h) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(h,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ))
          .toList(),
    );
  }

  TableRow _buildDataRow(Map<String, dynamic> order) {
    return TableRow(
      children: [
        _cell(order['date']),
        _cell(order['name']),
        _cell(order['qty']),
        _cell(order['price']),
        _cell(order['total']),
      ],
    );
  }

  Widget _cell(String text) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, textAlign: TextAlign.center));
}

// import 'package:flutter/material.dart';

// // Assuming these are defined in your app_colors.dart
// const Color secondaryColor = Color(0xFF5D4037);
// const Color whiteColor = Colors.white;
// const Color tableBg = Color(0xFFFDF5E6);

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});

//   static const TextStyle headerStyle = TextStyle(
//     color: secondaryColor,
//     fontSize: 18,
//     fontWeight: FontWeight.bold,
//   );

//   static const TextStyle bodyStyle = TextStyle(
//     color: secondaryColor,
//     fontSize: 16,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           // PROFILE SECTION
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 // This Row separates the Info block (Left) from the Button (Right)
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment
//                       .center, // Vertically aligns button with info
//                   children: [
//                     // LEFT BLOCK: Avatar and Texts
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment
//                           .center, // Centers avatar relative to text
//                       children: const [
//                         SizedBox(height: 10),
//                         CircleAvatar(
//                           radius: 45,
//                           backgroundColor: Colors.grey,
//                           // child: Image.asset('assets/images/Users/profile2.jpg'),
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           "Eyosiyas Gezahegn",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 18),
//                         ),
//                         Text("+251953315160", style: TextStyle(fontSize: 14)),
//                         Text(
//                           "eyosiyasgezahegn@gmail.com",
//                           style: TextStyle(fontSize: 12, color: Colors.grey),
//                         ),
//                       ],
//                     ),

//                     // RIGHT BLOCK: Edit Button
//                     ElevatedButton(
//                         onPressed: () {},
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: secondaryColor,
//                           foregroundColor: whiteColor,
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8)),
//                         ),
//                         child: Column(
//                           children: const [
//                             Text(
//                               "830 ETB",
//                               style: TextStyle(
//                                   color: secondaryColor,
//                                   fontSize: 32,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             Text("Total amount to pay",
//                                 style: TextStyle(color: Colors.grey)),
//                           ],
//                         )),
//                   ],
//                 ),

//                 // const SizedBox(height: 20),
//               ],
//             ),
//           ),

//           const SizedBox(height: 20),

//           // Ledger Title
//           const Padding(
//             padding: EdgeInsets.only(left: 16, bottom: 8),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Align(
//                 alignment: Alignment.center,
//                 child: Text("Ledger",
//                     style: TextStyle(
//                       color: secondaryColor,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     )),
//               ),
//             ),
//           ),

//           // THE TABLE
//           Container(
//             color: tableBg,
//             width: double.infinity,
//             child: Table(
//               columnWidths: const {
//                 0: FlexColumnWidth(2.5),
//                 1: FlexColumnWidth(3),
//                 2: FlexColumnWidth(1.2),
//                 3: FlexColumnWidth(1.5),
//                 4: FlexColumnWidth(1.5),
//               },
//               children: [
//                 _buildTableRow(
//                     ["Date", "Items", "Qty", "Price", "Total"], headerStyle,
//                     isHeader: true),
//                 _buildDataRow(
//                   date: "01/01/2018",
//                   items: ["Tea", "Normal Ferfer"],
//                   qtys: ["1", "1"],
//                   prices: ["20", "100"],
//                   totals: ["20", "120"],
//                   style: bodyStyle,
//                 ),
//                 _buildDataRow(
//                   date: "01/01/2018",
//                   items: ["Cappuccino", "Sega Ferfer"],
//                   qtys: ["2", "1"],
//                   prices: ["80", "200"],
//                   totals: ["200", "400"],
//                   style: bodyStyle,
//                 ),
//                 _buildDataRow(
//                   date: "02/01/2018",
//                   items: ["Cappuccino", "Sega Ferfer"],
//                   qtys: ["2", "1"],
//                   prices: ["80", "200"],
//                   totals: ["200", "400"],
//                   style: bodyStyle,
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // --- Helper Methods ---

//   TableRow _buildTableRow(List<String> cells, TextStyle style,
//       {bool isHeader = false}) {
//     return TableRow(
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(color: secondaryColor, width: isHeader ? 2 : 1),
//         ),
//       ),
//       children: cells
//           .map((text) => Padding(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
//                 child: Text(text, style: style, textAlign: TextAlign.center),
//               ))
//           .toList(),
//     );
//   }

//   TableRow _buildDataRow({
//     required String date,
//     required List<String> items,
//     required List<String> qtys,
//     required List<String> prices,
//     required List<String> totals,
//     required TextStyle style,
//   }) {
//     return TableRow(
//       decoration: const BoxDecoration(
//         border: Border(bottom: BorderSide(color: Color(0x335D4037), width: 1)),
//       ),
//       children: [
//         Padding(
//             padding: const EdgeInsets.all(8), child: Text(date, style: style)),
//         Padding(
//           padding: const EdgeInsets.all(8),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: items.map((i) => Text(i, style: style)).toList(),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8),
//           child:
//               Column(children: qtys.map((q) => Text(q, style: style)).toList()),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8),
//           child: Column(
//               children: prices.map((p) => Text(p, style: style)).toList()),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8),
//           child: Column(
//               children: totals.map((t) => Text(t, style: style)).toList()),
//         ),
//       ],
//     );
//   }
// }
