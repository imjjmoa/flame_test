import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    GameWidget(
      game: MyGame(),
    ),
  );
}

/// This example simply adds a rotating white square on the screen.
/// If you press on a square, it will be removed.
/// If you press anywhere else, another square will be added.
class MyGame extends FlameGame with HasTappables {
  StreamController streamController = StreamController();
  late Component component;

  @override
  Future<void> onLoad() async {
    component = Square(Vector2(100, 200), streamController);
    add(component);
  }


  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    // TODO: implement onTapUp
    super.onTapUp(pointerId, info);
    streamController.add(1);
  }
}

class Square extends PositionComponent with Tappable {
  static const speed = 0.25;
  static const squareSize = 128.0;

  static Paint white = BasicPalette.white.paint();
  static Paint red = BasicPalette.red.paint();
  static Paint blue = BasicPalette.blue.paint();

  double spd = 10;
  double gravity = 14.8;

  StreamController streamController;

  Square(Vector2 position, this.streamController) : super(position: position);

  @override
  void render(Canvas c) {
    c.drawRect(size.toRect(), white);
    c.drawRect(const Rect.fromLTWH(0, 0, 3, 3), red);
    c.drawRect(Rect.fromLTWH(width / 2, height / 2, 3, 3), blue);
  }

  @override
  void update(double dt) {
    super.update(dt);
    transform.offset.y += spd * dt;
    spd += gravity;

    if(transform.offset.y >= 0) {
      transform.offset.y = 0;
      spd = 0;
    }
    // angle += speed * dt;
    // angle %= 2 * math.pi;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size.setValues(squareSize, squareSize);
    anchor = Anchor.center;

    streamController.stream.listen((event) {
      spd = -400;
    });
  }

  @override
  bool onTapUp(TapUpInfo info) {
    // removeFromParent();
    // info.handled = true;
    return true;
  }

}