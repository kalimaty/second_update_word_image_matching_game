import 'package:flutter/material.dart';
import 'package:word_image_matching_game/game_logic.dart';
import '../models/question.dart';

class QuestionWidget extends StatefulWidget {
  final Question question;
  final List<Question> allQuestions;
  final Function(String, bool) onAnswer;

  QuestionWidget({
    required this.question,
    required this.allQuestions,
    required this.onAnswer,
  });

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget>
    with SingleTickerProviderStateMixin {
  Color? _color;
  bool _isLocked = false;
  bool _showCard = false;
  bool _showDialog = false;
  bool _hideDialog = false;
  bool _canInteract = true;
  String? selectedWord;
  late List<String> wordOptions;
  final GameLogic _gameLogic = GameLogic();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initializeImageOptions();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticInOut,
      ),
    );

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _showCard = true;
        _gameLogic.speakWord(widget.question.word);
      });
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _showDialog = true;
        });
      });
    });
  }

  void _initializeImageOptions() {
    _gameLogic.initializeImageOptions(widget.question, widget.allQuestions,
        (options) {
      setState(() {
        wordOptions = options;
      });
    });
  }

  @override
  void didUpdateWidget(covariant QuestionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question) {
      _initializeImageOptions();

      setState(() {
        _showCard = false;
        _showDialog = false;
        _hideDialog = false;
        _canInteract = true;
        selectedWord = null;
      });
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          _showCard = true;
          _gameLogic.speakWord(widget.question.word);
        });
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            _showDialog = true;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      backgroundColor: Colors.amber.shade100.withOpacity(0.5),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            top: _showCard ? 15 : -400,
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
                key: ValueKey<String>(widget.question.imagePath),
                shadowColor: Colors.grey.shade800,
                elevation: 10,
                margin: EdgeInsets.all(5),
                color: _color ?? Colors.grey.shade50,
                child: Container(
                  height: 200,
                  width: double.maxFinite,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return ScaleTransition(
                          scale: _animation,
                          child: child,
                        );
                      },
                      child: Image.asset(widget.question.imagePath),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            top: _hideDialog ? 600 : (_showDialog ? 250 : 600),
            left: 20,
            right: 20,
            child: _showDialog
                ? _buildOptionsDialog(context, wordOptions)
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsDialog(BuildContext context, List<String> wordOptions) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border:
            Border.all(width: 3, color: const Color.fromARGB(153, 175, 73, 73)),
        borderRadius: BorderRadius.circular(20),
      ),
      width: double.maxFinite,
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: wordOptions.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: _canInteract
                  ? () => _handleSelection(wordOptions[index])
                  : null,
              child: Column(
                children: [
                  Container(
                    height: 70,
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      border: Border.all(width: 5, color: Colors.white),
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                        child: Text(
                      wordOptions[index],
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                  if (selectedWord != null)
                    if (wordOptions[index] == widget.question.word &&
                        wordOptions[index] == selectedWord)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      )
                    else if (wordOptions[index] != widget.question.word &&
                        wordOptions[index] == selectedWord)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleSelection(String selectedWord) {
    _gameLogic.handleSelection(selectedWord, widget.question, context,
        (isCorrect, color) {
      setState(() {
        _isLocked = true;
        _canInteract = false;
        this.selectedWord = selectedWord;
        _color = color;

        if (isCorrect) {
          _animationController.repeat(reverse: true);
        }

        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            _hideDialog = true;
          });

          Future.delayed(Duration(milliseconds: 500), () {
            setState(() {
              _isLocked = false;
              _color = null;
              _showDialog = false;
              _hideDialog = false;
              _canInteract = true;
              this.selectedWord = null;
            });

            widget.onAnswer(widget.question.word, isCorrect);
            if (isCorrect) {
              _animationController.stop();
            }
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _gameLogic.flutterTts.stop();
    _animationController.dispose();
    super.dispose();
  }
}
