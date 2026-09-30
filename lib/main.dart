import 'package:flutter/material.dart';
import 'package:micro_budgeting/data/transaction_store.dart';
import 'package:micro_budgeting/domain/entities/setting.dart';
import 'package:micro_budgeting/domain/entities/transaction.dart';
import 'package:micro_budgeting/domain/usecases/runway_calculator.dart';
void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final trackingStartDate = now.subtract(Duration(days: 3));

    final store = TransactionStore();
      store.add(Transaction(id: '1', type: TransactionType.expense, amount: 500, date: now.subtract(const Duration(days: 4)), category: 'Food'));
      store.add(Transaction(id: '2', type: TransactionType.expense, amount: 300, date: now.subtract(const Duration(days: 2)), category: 'Transport'));

    final setting = Setting(initialBalance: 220000, currency: 'Npr', trackingStartDate: trackingStartDate, calculateWindowDays: 14);
    final snapShot = RunwayCalculator.calculateSnapshot(setting: setting, transactions: store.getAll(), asOf: now);
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('${snapShot.runwayDays} days of runway remaining'),
        ),
      ),
    );
  }
}