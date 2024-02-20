import 'dart:math';
import 'package:flame/sprite.dart';
import 'package:flame/components.dart';
import 'game.dart';
import 'enemy.dart';

class EnemyManager extends Component with HasGameReference<CarboQuest> {
  late Timer _timer;
  SpriteSheet spriteSheet;
  Random random = Random();

  EnemyManager({required this.spriteSheet}) : super() {
    _timer = Timer(0.8, onTick: _spawnEnemy, repeat: true);
  }

  void _spawnEnemy() {
    Vector2 initialSize = Vector2(64, 64);

    // Spawn from left side
    Vector2 leftPosition = Vector2(-120, -450);
    // Spawn from right side
    Vector2 rightPosition = Vector2(120, -450);

    if (game.buildContext != null) {
      Enemy leftEnemy = Enemy(
        sprite: spriteSheet.getSpriteById(3),
        size: initialSize,
        position: leftPosition,
      );

      leftEnemy.anchor = Anchor.center;
      game.world.add(leftEnemy);

      Enemy rightEnemy = Enemy(
        sprite: spriteSheet.getSpriteById(3),
        size: initialSize,
        position: rightPosition,
      );

      rightEnemy.anchor = Anchor.center;
      game.world.add(rightEnemy);
    }
  }

  int mapScoreToMaxEnemyLevel(int score) {
    int level = 1;

    if (score > 1500) {
      level = 4;
    } else if (score > 500) {
      level = 3;
    } else if (score > 100) {
      level = 2;
    }

    return level;
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void onRemove() {
    super.onRemove();
    _timer.stop();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer.update(dt);
  }

  void reset() {
    _timer.stop();
    _timer.start();
  }
}
