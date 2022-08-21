import 'package:dodge_the_spikes/game_objects/enemy.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'dart:math';

enum Direction{
  up,
  down,
  left,
  right
}

typedef VoidCallback = void Function();

class Bee{

  SpriteAnimationComponent spriteComponent;
  Vector2 size, beeIndices;
  List<Vector2> wallIndices, addOneIndices;
  List<Enemy> enemies;
  double unit;
  void Function(Enemy) onGameOver;
  bool gameOver = false;

  final double speed = 500;
  final double pi = 3.1415926535897932;
  bool moving = false, movementBlocked = false;
  Direction moveDirection = Direction.up;
  Vector2 targetPosition = Vector2(0, 0);

  Bee({required this.onGameOver, required this.spriteComponent, required this.unit, required this.size, required this.beeIndices, required this.wallIndices, required this.enemies, required this.addOneIndices});

  void move(Direction direction){
    if(!moving && !movementBlocked){
      moveDirection = direction;
      if(direction == Direction.up && (spriteComponent.y - unit) > 0 && !wallIndices.contains(Vector2(beeIndices.x, beeIndices.y - 1))){
        targetPosition = Vector2(spriteComponent.x, spriteComponent.y - unit);
        moving = true;
        beeIndices = Vector2(beeIndices.x, beeIndices.y - 1);
        spriteComponent.angle = 0;
      }else if(direction == Direction.down && (spriteComponent.y + unit) < size[1] && !wallIndices.contains(Vector2(beeIndices.x, beeIndices.y + 1))){
        targetPosition = Vector2(spriteComponent.x, spriteComponent.y + unit);
        moving = true;
        beeIndices = Vector2(beeIndices.x, beeIndices.y + 1);
        spriteComponent.angle = pi;
      }else if(direction == Direction.left && (spriteComponent.x - unit) > 0 && !wallIndices.contains(Vector2(beeIndices.x - 1, beeIndices.y))){
        targetPosition = Vector2(spriteComponent.x - unit, spriteComponent.y);
        moving = true;
        beeIndices = Vector2(beeIndices.x - 1, beeIndices.y);
        spriteComponent.angle = - pi / 2;
      }else if(direction == Direction.right && (spriteComponent.x + unit) < size[0] && !wallIndices.contains(Vector2(beeIndices.x + 1, beeIndices.y))){
        targetPosition = Vector2(spriteComponent.x + unit, spriteComponent.y);
        moving = true;
        beeIndices = Vector2(beeIndices.x + 1, beeIndices.y);
        spriteComponent.angle = pi / 2;
      }
    }
  }

  void update(double dt){
    if(moving && (spriteComponent.position - targetPosition).length > 5){
      if(moveDirection == Direction.up){
        spriteComponent.position = spriteComponent.position - Vector2(0, speed) * dt;
      }else if(moveDirection == Direction.down){
        spriteComponent.position = spriteComponent.position + Vector2(0, speed) * dt;
      }else if(moveDirection == Direction.left){
        spriteComponent.position = spriteComponent.position - Vector2(speed, 0) * dt;
      }else if(moveDirection == Direction.right){
        spriteComponent.position = spriteComponent.position + Vector2(speed, 0) * dt;
      }
    }else if(moving){
      spriteComponent.position = targetPosition;
      moving = false;
      moveEnemies();
    }
    if(!moving && movementBlocked && !List.generate(enemies.length, (index) => enemies[index].moving).contains(true)){
      for(int i = 0; i<enemies.length; i++){
        if(enemies[i].enemyIndices == beeIndices && !gameOver){
          gameOver = true;
          onGameOver(enemies[i]);
        }
      }
      movementBlocked = false;
    }
  }

  void moveEnemies(){
    for(int i = 0; i<enemies.length; i++){
      if(enemies[i].enemyIndices == beeIndices && !gameOver){
        gameOver = true;
        onGameOver(enemies[i]);
      }
    }
    if(enemies.isNotEmpty){
      movementBlocked = true;
    }
    for(int i = 0; i<enemies.length; i++){
      if(addOneIndices.contains(beeIndices)){
        enemies[i].move(2);
      }else{
        enemies[i].move(1);
      }
      if(enemies[i].enemyIndices == beeIndices && !gameOver){
        gameOver = true;
        onGameOver(enemies[i]);
      }
    }
  }

}