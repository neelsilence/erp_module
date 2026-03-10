class Payment {
  const Payment({
    required this.id,
    required this.invoiceId,
    required this.amount,
    required this.method,
    required this.paidAt,
  });

  final String id;
  final String invoiceId;
  final double amount;
  final String method;
  final DateTime paidAt;

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String,
      invoiceId: json['invoiceId'] as String,
      amount: (json['amount'] as num).toDouble(),
      method: json['method'] as String,
      paidAt: DateTime.parse(json['paidAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoiceId': invoiceId,
      'amount': amount,
      'method': method,
      'paidAt': paidAt.toIso8601String(),
    };
  }
}
