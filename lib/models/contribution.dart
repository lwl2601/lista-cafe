class Contribution {
  final DateTime date;
  final String item;
  final int quantity;

  Contribution({
    required this.date,
    required this.item,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'item': item,
      'quantity': quantity,
    };
  }

  factory Contribution.fromJson(Map<String, dynamic> json) {
    return Contribution(
      date: DateTime.parse(json['date']),
      item: json['item'],
      quantity: json['quantity'],
    );
  }
}
