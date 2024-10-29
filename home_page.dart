import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';
import 'transaction_page.dart';
import 'budget_page.dart';
import 'savings_page.dart';
import 'reports_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FinanceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Tracker'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBalanceCard(provider.totalBalance),
            const SizedBox(height: 20),
            _buildSummaryCard(provider),
            const SizedBox(height: 20),
            _buildNavigationButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(double balance) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Current Balance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '\$${balance.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: balance >= 0 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(FinanceProvider provider) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _summaryRow('Total Income', provider.totalIncome, Colors.green),
            const SizedBox(height: 10),
            _summaryRow('Total Expenses', provider.totalExpenses, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, double value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 18)),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Column(
      children: [
        _buildButton(context, 'Manage Transactions', Icons.swap_horiz, const TransactionPage()),
        const SizedBox(height: 10),
        _buildButton(context, 'Manage Budgets', Icons.pie_chart_outline, const BudgetPage()),
        const SizedBox(height: 10),
        _buildButton(context, 'Savings Goals', Icons.savings, const SavingsPage()),
        const SizedBox(height: 10),
        _buildButton(context, 'View Reports', Icons.bar_chart, const ReportsPage()),
      ],
    );
  }

  Widget _buildButton(BuildContext context, String label, IconData icon, Widget page) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(icon),
      label: Text(label, style: const TextStyle(fontSize: 18)),
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
    );
  }
}
