import 'package:micro_budgeting/domain/entities/transaction.dart';

class TransactionStore {
  final List <Transaction> _transactions = [];
  List <Transaction> getAll() => _transactions;

  void add(Transaction transaction){
    _transactions.add(transaction);
  }
}