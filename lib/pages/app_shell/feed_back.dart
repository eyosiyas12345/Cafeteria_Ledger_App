import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Logic: To save feedback
import 'package:firebase_auth/firebase_auth.dart'; // Logic: To know who sent it
import 'package:helloworld/constants/app_colors.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  // Logic variables
  int _selectedStars = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  // Function to send data to Firebase
  Future<void> _submitFeedback() async {
    if (_selectedStars == 0) return; // Don't submit if no stars selected

    setState(() => _isSubmitting = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection('feedbacks').add({
        'uid': user?.uid,
        'rating': _selectedStars,
        'comment': _commentController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Feedback Sent!")),
      );
      setState(() {
        _selectedStars = 0;
        _commentController.clear();
        _isSubmitting = false;
      });
    } catch (e) {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // We use your exact Column and Container structure
    return Column(
      children: [
        /// HEADER (Exactly as you had it)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: const BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: const Center(
            child: Text(
              'We value your opinion.',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: secondayColor, // Kept your original color name
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        /// CONTENT
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'How would you rate our overall service',
                style: TextStyle(fontSize: 14),
              ),

              const SizedBox(height: 16),

              /// STAR RATING (Now Dynamic)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedStars = index + 1;
                      });
                    },
                    child: Icon(
                      // Logic: If index is less than selected, show filled star
                      index < _selectedStars ? Icons.star : Icons.star_border,
                      size: 32,
                      color:
                          index < _selectedStars ? Colors.amber : secondayColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Kindly take a moment to tell us what you think',
                style: TextStyle(fontSize: 13),
              ),

              const SizedBox(height: 16),

              /// COMMENT BOX (Now with Controller)
              TextField(
                controller: _commentController, // Added this
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Type your comment here',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// SUBMIT BUTTON (Now works with Firebase)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xfffe5b1f),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: _isSubmitting ? null : _submitFeedback,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text(
                          'Share my feedback',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:helloworld/constants/app_colors.dart';

// class FeedbackScreen extends StatelessWidget {
//   const FeedbackScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         /// HEADER
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(vertical: 24),
//           decoration: const BoxDecoration(
//             color: primaryColor,
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(40),
//               bottomRight: Radius.circular(40),
//             ),
//           ),
//           child: const Center(
//             child: Text(
//               'We value your opinion.',
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: secondayColor,
//               ),
//             ),
//           ),
//         ),

//         const SizedBox(height: 24),

//         /// CONTENT
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const Text(
//                 'How would you rate our overall service',
//                 style: TextStyle(fontSize: 14),
//               ),

//               const SizedBox(height: 16),

//               /// STAR RATING
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(
//                   5,
//                   (index) => const Icon(
//                     Icons.star_border,
//                     size: 32,
//                     color: secondayColor,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 24),

//               const Text(
//                 'Kindly take a moment to tell us what you think',
//                 style: TextStyle(fontSize: 13),
//               ),

//               const SizedBox(height: 16),

//               /// COMMENT BOX
//               TextField(
//                 maxLines: 5,
//                 decoration: InputDecoration(
//                   hintText: 'Type your comment here',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 24),

//               /// SUBMIT BUTTON
//               SizedBox(
//                 width: double.infinity,
//                 height: 48,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xfffe5b1f),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(24),
//                     ),
//                   ),
//                   onPressed: () {},
//                   child: const Text(
//                     'Share my feedback',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );

//     /// BOTTOM NAVIGATION
//     bottomNavigationBar:
//     BottomNavigationBar(
//       selectedItemColor: secondayColor,
//       unselectedItemColor: Colors.grey,
//       type: BottomNavigationBarType.fixed,
//       items: const [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.home),
//           label: 'Home',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.restaurant_menu),
//           label: 'Menu',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.comment),
//           label: 'Comment',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.person),
//           label: 'Profile',
//         ),
//       ],
//     );
//   }
// }
