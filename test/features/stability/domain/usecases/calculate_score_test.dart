import 'package:flutter_test/flutter_test.dart';
import 'package:stability_tracker_14_day/features/stability/domain/usecases/calculate_score.dart';

void main() {
  group('ScoreCalculator', () {
    const calculator = ScoreCalculator();

    test('returns 4 when all conditions pass', () {
      final score = calculator(
        pushupsDone: true,
        deepWorkDone: true,
        stepsCount: 15000,
        cigarettesCount: 3,
      );

      expect(score, 4);
    });

    test('returns 0 when all conditions fail', () {
      final score = calculator(
        pushupsDone: false,
        deepWorkDone: false,
        stepsCount: 14999,
        cigarettesCount: 4,
      );

      expect(score, 0);
    });
  });
}
