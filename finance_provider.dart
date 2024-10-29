import 'package:flutter/foundation.dart';
import '../models/transaction.dart';
import '../models/budget.dart';
import '../models/goal.dart';

class FinanceProvider with ChangeNotifier {
  List<Transaction> transactions = [];
  List<Budget> budgets = [];
  List<Goal> goals = [];

  // Calculate total income, expenses, and balance
  double get totalIncome => transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0, (sum, t) => sum + t.amount);

  double get totalExpenses => transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0, (sum, t) => sum + t.amount);

  double get totalBalance => totalIncome - totalExpenses;

  
  void addTransaction(Transaction transaction) {
    transactions.add(transaction);
    notifyListeners();
  }

  
  void addBudget(Budget budget) {
    budgets.add(budget);
    notifyListeners();
  }

  void editBudget(int index, Budget updatedBudget) {
    budgets[index] = updatedBudget;
    notifyListeners();
  }

  
  void addGoal(Goal goal) {
    goals.add(goal);
    notifyListeners();
  }

  void editGoal(int index, Goal updatedGoal) {
    goals[index] = updatedGoal;
    notifyListeners();
  }
}
