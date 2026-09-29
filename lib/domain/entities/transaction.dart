enum TransactionType { income, expense }

class Transaction {
  final String id;
  final TransactionType type;
  final double amount;      // always positive; sign comes from `type`
  final DateTime date;
  final String? category;   // optional, e.g. "Food", "Freelance"
  final String? note;       // optional

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    this.category,
    this.note,
  }) : assert(amount >= 0, 'amount must be non-negative; use type to signal direction');
}