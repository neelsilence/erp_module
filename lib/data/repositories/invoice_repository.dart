import '../../core/models/billing_models.dart';
import '../datasources/invoice_local_datasource.dart';

class InvoiceRepository {
  InvoiceRepository(this._localDataSource);

  final InvoiceLocalDataSource _localDataSource;

  Future<void> createInvoice(Invoice invoice) {
    return _localDataSource.saveInvoice(invoice);
  }

  Future<List<Invoice>> getInvoices() {
    return _localDataSource.fetchInvoices();
  }

  Future<List<Invoice>> getSalesInvoices() async {
    final invoices = await _localDataSource.fetchInvoices();
    return invoices.where((invoice) => invoice.type == InvoiceType.sales).toList();
  }

  Future<List<Invoice>> getPurchaseInvoices() async {
    final invoices = await _localDataSource.fetchInvoices();
    return invoices
        .where((invoice) => invoice.type == InvoiceType.purchase)
        .toList();
  }
}
