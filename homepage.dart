import 'dart:async';

import 'package:flapperburb/barrier.dart';
import 'package:flapperburb/bird.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // Bird Variables
  static double birdY = 0;
  double initialPos = birdY;
  double height = 0;
  double time = 0;
  double gravity = -0.05; // bigger they are the harder they fall
  double velocity = 0.2; // How gud da jump is
  double birdWidth = 0.1;
  double birdHeight = 0.1;

  // Game Settings
  bool gameHasStarted = false;

  // barrier variables
  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5; // out of 2
  List<List<double>> barrierHeight = [
    // out of 2, where 2 is the entire height of the screen
    // [topHeight, bottomHeight]
    [0.6, 0.4],
    [0.4, 0.6],
  ];
  
  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      // Equation for the burb to know how to jump
      height = gravity * time * time + velocity * time;
      
      setState(() {
        birdY = initialPos - height;
      });

        // cheak if ded
        if (birdIsDed()) {
          timer.cancel();
          _showDialog();
        }

        moveMap();

      // LET IT GO ON
      time += 0.1;
    });
  }

  void moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      setState(() {
        barrierX[i] -= 0.005;
      });

      if (barrierX[i] < -1.5) {
        barrierX[i] += 3;
      }
    }
  }

  void resetGame() {
    Navigator.pop(context); // Dismisses Diolog
    setState(() {
      birdY = 0;
      gameHasStarted = false;
      time = 0;
      initialPos = birdY;
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown,
          title: Center(
            child: Text(
              "G A M E  O V E R",
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: resetGame,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  padding: EdgeInsets.all(7),
                  color: Colors.white,
                  child: Text(
                    'PLAY AGAIN',
                    style: TextStyle(color: Colors.brown),
                  ),
                ),
              ),
            )
          ],
        );
      });
  }

  void jump() {
    setState(() {
      time = 0;
      initialPos = birdY;
    });
  }

  bool birdIsDed() {
    //check9ing the burb doesnt hit top or bottom, kill me
    if (birdY < -1 || birdY > 1) {
      return true;
    }
    //cheacking if burb hits barrier
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdY <= -1 + barrierHeight[i] [0] ||
              birdY + birdHeight >= 1 - barrierHeight[i] [1])) {
        return true;
      }
    }
    
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted ? jump : startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Stack(
                    children: [
                        MyBird(
                          birdY: birdY,
                          birdWidth: birdWidth,
                          birdHeight: birdHeight,
                          ),

                          // tap to play
                          // MyCoverScreen(gameHasStarted: gameHasStarted),

                          // Top barrier 0 
                          MyBarrier(
                            barrierX: barrierX[0],
                            barrierWidth: barrierWidth,
                            barrierHeight: barrierHeight[0] [0],
                            isThisBottomBarrier: false,
                          ),

                          // Bottom barrier 0
                          MyBarrier(
                            barrierX: barrierX[0],
                            barrierWidth: barrierWidth,
                            barrierHeight: barrierHeight[0] [1],
                            isThisBottomBarrier: true,
                          ),

                          // Top barrier 1
                          MyBarrier(
                            barrierX: barrierX[1],
                            barrierWidth: barrierWidth,
                            barrierHeight: barrierHeight[1] [0],
                            isThisBottomBarrier: false,
                          ),

                          // Bottom barrier 1
                          MyBarrier(
                            barrierX: barrierX[1],
                            barrierWidth: barrierWidth,
                            barrierHeight: barrierHeight[1] [1],
                            isThisBottomBarrier: true,
                          ),

                          Container(
                            alignment: Alignment(0, -0.5),
                            child: Text(
                              gameHasStarted ? '' : 'T A P  T O  P L A Y',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            ))
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
              ),
            ),
          ],
        ),
      ), 
    );
  }
}