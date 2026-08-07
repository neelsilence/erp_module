import 'business_day.dart';
import 'day_close_calculator.dart';
import 'day_close_models.dart';
import 'day_close_store.dart';
import 'day_close_transaction_provider.dart';

class DayCloseRepository {
  DayCloseRepository({
    required DayCloseTransactionProvider transactionProvider,
    required DayCloseStore store,
    DayCloseCalculator? calculator,
    DayCloseConfig? config,
  })  : _transactionProvider = transactionProvider,
        _store = store,
        _calculator = calculator ?? const DayCloseCalculator(),
        _config = config ?? const DayCloseConfig();

  final DayCloseTransactionProvider _transactionProvider;
  final DayCloseStore _store;
  final DayCloseCalculator _calculator;
  final DayCloseConfig _config;

  DayCloseConfig get config => _config;

  BusinessDay get businessDay =>
      BusinessDay(cutoffHour: _config.businessDayCutoffHour);

  Future<DayCloseSnapshot> buildPreview({DateTime? at}) async {
    final range = businessDay.resolve(at: at);
    final transactions = await _transactionProvider.fetchTransactions(range);
    return _calculator.build(range: range, transactions: transactions);
  }

  Future<bool> isDayClosed({DateTime? at}) async {
    final range = businessDay.resolve(at: at);
    final existing = await _store.getClosedDay(range.key);
    return existing != null;
  }

  Future<DayCloseRecord?> getClosedDay({DateTime? at}) async {
    final range = businessDay.resolve(at: at);
    return _store.getClosedDay(range.key);
  }

  Future<List<DayCloseRecord>> listClosedDays({int limit = 30}) {
    return _store.listClosedDays(limit: limit);
  }

  Future<DayCloseRecord> closeDay({
    required String closedBy,
    DateTime? at,
    double openingFloat = 0,
    double? closingCash,
    String? notes,
  }) async {
    final range = businessDay.resolve(at: at);
    final existing = await _store.getClosedDay(range.key);
    if (existing != null) {
      throw StateError('Business day ${range.key} is already closed.');
    }

    final snapshot = await buildPreview(at: at);
    final record = DayCloseRecord(
      businessDayKey: range.key,
      snapshot: snapshot,
      closedAt: at ?? DateTime.now(),
      closedBy: closedBy,
      openingFloat: openingFloat,
      closingCash: closingCash,
      notes: notes,
    );

    await _store.saveDayClose(record);
    return record;
  }
}
