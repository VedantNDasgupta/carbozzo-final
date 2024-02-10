import 'dart:async';

import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:carbozzo/levels/level.dart';
import 'package:flutter/material.dart';

class CarboQuest extends FlameGame {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late final CameraComponent cam;

  final world = Level();

  @override
  FutureOr<void> onLoad() {
    cam = CameraComponent.withFixedResolution(
        world: world, width: 640, height: 360);
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);
    return super.onLoad();
  }
}
