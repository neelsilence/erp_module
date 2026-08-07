import 'package:flutter/foundation.dart';

import '../../core/models/billing_models.dart';
import '../../core/utils/gst_calculator.dart';
import '../../data/repositories/invoice_repository.dart';
import '../../services/billing_pdf_service.dart';
import '../../services/inventory_service.dart';

class BillingController extends ChangeNotifier {
  BillingController({
    required InvoiceRepository invoiceRepository,
    required InventoryService inventoryService,
    required BillingPdfService billingPdfService,
    GstCalculator? gstCalculator,
  })  : _invoiceRepository = invoiceRepository,
        _inventoryService = inventoryService,
        _billingPdfService = billingPdfService,
        _gstCalculator = gstCalculator ?? const GstCalculator();

  final InvoiceRepository _invoiceRepository;
  final InventoryService _inventoryService;
  final BillingPdfService _billingPdfService;
  final GstCalculator _gstCalculator;

  bool _disposed = false;

  List<Invoice> _invoices = const [];
  List<Invoice> get invoices => _invoices;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> loadInvoices() async {
    _invoices = await _invoiceRepository.getInvoices();
    if (_disposed) return;
    notifyListeners();
  }

  InvoiceTotals previewTotals(List<InvoiceItem> items) {
    return _gstCalculator.calculateTotals(items);
  }

  Future<void> createInvoice(Invoice invoice) async {
    await _invoiceRepository.createInvoice(invoice);
    if (_disposed) return;
    await _inventoryService.syncInvoice(invoice);
    if (_disposed) return;
    await loadInvoices();
  }

  Future<List<int>> exportInvoicePdf(Invoice invoice) {
    return _billingPdfService.generateInvoicePdf(invoice);
  }

  Future<double> stockForSku(String sku) {
    return _inventoryService.getStockLevel(sku);
  }
}
