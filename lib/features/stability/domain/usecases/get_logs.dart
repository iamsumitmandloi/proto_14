import '../entities/stability_log.dart';
import '../repositories/stability_repository.dart';

class GetLogs {
  const GetLogs(this._repository);

  final StabilityRepository _repository;

  Future<List<StabilityLog>> call() {
    return _repository.getLast14Logs();
  }
}
