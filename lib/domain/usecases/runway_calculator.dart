import 'package:micro_budgeting/domain/entities/transaction.dart';

class RunwayCalculator {
  /// Balance = initial balance + all income − all expenses.
  static double calculateBalance({
    required double initialBalance,
    required List<Transaction> transactions,
  }) {
    double balance = initialBalance;
    for (final t in transactions) {
      balance += t.type == TransactionType.income ? t.amount : -t.amount;
    }
    return balance;
  }

  /// Average daily spending over the last [windowDays] days, ending [asOf].
  /// Returns null when there's no expense data in the window at all —
  /// callers must treat null as "not enough data", never as 0.
  static double? calculateAverageDailySpending({
    required List<Transaction> transactions,
    required int windowDays,
    required DateTime asOf,
  }) {
    final windowStart = asOf.subtract(Duration(days: windowDays));
    final expensesInWindow = transactions.where((t) =>
        t.type == TransactionType.expense &&
        t.date.isAfter(windowStart) &&
        !t.date.isAfter(asOf));

    if (expensesInWindow.isEmpty) return null;

    final total = expensesInWindow.fold<double>(0, (sum, t) => sum + t.amount);
    return total / windowDays;
  }
  static double? calculateRunway({
    required double balance,
    required double? averageDailySpending,
  }) {
    if (balance <= 0) return 0;
    if (averageDailySpending == null) return null;
    if (averageDailySpending == 0) return double.infinity;
    return balance / averageDailySpending;
  }
}