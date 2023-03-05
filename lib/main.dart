import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

class Background extends ParallaxComponent<MyGame> {
  static const _imageName = 'road.png';
  static final _baseVelocity = Vector2(0, -300);

  @override
  Future<void> onLoad() async {
    final image = await gameRef.loadParallaxImage(
      _imageName,
      repeat: ImageRepeat.repeat,
      alignment: Alignment.center,
      fill: LayerFill.width,
    );
    parallax = Parallax([ParallaxLayer(image)], baseVelocity: _baseVelocity);
  }
}

class Racer extends SpriteComponent {
  static const _spriteName = 'racer.png';
  static const _speed = 1.5;

  Racer() : super(size: Vector2(44, 100));

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(_spriteName);
  }

  move(double newX) {
    final x = center.x;
    final y = center.y;
    if ((newX - x).abs() < _speed) {
      return;
    }
    center = Vector2(newX > x ? x + _speed : x - _speed, y);
  }
}

class MyGame extends FlameGame with HasDraggableComponents {
  final _background = Background();
  final _racer = Racer();

  bool _isPlayerDragging = false;
  double? _fingerPosition;

  @override
  void onLoad() {
    add(_background);
    _racer.center = Vector2(size.x / 2, size.y - 150);
    add(_racer);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_isPlayerDragging) {
      _racer.move(_fingerPosition!);
    }
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    _isPlayerDragging = true;
    _fingerPosition = event.canvasPosition.x;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    _fingerPosition = event.canvasPosition.x;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _isPlayerDragging = false;
    _fingerPosition = null;
  }
}

void main() {
  final game = MyGame();
  runApp(GameWidget(game: game));
}
