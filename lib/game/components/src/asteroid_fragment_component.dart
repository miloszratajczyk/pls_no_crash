import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

import 'random_hitbox_polygon.dart';

class AsteroidFragmentComponent extends ShapeComponent {
  AsteroidFragmentComponent({
    required Vector2 size,
    required Paint newpaint,
  }) : super(
          randomHitboxPolygon(),
          size: size / 4,
          anchor: Anchor.center,
        ) {
    final rng = Random();

    gravity = Vector2(0, rng.nextInt(25).toDouble() + 10);

    angleVelocity = rng.nextDouble() * 2;
    if (rng.nextBool()) angleVelocity *= -1;

    paint = newpaint;
  }
  Vector2 velocity = Vector2.zero();
  Vector2 gravity = Vector2.zero();
  double angleVelocity = 0;

  @override
  void update(double dt) {
    super.update(dt);

    // Update movement
    position += velocity * dt - gravity * dt * dt / 2;
    velocity += gravity * dt;
    angle += angleVelocity * dt;
  }
}
