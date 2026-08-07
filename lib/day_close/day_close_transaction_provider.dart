import 'business_day.dart';
import 'day_close_models.dart';

/// Implemented by each ERP vertical to supply transactions for a business day.
abstract class DayCloseTransactionProvider {
  Future<List<DayCloseTransaction>> fetchTransactions(BusinessDayRange range);
}
