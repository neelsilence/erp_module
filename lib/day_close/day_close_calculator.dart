import 'business_day.dart';
import 'day_close_models.dart';

class DayCloseCalculator {
  const DayCloseCalculator();

  DayCloseSnapshot build({
    required BusinessDayRange range,
    required List<DayCloseTransaction> transactions,
  }) {
    var grossSales = 0.0;
    var totalTax = 0.0;
    var totalDiscount = 0.0;
    var completedCount = 0;
    var cancelledCount = 0;
    var pendingCount = 0;

    final paymentTotals = <DayClosePaymentMethod, ({double amount, int count})>{};

    for (final txn in transactions) {
      switch (txn.status) {
        case DayCloseTransactionStatus.completed:
          completedCount++;
          grossSales += txn.amount;
          totalTax += txn.taxAmount;
          totalDiscount += txn.discountAmount;
          final current = paymentTotals[txn.paymentMethod];
          paymentTotals[txn.paymentMethod] = (
            amount: (current?.amount ?? 0) + txn.amount,
            count: (current?.count ?? 0) + 1,
          );
        case DayCloseTransactionStatus.cancelled:
          cancelledCount++;
        case DayCloseTransactionStatus.pending:
          pendingCount++;
        case DayCloseTransactionStatus.refunded:
          break;
      }
    }

    final breakdown = paymentTotals.entries
        .map(
          (entry) => PaymentBreakdownEntry(
            method: entry.key,
            amount: entry.value.amount,
            count: entry.value.count,
          ),
        )
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    return DayCloseSnapshot(
      businessDayKey: range.key,
      rangeStart: range.start,
      rangeEnd: range.end,
      grossSales: grossSales,
      totalTax: totalTax,
      totalDiscount: totalDiscount,
      netSales: grossSales,
      transactionCount: transactions.length,
      completedCount: completedCount,
      cancelledCount: cancelledCount,
      pendingCount: pendingCount,
      paymentBreakdown: breakdown,
      transactions: List<DayCloseTransaction>.from(transactions),
    );
  }
}
