import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:pls_no_crash/game/model/stats.dart';

class PauseOverlay extends StatelessWidget {
  const PauseOverlay({
    required this.colorScheme,
    required this.onPressed,
    required this.stats,
    Key? key,
  }) : super(key: key);

  final ColorScheme colorScheme;
  final Function() onPressed;
  final Stats stats;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Scaffold(
        backgroundColor: colorScheme.background.withOpacity(0.5),
        body: DefaultTextStyle(
          style: TextStyle(color: colorScheme.primary, fontSize: 20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.pause,
                    size: 128,
                    color: colorScheme.primary,
                  ),
                  const Text(
                    "PAUSE",
                    style: TextStyle(fontSize: 64),
                  ),
                  const SizedBox(height: 32),
                  Text("Highscore: ${stats.highscore}"),
                  Text("Hard Mode Highscore: ${stats.touchlessHighscore}"),
                  Text("Asteroids Missed: ${stats.asteroidsMissed}"),
                  Text("Asteroids Destroyed: ${stats.asteroidsDestroyed}"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
