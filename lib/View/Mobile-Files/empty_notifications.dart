import 'package:flutter/material.dart';

class EmptyNotifications extends StatelessWidget {
  const EmptyNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/emptyNotification.png', // Replace 'notification_icon.png' with your actual image asset path
            width: 200, // Adjust width as needed
            height: 200, // Adjust height as needed
          ),
          const SizedBox(height: 20), // Add some space between image and text
          Text(
            'There are no notifications',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.grey.shade800),
          ),
        ],
      ),
    );
  }
}
