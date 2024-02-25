import 'dart:math';

import 'package:carbozzo/pages/Game/player.dart';
import 'package:flame/collisions.dart';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'game.dart';

class Enemy extends SpriteComponent
    with CollisionCallbacks, HasGameReference<CarboQuest> {
  double _speed = 250;

  Vector2 moveDirection = Vector2(0, 1);
  final _random = Random();
  int _hitPoints = 10;
  final _hpText = TextComponent(
    text: '10 HP',
    textRenderer: TextPaint(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontFamily: 'BungeeInline',
      ),
    ),
  );

  Vector2 getRandomVector() {
    return (Vector2.random(_random) - Vector2.random(_random)) * 500;
  }

  // Returns a random direction vector with slight angle to +ve y axis.
  Vector2 getRandomDirection() {
    return (Vector2.random(_random) - Vector2(0.5, -1)).normalized();
  }

  Enemy({
    required Sprite? sprite,
    required Vector2? position,
    required Vector2? size,
  }) : super(sprite: sprite, position: position, size: size) {
    angle = pi;
    _hpText.text = '$_hitPoints HP';
  }

  @override
  void onMount() {
    super.onMount();
    final shape = RectangleHitbox(
      size: Vector2(10, 10),
    );
    add(shape);
    _hpText.angle = pi;
    _hpText.position = Vector2(50, 80);
    add(_hpText);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player) {
      // If the colliding entity is a Player, remove the enemy from the game.
      removeFromParent();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Sync-up text component and value of hitPoints.
    _hpText.text = '$_hitPoints HP';

    // Update the position of this enemy using its speed and delta time.
    position += moveDirection * _speed * dt;
  }
}
