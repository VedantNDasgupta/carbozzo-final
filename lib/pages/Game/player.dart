import 'dart:math';

import 'package:carbozzo/pages/Game/enemy.dart';
import 'package:carbozzo/pages/Game/game.dart';
import 'package:flame/collisions.dart';

import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class Player extends SpriteComponent
    with CollisionCallbacks, HasGameReference<CarboQuest> {
  Vector2 _moveDirection = Vector2.zero();

  double _speed = 300;
  final _random = Random();
  int score = 0;
  int _health = 100;

  Vector2 getRandomVector() {
    return (Vector2.random(_random) - Vector2(0.5, -1)) * 500;
  }

  Player({
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
  }) : super(sprite: sprite, position: position, size: size);

  @override
  void onMount() {
    super.onMount();

    // Adding a circular hitbox with radius as 0.8 times
    // the smallest dimension of this components size.
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

    // If other entity is an EnemyType2
    if (other is EnemyType2) {
      // Reduce player's health by 20
      _health -= 20;

      // Ensure health doesn't go below 0
      if (_health < 0) {
        _health = 0;
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.clamp(
      Vector2.zero(),
      game.fixedResolution,
    );

    final particleComponent = ParticleSystemComponent(
      particle: Particle.generate(
        count: 10,
        lifespan: 0.1,
        generator: (i) => AcceleratedParticle(
          acceleration: getRandomVector(),
          speed: getRandomVector(),
          position: (position.clone() + Vector2(0, size.y / 3)),
          child: CircleParticle(
            radius: 1,
            paint: Paint()..color = Colors.white,
          ),
        ),
      ),
    );

    game.world.add(particleComponent);

    this.position += _moveDirection.normalized() * _speed * dt;
  }

  void setMoveDirection(Vector2 newMoveDirection) {
    _moveDirection = newMoveDirection;
  }

  void addEventCallback(Null Function(dynamic event) param0) {}

  void moveBy(delta) {}
}
