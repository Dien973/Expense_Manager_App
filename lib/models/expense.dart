class Expense {
  final String id;
  final String userId;
  // final String categoryId;
  final String name;
  final double amount;
  final DateTime date;

  Expense({
    required this.id,
    required this.userId,
    // required this.categoryId,
    required this.name,
    required this.amount,
    required this.date,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      userId: json['userId'],
      // categoryId: json['categoryId'],
      name: json['name'],
      amount: (json['amount']).toDouble(),
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }
}
