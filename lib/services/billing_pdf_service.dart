import '../core/models/billing_models.dart';
import '../core/utils/gst_calculator.dart';

abstract class BillingPdfService {
  Future<List<int>> generateInvoicePdf(Invoice invoice);
}

class SimpleBillingPdfService implements BillingPdfService {
  SimpleBillingPdfService({GstCalculator? gstCalculator})
      : _gstCalculator = gstCalculator ?? const GstCalculator();

  final GstCalculator _gstCalculator;

  @override
  Future<List<int>> generateInvoicePdf(Invoice invoice) async {
    final totals = _gstCalculator.calculateTotals(invoice.items);

    final lineItems = invoice.items
        .map(
          (item) =>
              '${item.description} (${item.sku}) x${item.quantity} @ ${item.unitPrice.toStringAsFixed(2)} = ${item.subtotal.toStringAsFixed(2)}',
        )
        .join('\n');

    final document = '''
ERP Invoice
Invoice ID: ${invoice.id}
Invoice Type: ${invoice.type.name}
Party: ${invoice.party.name}
GST Number: ${invoice.party.gstNumber ?? '-'}
Date: ${invoice.createdAt.toIso8601String()}

Items:
$lineItems

Taxable Amount: ${totals.taxableAmount.toStringAsFixed(2)}
GST Amount: ${totals.gstAmount.toStringAsFixed(2)}
Total Amount: ${totals.totalAmount.toStringAsFixed(2)}
''';

    return document.codeUnits;
  }
}
