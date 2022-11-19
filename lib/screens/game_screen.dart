import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pls_no_crash/game/my_game.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final game = MyGame();

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: game,
      backgroundBuilder: (_) => game.background(),
      loadingBuilder: (_) => const Center(child: CircularProgressIndicator()),
      overlayBuilderMap: {
        'main_overlay': (_, MyGame game) => game.mainOverlay(),
        'pause_overlay': (_, MyGame game) => game.pauseOverlay(),
      },
    );
  }
}
