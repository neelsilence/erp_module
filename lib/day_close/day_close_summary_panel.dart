import 'package:flutter/material.dart';

import 'day_close_models.dart';

/// Optional UI widget for ERP apps that enable day close.
class DayCloseSummaryPanel extends StatelessWidget {
  const DayCloseSummaryPanel({
    super.key,
    required this.snapshot,
    this.currencySymbol = '₹',
    this.isClosed = false,
    this.closedBy,
    this.closedAt,
  });

  final DayCloseSnapshot snapshot;
  final String currencySymbol;
  final bool isClosed;
  final String? closedBy;
  final DateTime? closedAt;

  @override
  Widget build(BuildContext context) {
    String fmt(DateTime dt) {
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '${dt.day.toString().padLeft(2, '0')} '
          '${_month(dt.month)} ${dt.year}, $h:$m';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Day Close Preview',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Business day ${snapshot.businessDayKey}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isClosed
                      ? const Color(0xFFE9F9F0)
                      : const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isClosed
                        ? const Color(0xFF26C26A)
                        : const Color(0xFFF59E0B),
                  ),
                ),
                child: Text(
                  isClosed ? 'Closed' : 'Open',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isClosed
                        ? const Color(0xFF26C26A)
                        : const Color(0xFFB45309),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${fmt(snapshot.rangeStart)} — ${fmt(snapshot.rangeEnd)}',
            style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
          ),
          if (isClosed && closedBy != null) ...[
            const SizedBox(height: 6),
            Text(
              'Closed by $closedBy${closedAt != null ? ' • ${fmt(closedAt!)}' : ''}',
              style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
            ),
          ],
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _metric('Net Sales', snapshot.netSales, currencySymbol),
              _metric('Tax', snapshot.totalTax, currencySymbol),
              _metric('Discount', snapshot.totalDiscount, currencySymbol),
              _metric('Completed', snapshot.completedCount.toDouble(), '',
                  isCount: true),
              _metric('Cancelled', snapshot.cancelledCount.toDouble(), '',
                  isCount: true),
            ],
          ),
          if (snapshot.paymentBreakdown.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Payment breakdown',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 8),
            ...snapshot.paymentBreakdown.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${entry.method.label} (${entry.count})',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    Text(
                      '$currencySymbol${entry.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _metric(
    String label,
    double value,
    String symbol, {
    bool isCount = false,
  }) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 4),
          Text(
            isCount ? value.toInt().toString() : '$symbol${value.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  String _month(int value) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[(value - 1).clamp(0, 11)];
  }
}
