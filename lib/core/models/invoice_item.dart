import 'product.dart';

class InvoiceItem {
  const InvoiceItem({
    required this.product,
    required this.quantity,
    required this.price,
    required this.tax,
    required this.total,
  });

  final Product product;
  final double quantity;
  final double price;
  final double tax;
  final double total;

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'price': price,
      'tax': tax,
      'total': total,
    };
  }
}
