import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:stability_tracker_14_day/features/stability/data/stability_remote_data_source.dart';
import 'package:stability_tracker_14_day/features/stability/data/stability_repository_impl.dart';
import 'package:stability_tracker_14_day/features/stability/domain/entities/stability_log.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockPostgrestQueryBuilder extends Mock implements PostgrestQueryBuilder {}

void main() {
  late MockSupabaseClient mockClient;
  late MockPostgrestQueryBuilder mockQueryBuilder;
  late StabilityRepositoryImpl repository;

  setUp(() {
    mockClient = MockSupabaseClient();
    mockQueryBuilder = MockPostgrestQueryBuilder();

    when(() => mockClient.from('stability_logs')).thenReturn(mockQueryBuilder);
    when(
      () => mockQueryBuilder.upsert(any(), onConflict: any(named: 'onConflict')),
    ).thenAnswer((_) async => <Map<String, dynamic>>[]);

    repository = StabilityRepositoryImpl(StabilityRemoteDataSource(mockClient));
  });

  test('saveLog upserts by date using Supabase client', () async {
    final log = StabilityLog(
      date: DateTime(2026, 1, 5),
      pushupsDone: true,
      deepWorkDone: false,
      stepsCount: 13000,
      cigarettesCount: 2,
      score: 2,
    );

    await repository.saveLog(log);

    verify(() => mockClient.from('stability_logs')).called(1);
    verify(
      () => mockQueryBuilder.upsert(
        any(
          that: predicate<Map<String, dynamic>>(
            (payload) => payload['date'] == '2026-01-05' && payload['score'] == 2,
          ),
        ),
        onConflict: 'date',
      ),
    ).called(1);
  });
}
