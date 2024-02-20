import 'dart:math';

import 'package:carbozzo/pages/Game/game.dart';
import 'package:flame/components.dart';

class Enemy extends SpriteComponent with HasGameReference<CarboQuest> {
  double _speed = 600;
  Vector2 moveDirection = Vector2(0, 1);

  Enemy({
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
  }) : super(sprite: sprite, position: position, size: size) {
    angle = pi;
  }

  @override
  void update(double dt) {
    super.update(dt);

    position += moveDirection * _speed * dt;

    // If the enemy leaves the screen, destroy it.
    if (position.y > game.fixedResolution.y) {
      removeFromParent();
    } else if ((position.x < size.x / 2) ||
        (position.x > (game.fixedResolution.x - size.x / 2))) {
      // Enemy is going outside vertical screen bounds, flip its x direction.
      moveDirection.x *= -1;
    }
  }
}
