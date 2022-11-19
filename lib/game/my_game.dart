import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pls_no_crash/game/game_background.dart';
import 'package:pls_no_crash/game/model/stats.dart';
import 'package:pls_no_crash/game/overlays/main_overlay.dart';
import 'package:pls_no_crash/game/overlays/pause_overlay.dart';
import 'package:pls_no_crash/game/utils.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'components/components.dart';

class MyGame extends FlameGame
    with HasCollidables, TapDetector, KeyboardEvents {
  ///
  /// ATTRIBUTES and a getter
  ///
  late final PlayerComponent player = PlayerComponent(onExplosion: _resetLevel);
  ValueNotifier<bool> hardMode = ValueNotifier(false);
  ValueNotifier<int> level = ValueNotifier(1);
  ColorScheme colorScheme = randomColorScheme();
  Stats stats = Stats();

  /// Gets asteroids list as every game child of type Asteroid
  List get asteroids => children
      .where((element) => element.runtimeType == AsteroidComponent)
      .toList();

  ///
  /// LIFECYCLE EVENTS
  ///

  @override
  Future<void> onMount() async {
    // Add the player to the game
    add(player);

    // Add first asteroid with initial position
    _addAteroid(position: Vector2(size.x / 2, 100));

    _listenToLevelChanges();

    _listenToGyroscope();

    overlays.add('main_overlay');

    stats = await loadStats();

    super.onMount();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Remove all asteroids and asteroid fragments that passed the player
    for (final child in children) {
      if (child is AsteroidComponent && child.position.y > size.y + 100) {
        remove(child);
        stats.asteroidsMissed++;
      }
      if (child is AsteroidFragmentComponent &&
          child.position.y > size.y + 50) {
        remove(child);
      }
    }

    // Increments level when all asteroids are gone
    // creates new asteroids
    if (asteroids.isEmpty) {
      _addAsteroids();
      level.value++;
    }
  }

  @override
  Future<void> onRemove() async {
    // Save stats when destroying screen
    // Must be awaited to have access to stats
    await saveStats(stats);
    super.onRemove();
  }

  ///
  /// LEVEL EVENTS
  ///

  /// reacts to level change
  void _listenToLevelChanges() {
    level.addListener(() {
      // Create a colorScheme for the next level
      colorScheme = randomColorScheme();

      // Update highscores
      if (level.value > stats.highscore) {
        stats.highscore = level.value;
      }
      if (hardMode.value && level.value > stats.touchlessHighscore) {
        stats.touchlessHighscore = level.value;
      }
    });
  }

  /// Goes to the first level
  void _resetLevel() {
    level.value = 0;
    stats.asteroidsDestroyed++;
  }

  ///
  /// ASTEROID METHODS
  ///

  /// Creates an asteroid with optional position
  void _addAteroid({Vector2? position}) {
    final ateroid = AsteroidComponent(
      level: level,
      size: Vector2(128, 128),
      gameSize: size,
      colorScheme: colorScheme,
    );
    if (position != null) {
      ateroid.position = position;
    }

    asteroids.add(ateroid);
    add(ateroid);
  }

  /// Creates asteroids for the level
  void _addAsteroids() async {
    for (int i = 0; i < level.value + 1; i++) {
      _addAteroid();
    }
  }

  ///
  /// HANDLE PLAYER MOVEMENT
  ///

  /// Moves the player according to screen taps
  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);

    if (hardMode.value) return;
    if (info.eventPosition.game.x < size.x / 2) {
      player.jumpLeft();
    } else {
      player.jumpRight();
    }
  }

  /// Moves the player according to keyboard clicks
  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is RawKeyDownEvent) {
      if (hardMode.value) return KeyEventResult.handled;
      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        player.jumpLeft();
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        player.jumpRight();
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  /// Moves the player according to gyroscope events
  void _listenToGyroscope() {
    gyroscopeEvents.listen((GyroscopeEvent event) {
      if (event.z > 2) {
        player.jumpLeft();
      } else if (event.z < -2) {
        player.jumpRight();
      }
    });
  }

  ///
  /// BACKGROUND AND OVERLAYS
  ///

  /// Bacground displaying level and other information
  Widget background() {
    return ValueListenableBuilder<int>(
      valueListenable: level,
      builder: (_, levelVal, __) {
        // Those two builders look bad
        // but at the moment I have no better idea
        return ValueListenableBuilder<bool>(
          valueListenable: hardMode,
          builder: (_, hardModeVal, ___) {
            return GameBackground(
              colorScheme: colorScheme,
              level: levelVal,
              stats: stats,
              hardMode: hardModeVal,
            );
          },
        );
      },
    );
  }

  /// Overlay with buttons to pause and toggle hardmode
  Widget mainOverlay() {
    // Those two builders look bad
    // but at the moment I have no better idea
    return ValueListenableBuilder<int>(
      valueListenable: level,
      builder: (_, __, ___) {
        return ValueListenableBuilder<bool>(
          valueListenable: hardMode,
          builder: (_, hardModeVal, __) {
            return MainOverlay(
              colorScheme: colorScheme,
              hardMode: hardModeVal,
              onHardModePressed: () {
                hardMode.value = !hardMode.value;
                level.value = 1;
              },
              onPausePressed: () {
                pauseEngine();
                overlays.add('pause_overlay');
              },
            );
          },
        );
      },
    );
  }

  /// Pauses the game and shows pause overlay
  Widget pauseOverlay() {
    return PauseOverlay(
      colorScheme: colorScheme,
      stats: stats,
      onPressed: () {
        overlays.remove('pause_overlay');
        resumeEngine();
      },
    );
  }
}
