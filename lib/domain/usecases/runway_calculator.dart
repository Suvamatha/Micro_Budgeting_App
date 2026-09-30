import 'package:micro_budgeting/domain/entities/runway_snapshot.dart';
import 'package:micro_budgeting/domain/entities/setting.dart';
import 'package:micro_budgeting/domain/entities/transaction.dart';

class RunwayCalculator {
  static double calculateBalance({
    required final initialBalance,
    required List <Transaction> transactions,
  }){
    double balance = initialBalance;
    for(final t in transactions){
      if(t.type == TransactionType.income){
        balance = balance + t.amount;
      }else{
        balance = balance - t.amount;
      }
    }
    return balance;
  }

  static double? calculateAverageDailySpending({
    required List<Transaction> transactions,
    required int windowDays,
    required DateTime asOf,
    required DateTime trackingStartDate,
  }) {
    final daysTracked = asOf.difference(trackingStartDate).inDays;
    final effectiveWindow = windowDays < daysTracked ? windowDays : daysTracked;

    if (effectiveWindow <= 0) return null;

    final windowStart = asOf.subtract(Duration(days: effectiveWindow));
    final expensesInWindow = transactions.where((t) =>
        t.type == TransactionType.expense &&
        t.date.isAfter(windowStart) &&
        !t.date.isAfter(asOf));

    if (expensesInWindow.isEmpty) return null;

    final total = expensesInWindow.fold<double>(0, (sum, t) => sum + t.amount);
    return total / effectiveWindow;
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

  static RunwaySnapshot calculateSnapshot({
    required Setting setting,
    required List<Transaction> transactions,
    required DateTime asOf,
  }){
    final balance = calculateBalance(
      initialBalance: setting.initialBalance,
     transactions: transactions
    );
    final avgDaily = calculateAverageDailySpending(
      transactions: transactions, 
      windowDays: setting.calculateWindowDays, asOf: asOf, 
      trackingStartDate: setting.trackingStartDate
    );
    final runway = calculateRunway(
      balance: balance, 
      averageDailySpending: avgDaily
    );
    return RunwaySnapshot(
      balance: balance,
      averageDailySpending: avgDaily,
      runwayDays: runway,
    );
  }
}