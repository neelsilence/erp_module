enum DayCloseTransactionStatus { completed, cancelled, pending, refunded }

enum DayClosePaymentMethod { cash, upi, card, other, unknown }

extension DayClosePaymentMethodX on DayClosePaymentMethod {
  String get label {
    switch (this) {
      case DayClosePaymentMethod.cash:
        return 'Cash';
      case DayClosePaymentMethod.upi:
        return 'UPI';
      case DayClosePaymentMethod.card:
        return 'Card';
      case DayClosePaymentMethod.other:
        return 'Other';
      case DayClosePaymentMethod.unknown:
        return 'Unspecified';
    }
  }

  static DayClosePaymentMethod parse(String? raw) {
    switch ((raw ?? '').toLowerCase().trim()) {
      case 'cash':
        return DayClosePaymentMethod.cash;
      case 'upi':
      case 'online':
        return DayClosePaymentMethod.upi;
      case 'card':
      case 'credit':
      case 'debit':
        return DayClosePaymentMethod.card;
      case 'other':
        return DayClosePaymentMethod.other;
      default:
        return DayClosePaymentMethod.unknown;
    }
  }
}

/// Generic monetary transaction used to build a day close report.
class DayCloseTransaction {
  const DayCloseTransaction({
    required this.id,
    required this.reference,
    required this.amount,
    required this.taxAmount,
    required this.discountAmount,
    required this.paymentMethod,
    required this.status,
    required this.occurredAt,
    this.notes,
  });

  final String id;
  final String reference;
  final double amount;
  final double taxAmount;
  final double discountAmount;
  final DayClosePaymentMethod paymentMethod;
  final DayCloseTransactionStatus status;
  final DateTime occurredAt;
  final String? notes;

  double get netAmount => amount;
}

class PaymentBreakdownEntry {
  const PaymentBreakdownEntry({
    required this.method,
    required this.amount,
    required this.count,
  });

  final DayClosePaymentMethod method;
  final double amount;
  final int count;
}

class DayCloseSnapshot {
  const DayCloseSnapshot({
    required this.businessDayKey,
    required this.rangeStart,
    required this.rangeEnd,
    required this.grossSales,
    required this.totalTax,
    required this.totalDiscount,
    required this.netSales,
    required this.transactionCount,
    required this.completedCount,
    required this.cancelledCount,
    required this.pendingCount,
    required this.paymentBreakdown,
    required this.transactions,
  });

  final String businessDayKey;
  final DateTime rangeStart;
  final DateTime rangeEnd;
  final double grossSales;
  final double totalTax;
  final double totalDiscount;
  final double netSales;
  final int transactionCount;
  final int completedCount;
  final int cancelledCount;
  final int pendingCount;
  final List<PaymentBreakdownEntry> paymentBreakdown;
  final List<DayCloseTransaction> transactions;
}

class DayCloseRecord {
  const DayCloseRecord({
    required this.businessDayKey,
    required this.snapshot,
    required this.closedAt,
    required this.closedBy,
    this.openingFloat = 0,
    this.closingCash,
    this.notes,
  });

  final String businessDayKey;
  final DayCloseSnapshot snapshot;
  final DateTime closedAt;
  final String closedBy;
  final double openingFloat;
  final double? closingCash;
  final String? notes;

  double get _cashSalesTotal {
    for (final entry in snapshot.paymentBreakdown) {
      if (entry.method == DayClosePaymentMethod.cash) return entry.amount;
    }
    return 0;
  }

  double? get cashVariance {
    if (closingCash == null) return null;
    return closingCash! - (openingFloat + _cashSalesTotal);
  }

  Map<String, dynamic> toMap() {
    return {
      'businessDayKey': businessDayKey,
      'closedAt': closedAt.toIso8601String(),
      'closedBy': closedBy,
      'openingFloat': openingFloat,
      'closingCash': closingCash,
      'notes': notes,
      'snapshot': _snapshotToMap(snapshot),
    };
  }

  factory DayCloseRecord.fromMap(Map<String, dynamic> map) {
    return DayCloseRecord(
      businessDayKey: map['businessDayKey']?.toString() ?? '',
      closedAt: DateTime.tryParse(map['closedAt']?.toString() ?? '') ??
          DateTime.now(),
      closedBy: map['closedBy']?.toString() ?? 'Unknown',
      openingFloat: (map['openingFloat'] as num?)?.toDouble() ?? 0,
      closingCash: (map['closingCash'] as num?)?.toDouble(),
      notes: map['notes']?.toString(),
      snapshot: _snapshotFromMap(
        Map<String, dynamic>.from(map['snapshot'] as Map? ?? const {}),
      ),
    );
  }

  static Map<String, dynamic> _snapshotToMap(DayCloseSnapshot snapshot) {
    return {
      'businessDayKey': snapshot.businessDayKey,
      'rangeStart': snapshot.rangeStart.toIso8601String(),
      'rangeEnd': snapshot.rangeEnd.toIso8601String(),
      'grossSales': snapshot.grossSales,
      'totalTax': snapshot.totalTax,
      'totalDiscount': snapshot.totalDiscount,
      'netSales': snapshot.netSales,
      'transactionCount': snapshot.transactionCount,
      'completedCount': snapshot.completedCount,
      'cancelledCount': snapshot.cancelledCount,
      'pendingCount': snapshot.pendingCount,
      'paymentBreakdown': snapshot.paymentBreakdown
          .map(
            (entry) => {
              'method': entry.method.name,
              'amount': entry.amount,
              'count': entry.count,
            },
          )
          .toList(),
    };
  }

  static DayCloseSnapshot _snapshotFromMap(Map<String, dynamic> map) {
    final breakdownRaw = (map['paymentBreakdown'] as List?) ?? const [];
    return DayCloseSnapshot(
      businessDayKey: map['businessDayKey']?.toString() ?? '',
      rangeStart: DateTime.tryParse(map['rangeStart']?.toString() ?? '') ??
          DateTime.now(),
      rangeEnd:
          DateTime.tryParse(map['rangeEnd']?.toString() ?? '') ?? DateTime.now(),
      grossSales: (map['grossSales'] as num?)?.toDouble() ?? 0,
      totalTax: (map['totalTax'] as num?)?.toDouble() ?? 0,
      totalDiscount: (map['totalDiscount'] as num?)?.toDouble() ?? 0,
      netSales: (map['netSales'] as num?)?.toDouble() ?? 0,
      transactionCount: (map['transactionCount'] as num?)?.toInt() ?? 0,
      completedCount: (map['completedCount'] as num?)?.toInt() ?? 0,
      cancelledCount: (map['cancelledCount'] as num?)?.toInt() ?? 0,
      pendingCount: (map['pendingCount'] as num?)?.toInt() ?? 0,
      paymentBreakdown: breakdownRaw
          .map((raw) {
            if (raw is! Map) return null;
            return PaymentBreakdownEntry(
              method: DayClosePaymentMethodX.parse(raw['method']?.toString()),
              amount: (raw['amount'] as num?)?.toDouble() ?? 0,
              count: (raw['count'] as num?)?.toInt() ?? 0,
            );
          })
          .whereType<PaymentBreakdownEntry>()
          .toList(),
      transactions: const [],
    );
  }
}

class DayCloseConfig {
  const DayCloseConfig({
    this.businessDayCutoffHour = 0,
    this.currencySymbol = '₹',
  });

  final int businessDayCutoffHour;
  final String currencySymbol;
}
