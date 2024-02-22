import 'dart:math';

import 'package:carbozzo/pages/Game/game.dart';
import 'package:carbozzo/pages/Game/player.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Enemy extends SpriteComponent
    with CollisionCallbacks, HasGameReference<CarboQuest> {
  double _speed = 300;
  Vector2 moveDirection = Vector2(0, 1);

  Enemy({
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
  }) : super(sprite: sprite, position: position, size: size) {
    angle = pi;
  }

  @override
  void onMount() {
    super.onMount();
    final shape = CircleHitbox.relative(
      0.8,
      parentSize: size,
      position: size / 2,
      anchor: Anchor.center,
    );
    add(shape);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Player) {
      // If the other Collidable is Player, destroy.
      removeFromParent(); // Remove the current instance
    }
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

class EnemyType1 extends Enemy {
  EnemyType1({
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
  }) : super(sprite: sprite, position: position, size: size);

  // Add any specific properties or methods for this enemy type
}

class EnemyType2 extends Enemy {
  EnemyType2({
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
  }) : super(sprite: sprite, position: position, size: size);

  // Add any specific properties or methods for this enemy type
}
