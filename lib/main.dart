import 'package:flutter/material.dart';

import 'package:pls_no_crash/screens/game_screen.dart';

void main() {
  runApp(
    const MaterialApp(
      title: 'Pls No Crash',
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    ),
  );
}
