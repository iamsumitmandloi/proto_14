import '../domain/entities/stability_log.dart';
import '../domain/repositories/stability_repository.dart';
import 'stability_remote_data_source.dart';

class StabilityRepositoryImpl implements StabilityRepository {
  StabilityRepositoryImpl(this._remoteDataSource);

  final StabilityRemoteDataSource _remoteDataSource;

  @override
  Future<List<StabilityLog>> getLast14Logs() {
    return _remoteDataSource.getLast14Logs();
  }

  @override
  Future<void> saveLog(StabilityLog log) {
    return _remoteDataSource.upsertLog(log);
  }
}
