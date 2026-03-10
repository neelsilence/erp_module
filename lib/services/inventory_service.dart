import '../core/models/billing_models.dart';

abstract class InventoryService {
  Future<void> syncInvoice(Invoice invoice);
  Future<double> getStockLevel(String sku);
}

class InMemoryInventoryService implements InventoryService {
  final Map<String, double> _stockBySku;

  InMemoryInventoryService({Map<String, double>? seedStock})
      : _stockBySku = {...?seedStock};

  @override
  Future<double> getStockLevel(String sku) async => _stockBySku[sku] ?? 0;

  @override
  Future<void> syncInvoice(Invoice invoice) async {
    for (final item in invoice.items) {
      final existingQty = _stockBySku[item.sku] ?? 0;
      final delta = invoice.type == InvoiceType.sales ? -item.quantity : item.quantity;
      _stockBySku[item.sku] = existingQty + delta;
    }
  }
}
