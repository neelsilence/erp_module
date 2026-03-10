import 'package:flutter/material.dart';

import '../../core/models/billing_models.dart';
import '../../core/utils/gst_calculator.dart';

class InvoiceCard extends StatelessWidget {
  const InvoiceCard({super.key, required this.invoice});

  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    final totals = const GstCalculator().calculateTotals(invoice.items);
    return Card(
      child: ListTile(
        title: Text('${invoice.type.name.toUpperCase()} • ${invoice.id}'),
        subtitle: Text(
          '${invoice.party.name}\nItems: ${invoice.items.length} • GST: ${totals.gstAmount.toStringAsFixed(2)}',
        ),
        isThreeLine: true,
        trailing: Text(totals.totalAmount.toStringAsFixed(2)),
      ),
    );
  }
}
