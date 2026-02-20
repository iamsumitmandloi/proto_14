import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stability_tracker_14_day/features/stability/data/stability_remote_data_source.dart';
import 'package:stability_tracker_14_day/features/stability/data/stability_repository_impl.dart';
import 'package:stability_tracker_14_day/features/stability/domain/entities/stability_log.dart';

class MockStabilityRemoteDataSource extends Mock
    implements StabilityRemoteDataSource {}

void main() {
  late MockStabilityRemoteDataSource mockRemoteDataSource;
  late StabilityRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockStabilityRemoteDataSource();
    repository = StabilityRepositoryImpl(mockRemoteDataSource);
  });

  test('saveLog delegates to remote data source upsertLog', () async {
    final log = StabilityLog(
      date: DateTime(2026, 1, 5),
      pushupsDone: true,
      deepWorkDone: false,
      stepsCount: 13000,
      cigarettesCount: 2,
      score: 2,
    );

    when(() => mockRemoteDataSource.upsertLog(log)).thenAnswer((_) async {});

    await repository.saveLog(log);

    verify(() => mockRemoteDataSource.upsertLog(log)).called(1);
    verifyNoMoreInteractions(mockRemoteDataSource);
  });
}
