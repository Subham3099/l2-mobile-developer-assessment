import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const PopBalloonsGame());
}

class Balloon {
  final double x;
  double y;
  bool popped;

  Balloon({required this.x, required this.y, this.popped = false});
}

class PopBalloonsGame extends StatefulWidget {
  const PopBalloonsGame({super.key});

  @override
  PopBalloonsGameState createState() => PopBalloonsGameState();
}

class PopBalloonsGameState extends State<PopBalloonsGame> {
  late Timer _timer;
  late int _timeInSeconds;
  late int _score;
  List<Balloon> balloons = [];
  late bool _gameOver;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    _timeInSeconds = 120; // 2 minutes
    _score = 0;
    _gameOver = false;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeInSeconds > 0) {
          _timeInSeconds--;
        } else {
          _timer.cancel();
          _gameOver = true;
        }
      });
    });
  }

  void _generateBalloon() {
    final random = Random();
    balloons.add(Balloon(
      x: random.nextDouble() * MediaQuery.of(context).size.width * 0.8,
      y: MediaQuery.of(context).size.height, // Start from the bottom of the screen
    ));
  }

  void _moveBalloons() {
    setState(() {
      for (int i = 0; i < balloons.length; i++) {
        Balloon balloon = balloons[i];

          double speed = 20 + (120-_timeInSeconds)/40;
          balloon.y -= speed; // Adjust speed as needed
          if (balloon.y < 0) {
            if(balloon.popped == false)
              {
                balloon.popped = true;
                _score--; // Penalty for missed balloon
              }
          }

      }
    });
  }


  void _handleBalloonTap(int index) {
    if (!_gameOver && !balloons[index].popped) {
      setState(() {
        balloons[index].popped = true;
        _score += 2; // Increase score on successful pop
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_gameOver) {
      _moveBalloons();
      if (_timeInSeconds % 3 == 0) {
        _generateBalloon(); // Generate balloons at intervals
      }
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Pop Balloons Game',
            style: TextStyle(color: Colors.white), // Set app bar text color to white
          ),
          backgroundColor: Colors.purple,
        ),
        body: Stack(
          children: [
            GestureDetector(
              onTap: () {
                balloons.asMap().forEach((index, balloon) {
                  if (balloon.y < MediaQuery.of(context).size.height * 0.8 &&
                      balloon.y > MediaQuery.of(context).size.height * 0.1 &&
                      balloon.x <
                          MediaQuery.of(context).size.width * 0.9 &&
                      balloon.x >
                          MediaQuery.of(context).size.width * 0.1) {
                    _handleBalloonTap(index);
                  }
                });
              },
              child: Container(
                color: Colors.white,
                width: double.infinity,
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start, // Align text to the top
                      children: [
                        Text(
                          'Time: ${_timeInSeconds ~/ 60}:${(_timeInSeconds % 60).toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          'Score: $_score',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ...balloons
                .map((balloon) {
              return Positioned(
                left: balloon.x,
                top: balloon.y,
                child: GestureDetector(
                  onTap: () => _handleBalloonTap(balloons.indexOf(balloon)),
                  child: balloon.popped
                      ? Image.asset(
                    'lib/assets/red.png', // Path to the popped balloon image
                    width: 50,
                    height: 70,
                  )
                      : Image.asset(
                    'lib/assets/balloon.png', // Path to the unpopped balloon image
                    width: 50,
                    height: 70,
                  ),
                ),
              );
            }),
            if (_gameOver)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Game Over!',
                      style: TextStyle(fontSize: 30),
                    ),
                    Text(
                      'Final Score: $_score',
                      style: const TextStyle(fontSize: 20),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _resetGame();
                        });
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
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
