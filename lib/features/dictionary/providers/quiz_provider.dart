import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/dictionary_db_service.dart';
import '../domain/quiz_question.dart';

final quizQuestionProvider = FutureProvider<QuizQuestion?>((ref) async {
  return DictionaryDbService.instance.getRandomQuizQuestion();
});

class QuizScoreNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
}

final quizScoreProvider = NotifierProvider<QuizScoreNotifier, int>(
  QuizScoreNotifier.new,
);
