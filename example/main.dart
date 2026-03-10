import 'package:erp_billing_module/core/models/billing_models.dart';
import 'package:erp_billing_module/data/datasources/invoice_local_datasource.dart';
import 'package:erp_billing_module/data/repositories/invoice_repository.dart';
import 'package:erp_billing_module/services/billing_pdf_service.dart';
import 'package:erp_billing_module/services/inventory_service.dart';
import 'package:erp_billing_module/ui/screens/billing_dashboard_screen.dart';
import 'package:erp_billing_module/ui/state/billing_controller.dart';
import 'package:flutter/material.dart';

void main() {
  final repository = InvoiceRepository(InMemoryInvoiceLocalDataSource());
  final inventoryService = InMemoryInventoryService(seedStock: {'SKU-001': 100});

  final controller = BillingController(
    invoiceRepository: repository,
    inventoryService: inventoryService,
    billingPdfService: SimpleBillingPdfService(),
  );

  controller.createInvoice(
    Invoice(
      id: 'INV-001',
      type: InvoiceType.sales,
      party: const Party(id: 'CUST-1', name: 'Acme Retail', gstNumber: '22AAAAA0000A1Z5'),
      items: const [
        InvoiceItem(
          sku: 'SKU-001',
          description: 'Demo Item',
          unitPrice: 250,
          quantity: 2,
          gstRate: 0.18,
        ),
      ],
      createdAt: DateTime.now(),
    ),
  );

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BillingDashboardScreen(controller: controller),
  ));
}
