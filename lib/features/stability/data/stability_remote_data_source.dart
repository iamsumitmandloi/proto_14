import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/entities/stability_log.dart';

class StabilityRemoteDataSource {
  StabilityRemoteDataSource(this._client);

  final SupabaseClient _client;

  Future<void> upsertLog(StabilityLog log) async {
    final payload = {
      'date': DateFormat('yyyy-MM-dd').format(log.date),
      'pushups_done': log.pushupsDone,
      'deep_work_done': log.deepWorkDone,
      'steps_count': log.stepsCount,
      'cigarettes_count': log.cigarettesCount,
      'score': log.score,
    };

    await _client.from('stability_logs').upsert(payload, onConflict: 'date');
  }

  Future<List<StabilityLog>> getLast14Logs() async {
    final result = await _client
        .from('stability_logs')
        .select()
        .order('date', ascending: false)
        .limit(14);

    return (result as List<dynamic>)
        .map((row) => _mapToLog(row as Map<String, dynamic>))
        .toList();
  }

  StabilityLog _mapToLog(Map<String, dynamic> json) {
    return StabilityLog(
      id: json['id'] as String?,
      date: DateTime.parse(json['date'] as String),
      pushupsDone: json['pushups_done'] as bool,
      deepWorkDone: json['deep_work_done'] as bool,
      stepsCount: json['steps_count'] as int,
      cigarettesCount: json['cigarettes_count'] as int,
      score: json['score'] as int,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }
}
