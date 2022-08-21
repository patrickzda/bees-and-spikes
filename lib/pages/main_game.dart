import 'package:dodge_the_spikes/game_objects/bee.dart';
import 'package:dodge_the_spikes/game_objects/enemy.dart';
import 'package:dodge_the_spikes/level.dart';
import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef VoidCallback = void Function();

class MainGame extends FlameGame with KeyboardEvents{

  late Bee bee;
  List<Enemy> enemies = [];
  Level level;
  late List<Sprite> explosionFrames;
  void Function() onGameOver, onGameWon;

  MainGame({required this.level, required this.onGameOver, required this.onGameWon});

  @override
  Color backgroundColor() {
    return Colors.white;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    explosionFrames = [
      await Sprite.load("explosion_1.png"),
      await Sprite.load("explosion_2.png"),
      await Sprite.load("explosion_3.png"),
      await Sprite.load("explosion_4.png"),
      await Sprite.load("explosion_5.png"),
      await Sprite.load("explosion_6.png"),
      await Sprite.load("explosion_7.png"),
      await Sprite.load("explosion_8.png"),
      await Sprite.load("explosion_9.png"),
      await Sprite.load("explosion_10.png")
    ];
    Sprite tileSprite = await Sprite.load("board_tile.png");
    Sprite addOneSprite = await Sprite.load("add_one.png");
    Sprite subtractOneSprite = await Sprite.load("subtract_one.png");
    Sprite addTwoSprite = await Sprite.load("add_two.png");
    Sprite subtractTwoSprite = await Sprite.load("subtract_two.png");
    Sprite enemySprite = await Sprite.load("enemy.png");
    Vector2 scale = Vector2((size[0] / level.data.length) / 21, (size[0] / level.data.length) / 21);
    for(int i = 0; i<level.data.length; i++){
      for(int j = 0; j<level.data.length; j++){
        if(level.data[j][i] == "-1"){
          add(SpriteComponent(
            sprite: subtractOneSprite,
            position: Vector2(((size[0] / level.data.length)) * i, ((size[0] / level.data.length)) * j),
            scale: scale
          ));
        }else if(level.data[j][i] == "+1"){
          add(SpriteComponent(
              sprite: addOneSprite,
              position: Vector2(((size[0] / level.data.length)) * i, ((size[0] / level.data.length)) * j),
              scale: scale
          ));
        }else if(level.data[j][i] == "-2"){
          add(SpriteComponent(
            sprite: subtractTwoSprite,
            position: Vector2(((size[0] / level.data.length)) * i, ((size[0] / level.data.length)) * j),
            scale: scale
          ));
        }else if(level.data[j][i] == "+2"){
          add(SpriteComponent(
            sprite: addTwoSprite,
            position: Vector2(((size[0] / level.data.length)) * i, ((size[0] / level.data.length)) * j),
            scale: scale
          ));
        }else if(level.data[j][i] != "W"){
          add(SpriteComponent(
            sprite: tileSprite,
            position: Vector2(((size[0] / level.data.length)) * i, ((size[0] / level.data.length)) * j),
            scale: scale
          ));
        }
      }
    }
    add(SpriteComponent(
      sprite: await Sprite.load("flower.png"),
      scale: scale,
      anchor: Anchor.center,
      position: indicesToPosition(level.flowerIndices, scale)
    ));
    for(int i = 0; i<level.leftEnemyIndices.length; i++){
      Enemy enemy = Enemy(
        size: size,
        unit: ((size[0] / level.data.length)),
        startDirection: Direction.left,
        wallIndices: List.from(level.wallIndices)..add(level.flowerIndices),
        enemyIndices: level.leftEnemyIndices[i].clone(),
        spriteComponent: SpriteComponent(
          sprite: enemySprite,
          scale: scale,
          anchor: Anchor.center,
          position: indicesToPosition(level.leftEnemyIndices[i], scale)
        )
      );
      enemies.add(enemy);
      add(enemy.spriteComponent);
    }
    for(int i = 0; i<level.rightEnemyIndices.length; i++){
      Enemy enemy = Enemy(
        size: size,
        unit: ((size[0] / level.data.length)),
        startDirection: Direction.right,
        wallIndices: List.from(level.wallIndices)..add(level.flowerIndices),
        enemyIndices: level.rightEnemyIndices[i].clone(),
        spriteComponent: SpriteComponent(
          sprite: enemySprite,
          scale: scale,
          anchor: Anchor.center,
          position: indicesToPosition(level.rightEnemyIndices[i], scale)
        )
      );
      enemies.add(enemy);
      add(enemy.spriteComponent);
    }
    for(int i = 0; i<level.upEnemyIndices.length; i++){
      Enemy enemy = Enemy(
        size: size,
        unit: ((size[0] / level.data.length)),
        startDirection: Direction.up,
        wallIndices: List.from(level.wallIndices)..add(level.flowerIndices),
        enemyIndices: level.upEnemyIndices[i].clone(),
        spriteComponent: SpriteComponent(
          sprite: enemySprite,
          scale: scale,
          anchor: Anchor.center,
          position: indicesToPosition(level.upEnemyIndices[i], scale)
        )
      );
      enemies.add(enemy);
      add(enemy.spriteComponent);
    }
    for(int i = 0; i<level.downEnemyIndices.length; i++){
      Enemy enemy = Enemy(
        size: size,
        unit: ((size[0] / level.data.length)),
        startDirection: Direction.down,
        wallIndices: List.from(level.wallIndices)..add(level.flowerIndices),
        enemyIndices: level.downEnemyIndices[i].clone(),
        spriteComponent: SpriteComponent(
          sprite: enemySprite,
          scale: scale,
          anchor: Anchor.center,
          position: indicesToPosition(level.downEnemyIndices[i], scale)
        )
      );
      enemies.add(enemy);
      add(enemy.spriteComponent);
    }
    bee = Bee(
      onGameOver: (Enemy enemy){
        remove(enemy.spriteComponent);
        gameOver();
      },
      enemies: enemies,
      unit: ((size[0] / level.data.length)),
      size: size,
      beeIndices: level.startBeeIndices.clone(),
      wallIndices: level.wallIndices,
      addOneIndices: level.addOneIndices,
      spriteComponent: SpriteAnimationComponent(
        animation: SpriteAnimation.spriteList(
          [await Sprite.load("bee.png"), await Sprite.load("bee_2.png")],
          stepTime: 0.25
        ),
        size: Vector2.all(21),
        scale: scale,
        anchor: Anchor.center,
        position: indicesToPosition(level.startBeeIndices, scale)
      )
    );
    add(bee.spriteComponent);
  }


  @override
  void update(double dt) {
    super.update(dt);
    bee.update(dt);
    for(int i = 0; i<enemies.length; i++){
      enemies[i].update(dt);
    }
  }

  @override
  KeyEventResult onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if(event is RawKeyDownEvent && keysPressed.contains(LogicalKeyboardKey.arrowUp) && !event.repeat){
      bee.move(Direction.up);
      checkWin();
      return KeyEventResult.handled;
    }else if(event is RawKeyDownEvent && keysPressed.contains(LogicalKeyboardKey.arrowRight) && !event.repeat){
      bee.move(Direction.right);
      checkWin();
      return KeyEventResult.handled;
    }else if(event is RawKeyDownEvent && keysPressed.contains(LogicalKeyboardKey.arrowDown) && !event.repeat){
      bee.move(Direction.down);
      checkWin();
      return KeyEventResult.handled;
    }else if(event is RawKeyDownEvent && keysPressed.contains(LogicalKeyboardKey.arrowLeft) && !event.repeat){
      bee.move(Direction.left);
      checkWin();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void checkWin(){
    if(bee.beeIndices == level.flowerIndices){
      FlameAudio.bgm.pause();
      FlameAudio.play("win.wav").then((_){
        FlameAudio.bgm.resume();
      });
      onGameWon();
    }
  }

  void gameOver(){
    FlameAudio.bgm.pause();
    FlameAudio.play("game_over.wav").then((_){
      FlameAudio.bgm.resume();
    });

    add(SpriteAnimationComponent(
      animation: SpriteAnimation.spriteList(
        explosionFrames,
        loop: false,
        stepTime: 0.035,
      ),
      anchor: Anchor.center,
      removeOnFinish: true,
      priority: 10,
      scale: Vector2((size[0] / level.data.length) / 21, (size[0] / level.data.length) / 21),
      size: Vector2.all(21),
      position: bee.spriteComponent.position
    ));
    remove(bee.spriteComponent);
    camera.shake(
      duration: 0.25,
      intensity: 15
    );
    onGameOver();
  }

  Vector2 indicesToPosition(Vector2 indices, Vector2 scale){
    return Vector2((size[0] / level.data.length) * indices.x + (21 * scale.x * 0.5), ((size[0] / level.data.length) * indices.y) + (21 * scale.y * 0.5));
  }

}