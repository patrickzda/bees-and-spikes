import 'package:flutter/material.dart';

typedef VoidCallback = void Function();

enum TransitionState{
  start,
  middle,
  finished
}

class PageTransition extends StatefulWidget {
  final _PageTransitionState state = _PageTransitionState();

  void Function() onMiddleState;

  PageTransition({Key? key, required this.onMiddleState}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return state;
  }

  void startTransition(){
    state.startTransition();
  }

}

class _PageTransitionState extends State<PageTransition> {

  TransitionState transitionState = TransitionState.finished;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: transitionState == TransitionState.middle ? Alignment.centerRight : Alignment.centerLeft,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
        width: transitionState == TransitionState.start ? 588 : 0,
        height: 588,
        decoration: const BoxDecoration(
          color: Colors.black
        ),
        onEnd: (){
          if(transitionState == TransitionState.start){
            widget.onMiddleState();
            setState(() {
              transitionState = TransitionState.middle;
            });
          }else{
            setState(() {
              transitionState = TransitionState.finished;
            });
          }
        },
      ),
    );
  }

  void startTransition(){
    setState(() {
      transitionState = TransitionState.start;
    });
  }

}
