import 'package:flutter/material.dart';

import '../../core/models/billing_models.dart';
import '../state/billing_controller.dart';
import '../widgets/invoice_card.dart';
import '../widgets/responsive_scaffold.dart';

class BillingDashboardScreen extends StatefulWidget {
  const BillingDashboardScreen({super.key, required this.controller});

  final BillingController controller;

  @override
  State<BillingDashboardScreen> createState() => _BillingDashboardScreenState();
}

class _BillingDashboardScreenState extends State<BillingDashboardScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.loadInvoices();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return ResponsiveScaffold(
          title: 'ERP Billing',
          fab: FloatingActionButton.extended(
            onPressed: () => _showCreateInvoiceDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('New Invoice'),
          ),
          body: widget.controller.invoices.isEmpty
              ? const Center(child: Text('No invoices yet.'))
              : ListView.builder(
                  itemCount: widget.controller.invoices.length,
                  itemBuilder: (context, index) {
                    return InvoiceCard(invoice: widget.controller.invoices[index]);
                  },
                ),
        );
      },
    );
  }

  Future<void> _showCreateInvoiceDialog(BuildContext context) async {
    final idController = TextEditingController();
    final partyController = TextEditingController();
    final skuController = TextEditingController();
    final amountController = TextEditingController(text: '100');
    final quantityController = TextEditingController(text: '1');
    var type = InvoiceType.sales;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Invoice'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: idController, decoration: const InputDecoration(labelText: 'Invoice ID')),
                DropdownButtonFormField<InvoiceType>(
                  value: type,
                  decoration: const InputDecoration(labelText: 'Invoice Type'),
                  items: InvoiceType.values
                      .map((item) => DropdownMenuItem(value: item, child: Text(item.name)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      type = value;
                    }
                  },
                ),
                TextField(controller: partyController, decoration: const InputDecoration(labelText: 'Party Name')),
                TextField(controller: skuController, decoration: const InputDecoration(labelText: 'SKU')),
                TextField(controller: amountController, decoration: const InputDecoration(labelText: 'Unit Price')),
                TextField(controller: quantityController, decoration: const InputDecoration(labelText: 'Qty')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            FilledButton(
              onPressed: () async {
                final invoice = Invoice(
                  id: idController.text,
                  type: type,
                  party: Party(id: partyController.text, name: partyController.text),
                  items: [
                    InvoiceItem(
                      sku: skuController.text,
                      description: skuController.text,
                      unitPrice: double.tryParse(amountController.text) ?? 0,
                      quantity: double.tryParse(quantityController.text) ?? 0,
                    ),
                  ],
                  createdAt: DateTime.now(),
                );
                await widget.controller.createInvoice(invoice);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
