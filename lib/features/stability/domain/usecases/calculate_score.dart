class ScoreCalculator {
  const ScoreCalculator();

  int call({
    required bool pushupsDone,
    required bool deepWorkDone,
    required int stepsCount,
    required int cigarettesCount,
  }) {
    var score = 0;
    if (pushupsDone) score++;
    if (deepWorkDone) score++;
    if (stepsCount >= 15000) score++;
    if (cigarettesCount <= 3) score++;
    return score;
  }
}
