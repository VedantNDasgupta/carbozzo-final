import 'package:carbozzo/pages/Game/enemy.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'game.dart';

class Player extends SpriteComponent
    with CollisionCallbacks, HasGameReference<CarboQuest> {
  Vector2 _moveDirection = Vector2.zero();
  double _speed = 300;
  int _score = 0;
  int get score => _score;
  int _health = 0;
  int get health => _health;

  Player({
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
  }) : super(sprite: sprite, position: position, size: size) {}

  @override
  void onMount() {
    super.onMount();

    // Adding a circular hitbox with radius as 0.8 times
    // the smallest dimension of this components size.
    final shape = CircleHitbox.relative(
      8,
      parentSize: size,
      position: size / 2,
      anchor: Anchor.center,
    );
    add(shape);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Enemy) {
      _score += 10;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    this.position += _moveDirection.normalized() * _speed * dt;
  }

  void setMoveDirection(Vector2 newMoveDirection) {
    _moveDirection = newMoveDirection;
  }
}
