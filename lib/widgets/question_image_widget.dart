import 'package:flutter/material.dart';

class QuestionImageWidget extends StatelessWidget {
  final String imagePath;
  final bool showCard;
  final Animation<double> animation;

  const QuestionImageWidget({
    required this.imagePath,
    required this.showCard,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      top: showCard ? 15 : -400,
      left: 20,
      right: 20,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: animation,
              child: child,
            ),
          );
        },
        child: Card(
          key: ValueKey<String>(imagePath),
          shadowColor: Colors.grey.shade800,
          elevation: 10,
          margin: EdgeInsets.all(25),
          color: Colors.grey.shade50,
          child: Container(
            height: 150,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: Image.asset(imagePath),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
