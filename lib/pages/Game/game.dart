import 'dart:async';
import 'package:carbozzo/pages/Game/enemy_manager.dart';
import 'package:carbozzo/pages/Game/player.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class CarboQuest extends FlameGame
    with HorizontalDragDetector, HasCollisionDetection {
  late Player player;
  Offset? _pointerStartPosition;
  Vector2 fixedResolution = Vector2(400, 1060);
  late TextComponent _playerScore;
  late TextComponent _playerHealth;

  @override
  FutureOr<void> onLoad() async {
    await images.load('robot1.png');

    final spriteSheet = SpriteSheet.fromColumnsAndRows(
        image: images.fromCache('robot1.png'), columns: 9, rows: 5);

    player = Player(
      sprite: spriteSheet.getSpriteById(1),
      size: Vector2(80, 90),
      position: size / 2,
    );

    player.anchor = Anchor.center;

    add(player);

    EnemyManager enemyManager = EnemyManager(spriteSheet: spriteSheet);
    add(enemyManager);

    _playerScore = TextComponent(
      text: 'Score: 0',
      position: Vector2(30, 30),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontFamily: 'BungeeInline',
        ),
      ),
    );

    //text component for player health.
    _playerHealth = TextComponent(
      text: 'Health: 100%',
      position: Vector2(fixedResolution.x - 30, 30),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontFamily: 'BungeeInline',
        ),
      ),
    );

    // Anchor to top right as we want the top right
    // corner of this component to be at a specific position.
    add(_playerHealth);
    _playerHealth.anchor = Anchor.topRight;
    add(_playerScore);
  }

  @override
  void onHorizontalDragStart(DragStartInfo info) {
    _pointerStartPosition = info.raw.globalPosition;
  }

  @override
  void onHorizontalDragUpdate(DragUpdateInfo info) {
    final pointerCurrentPosition = info.raw.globalPosition;

    // Check if the finger has moved
    if (pointerCurrentPosition != _pointerStartPosition) {
      var delta = pointerCurrentPosition.dx - _pointerStartPosition!.dx;
      player.setMoveDirection(Vector2(delta, 0));
    } else {
      player.setMoveDirection(Vector2.zero());
    }
  }

  @override
  void onHorizontalDragEnd(DragEndInfo info) {
    _pointerStartPosition = null;
    player.setMoveDirection(Vector2.zero());
  }

  @override
  void onHorizontalDragCancel() {
    _pointerStartPosition = null;
    player.setMoveDirection(Vector2.zero());
  }

  @override
  void update(double dt) {
    super.update(dt);

    _playerScore.text = 'Score: ${player.score}';
    _playerHealth.text = 'Health: ${player.health}%';
  }
}
