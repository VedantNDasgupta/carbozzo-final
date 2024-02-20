import 'dart:async';
import 'package:carbozzo/pages/Game/enemy_manager.dart';
import 'package:carbozzo/pages/Game/player.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class CarboQuest extends FlameGame with HorizontalDragDetector {
  late Player player;
  Offset? _pointerStartPosition;
  Vector2 fixedResolution = Vector2(400, 960);

  @override
  FutureOr<void> onLoad() async {
    await images.load('robot.png');

    final spriteSheet = SpriteSheet.fromColumnsAndRows(
        image: images.fromCache('robot.png'), columns: 9, rows: 5);

    player = Player(
      sprite: spriteSheet.getSpriteById(9),
      size: Vector2(80, 90),
      position: size / 2,
    );

    player.anchor = Anchor.center;

    add(player);

    EnemyManager enemyManager = EnemyManager(spriteSheet: spriteSheet);
    add(enemyManager);
  }

  @override
  void onHorizontalDragStart(DragStartInfo info) {
    _pointerStartPosition = info.raw.globalPosition;
  }

  @override
  void onHorizontalDragUpdate(DragUpdateInfo info) {
    final pointerCurrentPosition = info.raw.globalPosition;

    var delta = pointerCurrentPosition.dx - _pointerStartPosition!.dx;
    player.setMoveDirection(Vector2(delta, 0));
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
}
