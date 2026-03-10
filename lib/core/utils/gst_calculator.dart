import '../models/billing_models.dart';

class GstCalculator {
  const GstCalculator();

  InvoiceTotals calculateTotals(List<InvoiceItem> items) {
    final taxableAmount = items.fold<double>(
      0,
      (sum, item) => sum + item.subtotal,
    );

    final gstAmount = items.fold<double>(
      0,
      (sum, item) => sum + (item.subtotal * item.gstRate),
    );

    return InvoiceTotals(
      taxableAmount: taxableAmount,
      gstAmount: gstAmount,
      totalAmount: taxableAmount + gstAmount,
    );
  }
}
