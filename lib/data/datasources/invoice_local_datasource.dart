import '../../core/models/billing_models.dart';

abstract class InvoiceLocalDataSource {
  Future<void> saveInvoice(Invoice invoice);
  Future<List<Invoice>> fetchInvoices();
}

class InMemoryInvoiceLocalDataSource implements InvoiceLocalDataSource {
  final List<Invoice> _invoices = [];

  @override
  Future<List<Invoice>> fetchInvoices() async => List.unmodifiable(_invoices);

  @override
  Future<void> saveInvoice(Invoice invoice) async {
    _invoices.removeWhere((existing) => existing.id == invoice.id);
    _invoices.add(invoice);
  }
}
