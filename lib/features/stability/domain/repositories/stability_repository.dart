import '../entities/stability_log.dart';

abstract class StabilityRepository {
  Future<void> saveLog(StabilityLog log);
  Future<List<StabilityLog>> getLast14Logs();
}
