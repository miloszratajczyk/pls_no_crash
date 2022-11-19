import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'asteroid_fragment_component.dart';
import 'random_hitbox_polygon.dart';

class AsteroidComponent extends ShapeComponent with Collidable, HasGameRef {
  AsteroidComponent({
    required Vector2 size,
    required Vector2 gameSize,
    required this.level,
    required this.colorScheme,
  }) : super(
          randomHitboxPolygon(),
          size: size,
          anchor: Anchor.center,
        ) {
    final rng = Random();
    position = _getRandomPosition(gameSize);
    gravity = Vector2(0, rng.nextInt(25).toDouble() + 10);
    if (rng.nextBool()) {
      angleVelocity = rng.nextDouble() * 2;
    } else {
      angleVelocity = -rng.nextDouble() * 2;
    }

    paint = Paint()
      ..color = colorScheme.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
  }

  Vector2 velocity = Vector2.zero();
  Vector2 gravity = Vector2.zero();
  ValueNotifier<int> level;
  ColorScheme colorScheme;
  double angleVelocity = 0;

  @override
  void update(double dt) {
    super.update(dt);

    // Update movement
    position += velocity * dt - gravity * dt * dt / 2;
    velocity += gravity * dt;
    angle += angleVelocity * dt;
  }

  // Picks a random position to spawn the asteroid
  Vector2 _getRandomPosition(Vector2 gameSize) {
    var rng = Random();
    final double xRand = rng.nextDouble() * (gameSize.x - 64) + 32;
    final double yRand = -64 * (level.value + rng.nextDouble());
    return Vector2(xRand, yRand);
  }

  /// Creates from 16 to 32 AstroidFragments
  /// gives them a random velocity from -128 to 128 plus player velocity
  explode(
      {required Vector2 givenPosition, required Vector2 givenVelocity}) async {
    removeFromParent();

    final rng = Random();
    final fragmentsNumber = rng.nextInt(16) + 16;
    for (int i = 0; i < fragmentsNumber; i++) {
      final velocityRand =
          Vector2(rng.nextDouble() * 256 - 128, rng.nextDouble() * 256 - 128) +
              givenVelocity;
      final fragment = AsteroidFragmentComponent(size: size, newpaint: paint)
        ..position = givenPosition
        ..velocity += velocityRand;

      gameRef.add(fragment);
    }
  }
}
