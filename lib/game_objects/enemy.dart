import 'package:flame/components.dart';
import 'bee.dart';

class Enemy{

  SpriteComponent spriteComponent;
  Direction startDirection;
  late Direction currentDirection;
  Vector2 enemyIndices, size, targetPosition = Vector2(0, 0);
  List<Vector2> wallIndices;
  final double pi = 3.1415926535897932;
  final double speed = 500;
  bool moving = false;
  double unit;
  int moveCounter = 0;

  Enemy({required this.spriteComponent, required this.startDirection, required this.enemyIndices, required this.wallIndices, required this.unit, required this.size}){
    currentDirection = startDirection;
    if(startDirection == Direction.up){
      spriteComponent.angle = pi / 2;
    }else if(startDirection == Direction.down){
      spriteComponent.angle = - pi / 2;
    }else if(startDirection == Direction.right){
      spriteComponent.angle = pi;
    }
  }

  void move(int count){
    moveCounter = count;
    if(_canMove()){
      moving = true;
    }else{
      if(currentDirection == Direction.up){
        currentDirection = Direction.down;
        spriteComponent.angle = - pi / 2;
      }else if(currentDirection == Direction.down){
        currentDirection = Direction.up;
        spriteComponent.angle = pi / 2;
      }else if(currentDirection == Direction.left){
        currentDirection = Direction.right;
        spriteComponent.angle = pi;
      }else if(currentDirection == Direction.right){
        currentDirection = Direction.left;
        spriteComponent.angle = 0;
      }
      moveCounter--;
      if(moveCounter > 0){
        move(moveCounter);
      }
    }
  }

  bool _canMove(){
    if(currentDirection == Direction.up && !wallIndices.contains(Vector2(enemyIndices.x, enemyIndices.y - 1)) && (spriteComponent.y - unit) > 0){
      enemyIndices = Vector2(enemyIndices.x, enemyIndices.y - 1);
      targetPosition = Vector2(spriteComponent.x, spriteComponent.y - unit);
      return true;
    }else if(currentDirection == Direction.down && !wallIndices.contains(Vector2(enemyIndices.x, enemyIndices.y + 1)) && (spriteComponent.y + unit) < size[1]){
      enemyIndices = Vector2(enemyIndices.x, enemyIndices.y + 1);
      targetPosition = Vector2(spriteComponent.x, spriteComponent.y + unit);
      return true;
    }else if(currentDirection == Direction.left && !wallIndices.contains(Vector2(enemyIndices.x - 1, enemyIndices.y)) && (spriteComponent.x - unit) > 0){
      enemyIndices = Vector2(enemyIndices.x - 1, enemyIndices.y);
      targetPosition = Vector2(spriteComponent.x - unit, spriteComponent.y);
      return true;
    }else if(currentDirection == Direction.right && !wallIndices.contains(Vector2(enemyIndices.x + 1, enemyIndices.y)) && (spriteComponent.x + unit) < size[0]){
      enemyIndices = Vector2(enemyIndices.x + 1, enemyIndices.y);
      targetPosition = Vector2(spriteComponent.x + unit, spriteComponent.y);
      return true;
    }
    return false;
  }

  void update(double dt){
    if(moving && (spriteComponent.position - targetPosition).length > 5){
      if(currentDirection == Direction.up){
        spriteComponent.position = spriteComponent.position - Vector2(0, speed) * dt;
      }else if(currentDirection == Direction.down){
        spriteComponent.position = spriteComponent.position + Vector2(0, speed) * dt;
      }else if(currentDirection == Direction.left){
        spriteComponent.position = spriteComponent.position - Vector2(speed, 0) * dt;
      }else if(currentDirection == Direction.right){
        spriteComponent.position = spriteComponent.position + Vector2(speed, 0) * dt;
      }
    }else if(moving){
      moveCounter--;
      if(moveCounter > 0){
        move(moveCounter);
      }else{
        moving = false;
      }
    }
  }

}