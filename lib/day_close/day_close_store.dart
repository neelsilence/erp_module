import 'day_close_models.dart';

/// Persists closed business days. Optional — only used when day close is enabled.
abstract class DayCloseStore {
  Future<DayCloseRecord?> getClosedDay(String businessDayKey);

  Future<List<DayCloseRecord>> listClosedDays({int limit = 30});

  Future<void> saveDayClose(DayCloseRecord record);
}
