import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

/// Generates a random polygon that is the shape of the asteroid
HitboxPolygon randomHitboxPolygon() {
  var rng = Random();
  return HitboxPolygon([
    _randSqr(x: 0.0, y: 0.0),
    if (rng.nextBool()) _randLine(y: 0.0),
    _randSqr(x: 0.5, y: 0.0),
    if (rng.nextBool()) _randLine(x: 0.5),
    _randSqr(x: 0.5, y: 0.5),
    if (rng.nextBool()) _randLine(y: 0.5),
    _randSqr(x: 0.0, y: 0.5),
    if (rng.nextBool()) _randLine(x: 0.0),
  ]);
}

// Returns a random point in a square
Vector2 _randSqr({required double x, required double y}) {
  final double xRand = Random().nextDouble() / 2;
  final double yRand = Random().nextDouble() / 2;
  return Vector2(xRand + x, yRand + y);
}

// Returns random point on a line
Vector2 _randLine({double? x, double? y}) {
  final double rand = Random().nextDouble() / 2;
  if (x == null && y != null) {
    return Vector2(0.5, rand + y);
  } else if (x != null && y == null) {
    return Vector2(rand + x, 0.5);
  } else {
    return Vector2.zero();
  }
}
