 

import 'package:flutter/foundation.dart';
import 'package:word_image_matching_game/models/question.dart';

class GameState with ChangeNotifier {
  int _correctAnswers = 0;
  int _wrongAttempts = 0;
  final List<Map<String, dynamic>> _answers = [];
  List<Question> _allQuestions = []; // تأكد من تعريف قائمة allQuestions

  int get correctAnswers => _correctAnswers;
  int get wrongAttempts => _wrongAttempts;
  List<Map<String, dynamic>> get answers => _answers;
  List<Question> get allQuestions => _allQuestions;

  void incrementCorrectAnswers() {
    _correctAnswers++;
    notifyListeners();
  }

  void incrementWrongAttempts() {
    _wrongAttempts++;
    notifyListeners();
  }

  void addAnswer(String word, bool isCorrect) {
    _answers.add({'word': word, 'isCorrect': isCorrect});
    notifyListeners();
  }

  void setAllQuestions(List<Question> questions) {
    _allQuestions = questions;
    notifyListeners();
  }

  void resetGame() {
    _correctAnswers = 0;
    _wrongAttempts = 0;
    _answers.clear();
    _allQuestions.clear(); // إعادة تعيين allQuestions عند إعادة اللعبة
    notifyListeners();
  }
}
