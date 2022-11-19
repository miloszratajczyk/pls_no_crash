import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';

import 'asteroid_component.dart';

class PlayerComponent extends PositionComponent
    with HasGameRef, HasHitboxes, Collidable {
  PlayerComponent({required this.onExplosion}) {
    width = 10;
    height = 10;
  }
  final Paint paint = Paint()..color = Colors.white;
  Vector2 velocity = Vector2.zero();
  final Vector2 gravity = Vector2(0, 200);
  final Function() onExplosion;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(const Offset(5, 5), 5, paint);
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    anchor = Anchor.center;
    position = gameRef.size / 2;
    addHitbox(HitboxCircle());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is AsteroidComponent) {
      // Collision with an Asteroid
      other.explode(givenPosition: position, givenVelocity: velocity * 0.5);
      velocity *= -0.5;
      onExplosion();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Handle velocity
    position += velocity * dt - gravity * dt * dt / 2;
    velocity += gravity * dt;

    // Top border
    if (position.y < 0) {
      velocity.y *= -1;
      position.y = 3;
    }
    // Left border
    else if (position.x < 0) {
      velocity.x *= -1;
      position.x = 3;
    }
    // Right border
    else if (position.x > gameRef.size.x) {
      velocity.x *= -1;
      position.x = gameRef.size.x - 3;
    }
    // Bottom border
    else if (position.y > gameRef.size.y) {
      velocity.y *= -0.64;
      position.y = gameRef.size.y - 3;
    }
  }

  /// Updates velocity to jump left
  jumpLeft() {
    if (velocity.y > -200) velocity = Vector2(-64, -256);
  }

  /// Updates velocity to jump right
  jumpRight() {
    if (velocity.y > -200) velocity = Vector2(64, -256);
  }
}
