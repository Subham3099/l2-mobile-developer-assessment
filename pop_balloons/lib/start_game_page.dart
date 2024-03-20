import 'package:flutter/material.dart';
import 'game_page.dart'; // Import the game page

class StartGamePage extends StatelessWidget {
  const StartGamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pop Balloons Game',
          style: TextStyle(color: Colors.white), // Set app bar text color to white
        ),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the game page when the button is pressed
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PopBalloonsGame()),
            );
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.purple), // Set button color to purple
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(horizontal: 40, vertical: 20), // Increase button padding
            ),
          ),
          child: const Text(
            'Start Game',
            style: TextStyle(color: Colors.white), // Set button text color to white
          ),
        ),
      ),
    );
  }
}
