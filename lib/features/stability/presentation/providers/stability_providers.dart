import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/stability_remote_data_source.dart';
import '../../data/stability_repository_impl.dart';
import '../../domain/entities/stability_log.dart';
import '../../domain/repositories/stability_repository.dart';
import '../../domain/usecases/calculate_score.dart';
import '../../domain/usecases/get_logs.dart';
import '../../domain/usecases/save_log.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final remoteDataSourceProvider = Provider<StabilityRemoteDataSource>((ref) {
  return StabilityRemoteDataSource(ref.watch(supabaseClientProvider));
});

final stabilityRepositoryProvider = Provider<StabilityRepository>((ref) {
  return StabilityRepositoryImpl(ref.watch(remoteDataSourceProvider));
});

final scoreCalculatorProvider = Provider<ScoreCalculator>((ref) {
  return const ScoreCalculator();
});

final saveLogUseCaseProvider = Provider<SaveLog>((ref) {
  return SaveLog(ref.watch(stabilityRepositoryProvider));
});

final getLogsUseCaseProvider = Provider<GetLogs>((ref) {
  return GetLogs(ref.watch(stabilityRepositoryProvider));
});

class DashboardState {
  const DashboardState({
    required this.logs,
    this.isLoading = false,
    this.isSaving = false,
    this.error,
  });

  final List<StabilityLog> logs;
  final bool isLoading;
  final bool isSaving;
  final String? error;

  DashboardState copyWith({
    List<StabilityLog>? logs,
    bool? isLoading,
    bool? isSaving,
    String? error,
    bool clearError = false,
  }) {
    return DashboardState(
      logs: logs ?? this.logs,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier(this._getLogs, this._saveLog)
      : super(const DashboardState(logs: []));

  final GetLogs _getLogs;
  final SaveLog _saveLog;

  Future<void> loadLogs() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final logs = await _getLogs();
      logs.sort((a, b) => b.date.compareTo(a.date));
      state = state.copyWith(logs: logs, isLoading: false);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load logs. Please check your network and try again.',
      );
    }
  }

  Future<void> saveTodayLog(StabilityLog log) async {
    state = state.copyWith(isSaving: true, clearError: true);
    try {
      await _saveLog(log);
      state = state.copyWith(isSaving: false);
      await loadLogs();
    } catch (_) {
      state = state.copyWith(
        isSaving: false,
        error: 'Failed to save log. Please check your network and try again.',
      );
    }
  }
}

final dashboardNotifierProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  return DashboardNotifier(
    ref.watch(getLogsUseCaseProvider),
    ref.watch(saveLogUseCaseProvider),
  );
});
