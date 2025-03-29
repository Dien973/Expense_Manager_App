class Income {
  final String id;
  final String userId;
  final double inAmount;
  final String source; // Nguồn thu nhập (lương, đầu tư, thưởng, ...)
  final DateTime date;

  Income({
    required this.id,
    required this.userId,
    required this.inAmount,
    required this.source,
    required this.date,
  });

  // Chuyển đổi từ JSON
  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      id: json['id'],
      userId: json['userId'],
      inAmount: (json['inAmount'] ?? 0).toDouble(), // Thêm kiểm tra null
      source: json['source'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
    );
  }

  // Chuyển đổi sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'inAmount': inAmount,
      'source': source,
      'date': date.toIso8601String(),
    };
  }
}
