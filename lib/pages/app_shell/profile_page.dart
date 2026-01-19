import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:helloworld/providers/menu_provider.dart';
import 'package:helloworld/pages/auth/login.dart';
// import 'dart:html' as html if (dart.library.io) 'package:helloworld/dummy_html.dart';
// This tells Flutter: "Only import dart:html if we are on a browser"
import 'dart:io' show Platform;

const Color secondaryColor = Color(0xFF5D4037);
const Color whiteColor = Colors.white;
const Color tableBg = Color(0xFFFDF5E6);

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  late Stream<DocumentSnapshot> _userStream;
  late Stream<QuerySnapshot> _ledgerStream;

  @override
  void initState() {
    super.initState();
    _initializeStreams();
  }

  void _initializeStreams() {
    if (_currentUser != null) {
      _userStream = FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .snapshots();

      _ledgerStream = FirebaseFirestore.instance
          .collection('ledger')
          .where('uid', isEqualTo: _currentUser!.uid)
          .orderBy('timestamp', descending: true)
          .snapshots();
    }
  }

  Future<void> _payWithChapa(double amount) async {
    final String txRef = "TXN${DateTime.now().millisecondsSinceEpoch}";

    // STEP 1: Set the key directly on the instance property
    // In 0.0.5, this is how you "configure" it.
    Chapa.configure(
        privateKey: 'CHAPUBK_TEST-pHha9wFE2e7XVAsPbqzjTqh0o5uVgK0o');
    try {
      // STEP 2: Call startPayment WITHOUT the publicKey parameter
      // (because it's already set above)
      await Chapa.getInstance.startPayment(
        context: context,
        amount: amount.toStringAsFixed(2),
        currency: 'ETB',
        txRef: txRef,
        email: _currentUser?.email ?? "test@gmail.com",
        firstName: _currentUser?.displayName ?? "User",
        lastName: "Customer", // Mandatory in 0.0.5
        title: "Ledger Payment", // Mandatory in 0.0.5
        description: "Paying off cafeteria debt",
        onInAppPaymentSuccess: (successMsg) {
          _handlePaymentSuccess();
        },
        onInAppPaymentError: (errorMsg) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Error: $errorMsg"), backgroundColor: Colors.red),
          );
        },
      );
    } catch (e) {
      if (kIsWeb) {
        _showWebWarning();
      } else {
        print("Chapa Error: $e");
      }
    }
  }

  void _showWebWarning() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Web Security Restriction"),
        content: const Text(
            "Browsers block payment requests from IDEs like FlutLab for security (CORS error).\n\n"
            "To test this successfully:\n"
            "1. Click 'Build APK' in FlutLab.\n"
            "2. Install the app on your phone.\n"
            "3. Payment will work perfectly there."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("I Understand"))
        ],
      ),
    );
  }
  //--Chapa integration function for ANDROID
  // Future<void> _payWithChapa(double amount) async {
  //   if (amount <= 0) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("No balance due to pay.")),
  //     );
  //     return;
  //   }

  //   // Reference for the transaction
  //   // final String txRef =
  //   //     "txn_${_currentUser?.uid}_${DateTime.now().millisecondsSinceEpoch}";
  //   final String txRef = "TXN${DateTime.now().millisecondsSinceEpoch}";
  //   try {
  //     // Trigger the Chapa Payment Sheet
  //     await Chapa.getInstance.startPayment(
  //       context: context,
  //       amount: amount.toStringAsFixed(2),
  //       currency: 'ETB',
  //       txRef: txRef,
  //       email: _currentUser?.email ?? "customer@example.com",
  //       firstName: _currentUser?.displayName ?? "Customer",
  //       lastName: "User",
  //       title: "Order Settlement",
  //       description: "Payment for ledger items",
  //       onInAppPaymentSuccess: (successMsg) {
  //         _handlePaymentSuccess();
  //       },
  //       onInAppPaymentError: (errorMsg) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //               content: Text("Payment Failed: $errorMsg"),
  //               backgroundColor: Colors.red),
  //         );
  //       },
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Payment Error: $e")),
  //     );
  //   }
  // }

  // Logic to run after successful payment
  void _handlePaymentSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("Payment Successful!"), backgroundColor: Colors.green),
    );
    // You can add code here to update the ledger in Firestore to 'paid'
  }

  void _showLogoutDialog(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context, listen: false);
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
              menuProvider.clearData();
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (r) => false);
              }
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) return const Center(child: Text("Please Log In"));

    return StreamBuilder<DocumentSnapshot>(
      stream: _userStream,
      builder: (context, userSnapshot) {
        var userData = userSnapshot.data?.data() as Map<String, dynamic>?;
        String name = userData?['fullName'] ?? "User";
        String phone = userData?['phone'] ?? "No phone";
        String email = _currentUser!.email ?? "";
        String profilePic = userData?['profilePic'] ?? "";

        return StreamBuilder<QuerySnapshot>(
          stream: _ledgerStream,
          builder: (context, ledgerSnapshot) {
            if (ledgerSnapshot.hasError) {
              return Center(child: Text("Error: ${ledgerSnapshot.error}"));
            }

            // Maintain data during rebuilds
            final docs = ledgerSnapshot.data?.docs ?? [];
            if (ledgerSnapshot.connectionState == ConnectionState.waiting &&
                docs.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            double totalDue = 0;
            for (var doc in docs) {
              totalDue += (doc['total'] as num).toDouble();
            }

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildProfileHeader(name, phone, email, profilePic, totalDue),
                  const Divider(height: 40),
                  const Text("Ledger History",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: secondaryColor)),
                  const SizedBox(height: 10),
                  docs.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text("No items in ledger."))
                      : Container(
                          color: tableBg,
                          width: double.infinity,
                          child: Table(
                            border: TableBorder.all(
                                color: secondaryColor.withOpacity(0.2)),
                            children: [
                              _buildHeader(),
                              ...docs
                                  .map((doc) => _buildDataRow(
                                      doc.data() as Map<String, dynamic>))
                                  .toList(),
                            ],
                          ),
                        ),
                  const SizedBox(height: 100),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // UI Methods (Kept exactly as requested)
  Widget _buildProfileHeader(String name, String phone, String email,
      String profilePic, double totalDue) {
    return Stack(
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
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage:
                        profilePic.isNotEmpty ? NetworkImage(profilePic) : null,
                    child: profilePic.isEmpty
                        ? const Icon(Icons.person,
                            size: 40, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 8),
                  Text(name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(phone, style: const TextStyle(fontSize: 12)),
                  Text(email,
                      style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        Text("${totalDue.toInt()}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                        const Text("ETB Due",
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed:
                        totalDue > 0 ? () => _payWithChapa(totalDue) : null,
                    icon: const Icon(Icons.payment, size: 18),
                    label: const Text("Pay Now"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade900,
                      foregroundColor: Colors.white,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () => _showLogoutDialog(context),
          ),
        ),
      ],
    );
  }

  TableRow _buildHeader() {
    return TableRow(
      decoration: BoxDecoration(color: secondaryColor.withOpacity(0.1)),
      children: ["Date", "Item", "Qty", "Price", "Total"]
          .map((h) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(h,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 11),
                    textAlign: TextAlign.center),
              ))
          .toList(),
    );
  }

  TableRow _buildDataRow(Map<String, dynamic> order) {
    return TableRow(
      children: [
        _cell(order['date']?.toString() ?? "-"),
        _cell(order['name']?.toString() ?? "-"),
        _cell(order['qty']?.toString() ?? "0"),
        _cell(order['price']?.toString() ?? "0"),
        _cell(order['total']?.toString() ?? "0"),
      ],
    );
  }

  Widget _cell(String text) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text,
          textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)));
}

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:provider/provider.dart';
// import 'package:chapa_unofficial/chapa_unofficial.dart';
// import 'package:helloworld/providers/menu_provider.dart';
// import 'package:helloworld/pages/auth/login.dart';

// const Color secondaryColor = Color(0xFF5D4037);
// const Color whiteColor = Colors.white;
// const Color tableBg = Color(0xFFFDF5E6);

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   final User? _currentUser = FirebaseAuth.instance.currentUser;
//   late Stream<DocumentSnapshot> _userStream;
//   late Stream<QuerySnapshot> _ledgerStream;

//   @override
//   void initState() {
//     super.initState();
//     _initializeStreams();
//   }

//   void _initializeStreams() {
//     if (_currentUser != null) {
//       // Stream for User Information
//       _userStream = FirebaseFirestore.instance
//           .collection('users')
//           .doc(_currentUser!.uid)
//           .snapshots();

//       // Stream for Ledger Records
//       // NOTE: Ensure your Firestore field is named 'uid' and the index is enabled.
//       _ledgerStream = FirebaseFirestore.instance
//           .collection('ledger')
//           .where('uid', isEqualTo: _currentUser!.uid)
//           .orderBy('timestamp', descending: true)
//           .snapshots();
//     }
//   }

//   Future<void> _payWithChapa(double amount) async {
//     if (amount <= 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("No balance due to pay.")),
//       );
//       return;
//     }

//     final String txRef =
//         "txn_${_currentUser?.uid}_${DateTime.now().millisecondsSinceEpoch}";

//     try {
//       await Chapa.getInstance.startPayment(
//         context: context,
//         amount: amount.toString(),
//         currency: 'ETB',
//         txRef: txRef,
//         email: _currentUser?.email ?? "customer@example.com",
//         firstName: _currentUser?.displayName ?? "Customer",
//         lastName: "User",
//         title: "Order Settlement",
//         description: "Payment for ledger items",
//         onInAppPaymentSuccess: (successMsg) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//                 content: Text("Payment Successful!"),
//                 backgroundColor: Colors.green),
//           );
//         },
//         onInAppPaymentError: (errorMsg) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//                 content: Text("Payment Failed: $errorMsg"),
//                 backgroundColor: Colors.red),
//           );
//         },
//       );
//     } catch (e) {
//       debugPrint("Chapa Error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Payment Error: $e")),
//       );
//     }
//   }

//   void _showLogoutDialog(BuildContext context) {
//     final menuProvider = Provider.of<MenuProvider>(context, listen: false);

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Logout"),
//         content: const Text("Are you sure?"),
//         actions: [
//           TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel")),
//           FilledButton(
//             style: FilledButton.styleFrom(backgroundColor: Colors.red),
//             onPressed: () async {
//               menuProvider.clearData();
//               await FirebaseAuth.instance.signOut();
//               if (mounted) {
//                 Navigator.of(context).pushAndRemoveUntil(
//                     MaterialPageRoute(builder: (context) => const LoginPage()),
//                     (r) => false);
//               }
//             },
//             child: const Text("Logout"),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_currentUser == null) return const Center(child: Text("Please Log In"));

//     return StreamBuilder<DocumentSnapshot>(
//       stream: _userStream,
//       builder: (context, userSnapshot) {
//         var userData = userSnapshot.data?.data() as Map<String, dynamic>?;
//         String name = userData?['fullName'] ?? "User";
//         String phone = userData?['phone'] ?? "No phone";
//         String email = _currentUser!.email ?? "";
//         String profilePic = userData?['profilePic'] ?? "";

//         return StreamBuilder<QuerySnapshot>(
//           stream: _ledgerStream,
//           builder: (context, ledgerSnapshot) {
//             // FIX: If the index is still building or has an issue, show a helpful message
//             if (ledgerSnapshot.hasError) {
//               return Center(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Text(
//                     "Database Error: ${ledgerSnapshot.error}\n\nHint: Ensure 'uid' matches in Firestore.",
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(color: Colors.red),
//                   ),
//                 ),
//               );
//             }

//             // FIX: Prevent UI from "disappearing" while waiting for fresh data
//             if (ledgerSnapshot.connectionState == ConnectionState.waiting &&
//                 !ledgerSnapshot.hasData) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             final docs = ledgerSnapshot.data?.docs ?? [];
//             double totalDue = 0;
//             for (var doc in docs) {
//               final data = doc.data() as Map<String, dynamic>;
//               totalDue += (data['total'] as num? ?? 0).toDouble();
//             }

//             return SingleChildScrollView(
//               physics: const AlwaysScrollableScrollPhysics(),
//               child: Column(
//                 children: [
//                   _buildProfileHeader(name, phone, email, profilePic, totalDue),
//                   const Divider(height: 40),
//                   const Text("Ledger History",
//                       style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: secondaryColor)),
//                   const SizedBox(height: 10),

//                   // Ledger Table
//                   docs.isEmpty
//                       ? const Padding(
//                           padding: EdgeInsets.symmetric(vertical: 40),
//                           child: Column(
//                             children: [
//                               Icon(Icons.receipt_long,
//                                   size: 50, color: Colors.grey),
//                               SizedBox(height: 10),
//                               Text("No items found in your ledger.",
//                                   style: TextStyle(color: Colors.grey)),
//                             ],
//                           ),
//                         )
//                       : Container(
//                           color: tableBg,
//                           width: double.infinity,
//                           child: Table(
//                             border: TableBorder.all(
//                                 color: secondaryColor.withOpacity(0.2)),
//                             children: [
//                               _buildHeader(),
//                               ...docs.map((doc) {
//                                 return _buildDataRow(
//                                     doc.data() as Map<String, dynamic>);
//                               }).toList(),
//                             ],
//                           ),
//                         ),
//                   const SizedBox(height: 100),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   // UI Methods (Preserved as requested)
//   Widget _buildProfileHeader(String name, String phone, String email,
//       String profilePic, double totalDue) {
//     return Stack(
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 children: [
//                   CircleAvatar(
//                     radius: 40,
//                     backgroundColor: Colors.grey.shade300,
//                     backgroundImage:
//                         profilePic.isNotEmpty ? NetworkImage(profilePic) : null,
//                     child: profilePic.isEmpty
//                         ? const Icon(Icons.person,
//                             size: 40, color: Colors.white)
//                         : null,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(name,
//                       style: const TextStyle(
//                           fontWeight: FontWeight.bold, fontSize: 16)),
//                   Text(phone, style: const TextStyle(fontSize: 12)),
//                   Text(email,
//                       style: const TextStyle(fontSize: 10, color: Colors.grey)),
//                 ],
//               ),
//               Column(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                         color: secondaryColor,
//                         borderRadius: BorderRadius.circular(12)),
//                     child: Column(
//                       children: [
//                         Text("${totalDue.toInt()}",
//                             style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold)),
//                         const Text("ETB Due",
//                             style:
//                                 TextStyle(color: Colors.white, fontSize: 12)),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   ElevatedButton.icon(
//                     onPressed:
//                         totalDue > 0 ? () => _payWithChapa(totalDue) : null,
//                     icon: const Icon(Icons.payment, size: 18),
//                     label: const Text("Pay Now"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.orange.shade900,
//                       foregroundColor: Colors.white,
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//         Positioned(
//           top: 5,
//           right: 5,
//           child: IconButton(
//             icon: const Icon(Icons.logout, color: Colors.red),
//             onPressed: () => _showLogoutDialog(context),
//           ),
//         ),
//       ],
//     );
//   }

//   TableRow _buildHeader() {
//     return TableRow(
//       decoration: BoxDecoration(color: secondaryColor.withOpacity(0.1)),
//       children: ["Date", "Item", "Qty", "Price", "Total"]
//           .map((h) => Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(h,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 11),
//                     textAlign: TextAlign.center),
//               ))
//           .toList(),
//     );
//   }

//   TableRow _buildDataRow(Map<String, dynamic> order) {
//     return TableRow(
//       children: [
//         _cell(order['date']?.toString() ?? "-"),
//         _cell(order['name']?.toString() ?? "-"),
//         _cell(order['qty']?.toString() ?? "0"),
//         _cell(order['price']?.toString() ?? "0"),
//         _cell(order['total']?.toString() ?? "0"),
//       ],
//     );
//   }

//   Widget _cell(String text) => Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Text(text,
//           textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)));
// }
// +++++++++++++++++++++++++++++++++++++++++++++++++++++
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:provider/provider.dart';
// import 'package:helloworld/providers/menu_provider.dart';
// import 'package:helloworld/pages/auth/login.dart';

// const Color secondaryColor = Color(0xFF5D4037);
// const Color whiteColor = Colors.white;
// const Color tableBg = Color(0xFFFDF5E6);

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});

//   void _showLogoutDialog(BuildContext context) {
//     final menuProvider = Provider.of<MenuProvider>(context, listen: false);

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Logout"),
//         content: const Text("Are you sure?"),
//         actions: [
//           TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel")),
//           FilledButton(
//             style: FilledButton.styleFrom(backgroundColor: Colors.red),
//             onPressed: () async {
//               menuProvider.clearData();
//               await FirebaseAuth.instance.signOut();
//               if (context.mounted) {
//                 Navigator.of(context).pushAndRemoveUntil(
//                     MaterialPageRoute(builder: (context) => const LoginPage()),
//                     (r) => false);
//               }
//             },
//             child: const Text("Logout"),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final User? currentUser = FirebaseAuth.instance.currentUser;

//     // 1. Listen to the User Info (Name, Email, etc.)
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('users')
//           .doc(currentUser?.uid)
//           .snapshots(),
//       builder: (context, userSnapshot) {
//         if (userSnapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         String name = "User";
//         String email = currentUser?.email ?? "";
//         String phone = "No phone provided";
//         String profilePic = "";

//         if (userSnapshot.hasData && userSnapshot.data!.exists) {
//           var data = userSnapshot.data!.data() as Map<String, dynamic>;
//           name = data['fullName'] ?? "User";
//           phone = data['phone'] ?? "No phone";
//           profilePic = data['profilePic'] ?? "";
//         }

//         // 2. Listen to the Ledger Data in Firestore
//         return StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('ledger')
//               .where('uid', isEqualTo: currentUser?.uid) // Filter by user
//               .orderBy('timestamp', descending: true) // Newest first
//               .snapshots(),
//           builder: (context, ledgerSnapshot) {
//             final docs = ledgerSnapshot.data?.docs ?? [];

//             // Calculate Total Due dynamically from Firestore
//             double totalDue = 0;
//             for (var doc in docs) {
//               totalDue += (doc['total'] as num).toDouble();
//             }

//             return SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Stack(
//                     children: [
//                       Padding(
//                         padding:
//                             const EdgeInsets.only(top: 40, left: 16, right: 16),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               children: [
//                                 CircleAvatar(
//                                   radius: 40,
//                                   backgroundColor: Colors.grey.shade300,
//                                   backgroundImage: profilePic.isNotEmpty
//                                       ? NetworkImage(profilePic)
//                                       : null,
//                                   child: profilePic.isEmpty
//                                       ? const Icon(Icons.person,
//                                           size: 40, color: Colors.white)
//                                       : null,
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(name,
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16)),
//                                 Text(phone,
//                                     style: const TextStyle(fontSize: 12)),
//                                 Text(email,
//                                     style: const TextStyle(
//                                         fontSize: 10, color: Colors.grey)),
//                               ],
//                             ),
//                             // UI BOX: Total Due
//                             Container(
//                               padding: const EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                   color: secondaryColor,
//                                   borderRadius: BorderRadius.circular(12)),
//                               child: Column(
//                                 children: [
//                                   Text("${totalDue.toInt()}",
//                                       style: const TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 24,
//                                           fontWeight: FontWeight.bold)),
//                                   const Text("ETB Due",
//                                       style: TextStyle(
//                                           color: Colors.white, fontSize: 12)),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Positioned(
//                           top: 5,
//                           right: 5,
//                           child: IconButton(
//                               icon: const Icon(Icons.logout, color: Colors.red),
//                               onPressed: () => _showLogoutDialog(context))),
//                     ],
//                   ),
//                   const Divider(height: 40),
//                   const Text("Ledger History",
//                       style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: secondaryColor)),
//                   const SizedBox(height: 10),

//                   // UI TABLE: Ledger Items
//                   Container(
//                     color: tableBg,
//                     width: double.infinity,
//                     child: Table(
//                       border: TableBorder.all(
//                           color: secondaryColor.withOpacity(0.2)),
//                       children: [
//                         _buildHeader(),
//                         ...docs.map((doc) {
//                           final order = doc.data() as Map<String, dynamic>;
//                           return _buildDataRow(order);
//                         }).toList(),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   TableRow _buildHeader() {
//     return TableRow(
//       decoration: BoxDecoration(color: secondaryColor.withOpacity(0.1)),
//       children: ["Date", "Item", "Qty", "Price", "Total"]
//           .map((h) => Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(h,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 12),
//                     textAlign: TextAlign.center),
//               ))
//           .toList(),
//     );
//   }

//   TableRow _buildDataRow(Map<String, dynamic> order) {
//     return TableRow(
//       children: [
//         _cell(order['date'].toString()),
//         _cell(order['name'].toString()),
//         _cell(order['qty'].toString()),
//         _cell(order['price'].toString()),
//         _cell(order['total'].toString()),
//       ],
//     );
//   }

//   Widget _cell(String text) => Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Text(text,
//           textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)));
// }

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Logic: To fetch user data
// import 'package:provider/provider.dart';
// import 'package:helloworld/providers/menu_provider.dart';
// import 'package:helloworld/pages/auth/login.dart';

// const Color secondaryColor = Color(0xFF5D4037);
// const Color whiteColor = Colors.white;
// const Color tableBg = Color(0xFFFDF5E6);

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});

//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Logout"),
//         content: const Text("Are you sure?"),
//         actions: [
//           TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel")),
//           FilledButton(
//             style: FilledButton.styleFrom(backgroundColor: Colors.red),
//             onPressed: () async {
//               await FirebaseAuth.instance.signOut();
//               Navigator.of(context).pushAndRemoveUntil(
//                   MaterialPageRoute(builder: (context) => const LoginPage()),
//                   (r) => false);
//             },
//             child: const Text("Logout"),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final User? currentUser = FirebaseAuth.instance.currentUser;
//     final menuProvider = Provider.of<MenuProvider>(context);

//     return StreamBuilder<DocumentSnapshot>(
//       // Logic: Listen to this specific user's document in Firestore
//       stream: FirebaseFirestore.instance
//           .collection('users')
//           .doc(currentUser?.uid)
//           .snapshots(),
//       builder: (context, snapshot) {
//         // Show loading while fetching data
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         // Default data if something goes wrong
//         String name = "User";
//         String email = currentUser?.email ?? "";
//         String phone = "No phone provided";
//         String profilePic = "";

//         // If data exists, grab the fields we saved during Signup
//         if (snapshot.hasData && snapshot.data!.exists) {
//           var data = snapshot.data!.data() as Map<String, dynamic>;
//           name = data['fullName'] ?? "User";
//           phone = data['phone'] ?? "No phone";
//           profilePic = data['profilePic'] ?? "";
//         }

//         return SingleChildScrollView(
//           child: Column(
//             children: [
//               Stack(
//                 children: [
//                   Padding(
//                     padding:
//                         const EdgeInsets.only(top: 40, left: 16, right: 16),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           children: [
//                             CircleAvatar(
//                               radius: 40,
//                               backgroundColor: Colors.grey.shade300,
//                               backgroundImage: profilePic.isNotEmpty
//                                   ? NetworkImage(profilePic)
//                                   : null,
//                               child: profilePic.isEmpty
//                                   ? const Icon(Icons.person,
//                                       size: 40, color: Colors.white)
//                                   : null,
//                             ),
//                             const SizedBox(height: 8),
//                             Text(name,
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 16)),
//                             Text(phone, style: const TextStyle(fontSize: 12)),
//                             Text(email,
//                                 style: const TextStyle(
//                                     fontSize: 10, color: Colors.grey)),
//                           ],
//                         ),
//                         // DYNAMIC TOTAL DUE (From your Provider)
//                         Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                               color: secondaryColor,
//                               borderRadius: BorderRadius.circular(12)),
//                           child: Column(
//                             children: [
//                               Text("${menuProvider.totalDue.toInt()}",
//                                   style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.bold)),
//                               const Text("ETB Due",
//                                   style: TextStyle(
//                                       color: Colors.white, fontSize: 12)),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Positioned(
//                       top: 5,
//                       right: 5,
//                       child: IconButton(
//                           icon: const Icon(Icons.logout, color: Colors.red),
//                           onPressed: () => _showLogoutDialog(context))),
//                 ],
//               ),
//               const Divider(height: 40),
//               const Text("Ledger History",
//                   style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: secondaryColor)),
//               const SizedBox(height: 10),

//               // DYNAMIC TABLE
//               Container(
//                 color: tableBg,
//                 width: double.infinity,
//                 child: Table(
//                   border:
//                       TableBorder.all(color: secondaryColor.withOpacity(0.2)),
//                   children: [
//                     _buildHeader(),
//                     ...menuProvider.ledgerOrders
//                         .map((order) => _buildDataRow(order))
//                         .toList(),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   TableRow _buildHeader() {
//     return TableRow(
//       decoration: BoxDecoration(color: secondaryColor.withOpacity(0.1)),
//       children: ["Date", "Item", "Qty", "Price", "Total"]
//           .map((h) => Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(h,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 12),
//                     textAlign: TextAlign.center),
//               ))
//           .toList(),
//     );
//   }

//   TableRow _buildDataRow(Map<String, dynamic> order) {
//     return TableRow(
//       children: [
//         _cell(order['date'].toString()),
//         _cell(order['name'].toString()),
//         _cell(order['qty'].toString()),
//         _cell(order['price'].toString()),
//         _cell(order['total'].toString()),
//       ],
//     );
//   }

//   Widget _cell(String text) => Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Text(text,
//           textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)));
// }

// +++++++++++++++++++++++++++++++++++++++++++++

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
