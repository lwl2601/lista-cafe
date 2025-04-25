class Contribution {
  final DateTime date;
  final String item;
  final int quantity;
  final String type;
  final String userName;

  Contribution({
    required this.date,
    required this.item,
    required this.quantity,
    required this.type,
    required this.userName,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'item': item,
      'quantity': quantity,
      'type': type,
      'userName': userName,
    };
  }

  factory Contribution.fromJson(Map<String, dynamic> json) {
    return Contribution(
      date: DateTime.parse(json['date']),
      item: json['item'],
      quantity: json['quantity'],
      type: json['type'],
      userName: json['userName'],
    );
  }
}
