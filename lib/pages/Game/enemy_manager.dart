import 'dart:math';
import 'package:flame/sprite.dart';
import 'package:flame/components.dart';
import 'game.dart';
import 'enemy.dart';

class EnemyManager extends Component with HasGameReference<CarboQuest> {
  late Timer _timer;
  SpriteSheet spriteSheet;
  Random random = Random();
  double elapsedTime = 0.0; // Variable to track elapsed time

  EnemyManager({required this.spriteSheet}) : super() {
    _timer = Timer(1.5, onTick: _spawnEnemy, repeat: true);
  }

  void _spawnEnemy() {
    Vector2 initialSize = Vector2(64, 64);
    double minX = -150;
    double maxX = 150;

    if (game.buildContext != null) {
      double randomX1 = minX + random.nextDouble() * (maxX - minX);

      // Randomly choose between two enemy types
      int enemyType = random.nextInt(2) + 1;

      Enemy enemy;
      Sprite sprite = spriteSheet.getSpriteById(enemyType);

      if (enemyType == 1) {
        enemy = EnemyType1(
          sprite: sprite,
          size: initialSize,
          position: Vector2(randomX1, -450),
        );
      } else {
        enemy = EnemyType2(
          sprite: sprite,
          size: initialSize,
          position: Vector2(randomX1, -450),
        );
      }

      enemy.anchor = Anchor.center;
      game.world.add(enemy);
    }
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

    // Update elapsed time
    elapsedTime += dt;

    // Check if 10 seconds have elapsed, and update timer duration
    if (elapsedTime >= 30 && _timer.limit > 0.8) {
      _timer.limit -= 0.1;
      elapsedTime -= 10; // Reset elapsed time
    }

    _timer.update(dt);
  }

  void reset() {
    _timer.stop();
    _timer.start();
  }
}
