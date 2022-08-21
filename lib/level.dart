import 'package:flame/components.dart';

class Level{

  //Codes: B = Bee, F = Flower, E = Empty, Left / Right / Up / Down - starting Enemies: {L, R, U, D}, W = Wall, Number-Plates: {-2, -1, 1, 2}

  List<List<String>> data;
  late Vector2 startBeeIndices, flowerIndices;
  List<Vector2> wallIndices = [], addOneIndices = [], subtractOneIndices = [], addTwoIndices = [], subtractTwoIndices = [];
  List<Vector2> leftEnemyIndices = [], rightEnemyIndices = [], upEnemyIndices = [], downEnemyIndices = [];

  Level({required this.data}){
    for(int i = 0; i<data.length; i++){
      for(int j = 0; j<data.length; j++){
        if(data[i][j] == "B"){
          startBeeIndices = Vector2(j.toDouble(), i.toDouble());
        }else if(data[i][j] == "F"){
          flowerIndices = Vector2(j.toDouble(), i.toDouble());
        }else if(data[i][j] == "W"){
          wallIndices.add(Vector2(j.toDouble(), i.toDouble()));
        }else if(data[i][j] == "+1"){
          addOneIndices.add(Vector2(j.toDouble(), i.toDouble()));
        }else if(data[i][j] == "-1"){
          subtractOneIndices.add(Vector2(j.toDouble(), i.toDouble()));
        }else if(data[i][j] == "+2"){
          addTwoIndices.add(Vector2(j.toDouble(), i.toDouble()));
        }else if(data[i][j] == "-2"){
          subtractTwoIndices.add(Vector2(j.toDouble(), i.toDouble()));
        }else if(data[i][j] == "L"){
          leftEnemyIndices.add(Vector2(j.toDouble(), i.toDouble()));
        }else if(data[i][j] == "R"){
          rightEnemyIndices.add(Vector2(j.toDouble(), i.toDouble()));
        }else if(data[i][j] == "U"){
          upEnemyIndices.add(Vector2(j.toDouble(), i.toDouble()));
        }else if(data[i][j] == "D"){
          downEnemyIndices.add(Vector2(j.toDouble(), i.toDouble()));
        }
      }
    }
  }

}