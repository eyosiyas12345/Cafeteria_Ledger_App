import 'package:flutter/material.dart';
import 'package:helloworld/constants/app_colors.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// HEADER
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
                color: secondayColor,
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

              /// STAR RATING
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => const Icon(
                    Icons.star_border,
                    size: 32,
                    color: secondayColor,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Kindly take a moment to tell us what you think',
                style: TextStyle(fontSize: 13),
              ),

              const SizedBox(height: 16),

              /// COMMENT BOX
              TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Type your comment here',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xfffe5b1f),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
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

    /// BOTTOM NAVIGATION
    bottomNavigationBar:
    BottomNavigationBar(
      selectedItemColor: secondayColor,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          label: 'Menu',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.comment),
          label: 'Comment',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
