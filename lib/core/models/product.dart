class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.taxRate,
    required this.barcode,
    required this.stockQty,
  });

  final String id;
  final String name;
  final double price;
  final double taxRate;
  final String barcode;
  final double stockQty;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      taxRate: (json['taxRate'] as num).toDouble(),
      barcode: json['barcode'] as String,
      stockQty: (json['stockQty'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'taxRate': taxRate,
      'barcode': barcode,
      'stockQty': stockQty,
    };
  }
}
