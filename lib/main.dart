import 'package:dodge_the_spikes/game_objects/bee.dart';
import 'package:dodge_the_spikes/game_objects/enemy.dart';
import 'package:dodge_the_spikes/level.dart';
import 'package:dodge_the_spikes/pages/main_game.dart';
import 'package:dodge_the_spikes/pages/main_page.dart';
import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main(){
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: SizedBox(
            width: 588,
            height: 588,
            child: MainPage()
          ),
        ),
      ),
    )
  );
}

