import 'package:micro_budgeting/domain/entities/transaction.dart';
import 'package:micro_budgeting/domain/usecases/runway_calculator.dart';

void main() {
  print('=== TEST 1: Spec example (expect 11 days) ===');
  testSpecExample();

  print('');
  print('=== TEST 2: Empty transaction list (expect null, no crash) ===');
  testEmptyList();
}

void testSpecExample() {
  const initialBalance = 22000.0;

  final now = DateTime(2024, 6, 30);

  final transactions = <Transaction>[
    Transaction(
      id: '1',
      type: TransactionType.expense,
      amount: 10000,
      date: now.subtract(const Duration(days: 2)),
      category: 'Rent',
    ),
    Transaction(
      id: '2',
      type: TransactionType.expense,
      amount: 8000,
      date: now.subtract(const Duration(days: 5)),
      category: 'Food',
    ),
    Transaction(
      id: '3',
      type: TransactionType.expense,
      amount: 6000,
      date: now.subtract(const Duration(days: 9)),
      category: 'Transport',
    ),
    Transaction(
      id: '4',
      type: TransactionType.expense,
      amount: 4000,
      date: now.subtract(const Duration(days: 12)),
      category: 'Bills',
    ),
    // Total = 28000 over 14 days = 2000/day ✅
  ];

  final balance = RunwayCalculator.calculateBalance(
    initialBalance: initialBalance,
    transactions: transactions,
  );

  final avgDaily = RunwayCalculator.calculateAverageDailySpending(
    transactions: transactions,
    windowDays: 14,
    asOf: now,
  );

  final runway = RunwayCalculator.calculateRunway(
    balance: balance,
    averageDailySpending: avgDaily,
  );

  print('Balance:              Rs. $balance');
  print('Avg daily spending:   Rs. $avgDaily/day');
  print('Runway:               $runway days');
}

void testEmptyList() {
  const initialBalance = 50000.0;
  final now = DateTime(2024, 6, 30);
  final transactions = <Transaction>[]; 
//fv
  final balance = RunwayCalculator.calculateBalance(
    initialBalance: initialBalance,
    transactions: transactions,
  );

  final avgDaily = RunwayCalculator.calculateAverageDailySpending(
    transactions: transactions,
    windowDays: 14,
    asOf: now,
  );

  final runway = RunwayCalculator.calculateRunway(
    balance: balance,
    averageDailySpending: avgDaily,
  );

  print('Balance:              Rs. $balance');
  print('Avg daily spending:   $avgDaily  (null = unknown)');
  print('Runway:               $runway  (null = unknown)');

  // Sanity checks — these should NOT throw
  assert(avgDaily == null, 'Expected null spending');
  assert(runway == null, 'Expected null runway');
  print('✅ No crash. nulls returned as designed.');
}