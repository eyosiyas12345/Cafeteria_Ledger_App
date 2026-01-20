import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:helloworld/providers/menu_provider.dart';
import 'package:helloworld/pages/auth/login.dart';
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

    Chapa.configure(
        privateKey: 'CHAPUBK_TEST-pHha9wFE2e7XVAsPbqzjTqh0o5uVgK0o');
    try {
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
