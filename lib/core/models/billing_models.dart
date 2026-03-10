enum InvoiceType { sales, purchase }

class Party {
  const Party({
    required this.id,
    required this.name,
    this.gstNumber,
    this.address,
  });

  final String id;
  final String name;
  final String? gstNumber;
  final String? address;
}

class InvoiceItem {
  const InvoiceItem({
    required this.sku,
    required this.description,
    required this.unitPrice,
    required this.quantity,
    this.gstRate = 0.18,
  });

  final String sku;
  final String description;
  final double unitPrice;
  final double quantity;
  final double gstRate;

  double get subtotal => unitPrice * quantity;
}

class Invoice {
  const Invoice({
    required this.id,
    required this.type,
    required this.party,
    required this.items,
    required this.createdAt,
    this.notes,
  });

  final String id;
  final InvoiceType type;
  final Party party;
  final List<InvoiceItem> items;
  final DateTime createdAt;
  final String? notes;
}

class InvoiceTotals {
  const InvoiceTotals({
    required this.taxableAmount,
    required this.gstAmount,
    required this.totalAmount,
  });

  final double taxableAmount;
  final double gstAmount;
  final double totalAmount;
}

class InventoryTransaction {
  const InventoryTransaction({
    required this.sku,
    required this.quantity,
    required this.invoiceId,
    required this.type,
  });

  final String sku;
  final double quantity;
  final String invoiceId;
  final InvoiceType type;
}
