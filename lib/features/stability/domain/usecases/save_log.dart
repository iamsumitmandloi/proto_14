import '../entities/stability_log.dart';
import '../repositories/stability_repository.dart';

class SaveLog {
  const SaveLog(this._repository);

  final StabilityRepository _repository;

  Future<void> call(StabilityLog log) {
    return _repository.saveLog(log);
  }
}
