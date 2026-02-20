class StabilityLog {
  const StabilityLog({
    this.id,
    required this.date,
    required this.pushupsDone,
    required this.deepWorkDone,
    required this.stepsCount,
    required this.cigarettesCount,
    required this.score,
    this.createdAt,
  });

  final String? id;
  final DateTime date;
  final bool pushupsDone;
  final bool deepWorkDone;
  final int stepsCount;
  final int cigarettesCount;
  final int score;
  final DateTime? createdAt;

  StabilityLog copyWith({
    String? id,
    DateTime? date,
    bool? pushupsDone,
    bool? deepWorkDone,
    int? stepsCount,
    int? cigarettesCount,
    int? score,
    DateTime? createdAt,
  }) {
    return StabilityLog(
      id: id ?? this.id,
      date: date ?? this.date,
      pushupsDone: pushupsDone ?? this.pushupsDone,
      deepWorkDone: deepWorkDone ?? this.deepWorkDone,
      stepsCount: stepsCount ?? this.stepsCount,
      cigarettesCount: cigarettesCount ?? this.cigarettesCount,
      score: score ?? this.score,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
