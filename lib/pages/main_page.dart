import 'package:dodge_the_spikes/level_data.dart';
import 'package:dodge_the_spikes/page_transition.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../level.dart';
import 'main_game.dart';

enum Screen{
  menu,
  game,
  levelFinished
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  Screen currentScreen = Screen.menu;
  int selectedLevel = 1;
  late PageTransition pageTransition;
  bool gameOver = false;

  @override
  void initState() {
    pageTransition = PageTransition(
      onMiddleState: (){
        if(currentScreen == Screen.menu || currentScreen == Screen.game && gameOver){
          setState(() {
            currentScreen = Screen.game;
            gameOver = false;
          });
        }else if(currentScreen == Screen.game && !gameOver && selectedLevel <= levels.length){
          selectedLevel++;
          setState(() {
            currentScreen = Screen.game;
            gameOver = false;
          });
        }else if(currentScreen == Screen.game && !gameOver && selectedLevel > levels.length){
          selectedLevel = 1;
          setState(() {
            currentScreen = Screen.menu;
            gameOver = false;
          });
        }
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_){
      FlameAudio.bgm.initialize();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        currentScreen == Screen.menu ? RawKeyboardListener(
          focusNode: FocusNode(),
          autofocus: true,
          onKey: (RawKeyEvent event){
            if(event.isKeyPressed(LogicalKeyboardKey.space) && currentScreen != Screen.game){
              if(!FlameAudio.bgm.isPlaying){
                try{
                  FlameAudio.bgm.play("background_music.wav");
                }catch(e){
                  print(e);
                }
              }
              pageTransition.startTransition();
            }
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                const Expanded(
                  child: Center(
                    child: Text(
                      "Bees and\nSpikes",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.black,
                        fontFamily: "Silkscreen-Regular"
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Level",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontFamily: "Silkscreen-Regular"
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: (){
                                  if(selectedLevel > 1){
                                    setState(() {
                                      selectedLevel--;
                                    });
                                  }
                                },
                                child: const Text(
                                  "<",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.black,
                                    fontFamily: "Silkscreen-Regular"
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                              ),
                              child: Text(
                                selectedLevel.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontFamily: "Silkscreen-Regular"
                                ),
                              ),
                            ),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: (){
                                  if(selectedLevel < 5){
                                    setState(() {
                                      selectedLevel++;
                                    });
                                  }
                                },
                                child: const Text(
                                  ">",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.black,
                                    fontFamily: "Silkscreen-Regular"
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "(Press space to start)",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontFamily: "Silkscreen-Regular"
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ) : currentScreen == Screen.game ? GameWidget(
          game: MainGame(
            level: Level(
              data: [
                ["E", "D", "E", "F", "E"],
                ["E", "W", "L", "E", "E"],
                ["E", "W", "E", "D", "E"],
                ["E", "W", "+1", "E", "E"],
                ["E", "B", "E", "E", "E"],
              ]
            ),
            onGameOver: (){
              Future.delayed(const Duration(milliseconds: 500)).then((_){
                gameOver = true;
                pageTransition.startTransition();
              });
            },
            onGameWon: (){
              Future.delayed(const Duration(milliseconds: 500)).then((_){
                gameOver = false;
                pageTransition.startTransition();
              });
            }
          ),
        ) : Container(

        ),
        pageTransition
      ],
    );
  }
}
