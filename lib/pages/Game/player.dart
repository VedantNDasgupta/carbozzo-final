import 'package:carbozzo/pages/Game/game.dart';

import 'package:flame/components.dart';

class Player extends SpriteComponent with HasGameReference<CarboQuest> {
  Vector2 _moveDirection = Vector2.zero();

  double _speed = 350;

  Player({
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
  }) : super(sprite: sprite, position: position, size: size);

  @override
  void update(double dt) {
    super.update(dt);
    position.clamp(
      Vector2.zero(),
      game.fixedResolution,
    );

    this.position += _moveDirection.normalized() * _speed * dt;
  }

  void setMoveDirection(Vector2 newMoveDirection) {
    _moveDirection = newMoveDirection;
  }

  void addEventCallback(Null Function(dynamic event) param0) {}

  void moveBy(delta) {}
}
