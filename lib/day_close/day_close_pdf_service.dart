import 'day_close_models.dart';

abstract class DayClosePdfService {
  Future<List<int>> generateReport(DayCloseRecord record);
}

class SimpleDayClosePdfService implements DayClosePdfService {
  const SimpleDayClosePdfService({this.businessName = 'Business'});

  final String businessName;

  @override
  Future<List<int>> generateReport(DayCloseRecord record) async {
    final snapshot = record.snapshot;
    final breakdown = snapshot.paymentBreakdown
        .map(
          (entry) =>
              '${entry.method.label}: ${entry.amount.toStringAsFixed(2)} (${entry.count})',
        )
        .join('\n');

    final document = '''
DAY CLOSE REPORT
$businessName
Business Day: ${snapshot.businessDayKey}
Period: ${snapshot.rangeStart.toIso8601String()} — ${snapshot.rangeEnd.toIso8601String()}
Closed At: ${record.closedAt.toIso8601String()}
Closed By: ${record.closedBy}

SUMMARY
Completed Transactions: ${snapshot.completedCount}
Cancelled: ${snapshot.cancelledCount}
Pending: ${snapshot.pendingCount}
Gross Sales: ${snapshot.grossSales.toStringAsFixed(2)}
Total Tax: ${snapshot.totalTax.toStringAsFixed(2)}
Total Discount: ${snapshot.totalDiscount.toStringAsFixed(2)}
Net Sales: ${snapshot.netSales.toStringAsFixed(2)}

PAYMENT BREAKDOWN
$breakdown

CASH RECONCILIATION
Opening Float: ${record.openingFloat.toStringAsFixed(2)}
Closing Cash: ${record.closingCash?.toStringAsFixed(2) ?? '-'}
Variance: ${record.cashVariance?.toStringAsFixed(2) ?? '-'}

${record.notes != null && record.notes!.isNotEmpty ? 'Notes: ${record.notes}\n' : ''}** End of Day Close Report **
''';

    return document.codeUnits;
  }
}
