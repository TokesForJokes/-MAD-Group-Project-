import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';
import '../models/budget.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FinanceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Budgets'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Current Budgets',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildBudgetList(provider),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _showAddBudgetDialog(context, provider),
              icon: const Icon(Icons.add),
              label: const Text('Add New Budget'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetList(FinanceProvider provider) {
    if (provider.budgets.isEmpty) {
      return const Center(
        child: Text(
          'No budgets available. Please add one!',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: provider.budgets.length,
        itemBuilder: (context, index) {
          final budget = provider.budgets[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(budget.category),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  LinearProgressIndicator(
                    value: budget.spent / budget.limit,
                    minHeight: 8,
                    color: budget.spent >= budget.limit
                        ? Colors.red
                        : Colors.green,
                    backgroundColor: Colors.grey[300],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${budget.spent.toStringAsFixed(2)} / \$${budget.limit.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () =>
                        _showAddMoneyDialog(context, provider, index, budget),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () =>
                        _showEditBudgetDialog(context, provider, index, budget),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddBudgetDialog(BuildContext context, FinanceProvider provider) {
    final categoryController = TextEditingController();
    final limitController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Budget'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: limitController,
                decoration: const InputDecoration(labelText: 'Limit'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final newBudget = Budget(
                  category: categoryController.text,
                  limit: double.parse(limitController.text),
                  spent: 0,
                );
                provider.addBudget(newBudget);
                Navigator.pop(context);
              },
              child: const Text('Add Budget'),
            ),
          ],
        );
      },
    );
  }

  void _showEditBudgetDialog(
      BuildContext context, FinanceProvider provider, int index, Budget budget) {
    final categoryController = TextEditingController(text: budget.category);
    final limitController =
        TextEditingController(text: budget.limit.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Budget'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: limitController,
                decoration: const InputDecoration(labelText: 'Limit'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final updatedBudget = Budget(
                  category: categoryController.text,
                  limit: double.parse(limitController.text),
                  spent: budget.spent,
                );
                provider.editBudget(index, updatedBudget);
                Navigator.pop(context);
              },
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  void _showAddMoneyDialog(
      BuildContext context, FinanceProvider provider, int index, Budget budget) {
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Money to Budget'),
          content: TextField(
            controller: amountController,
            decoration: const InputDecoration(labelText: 'Amount to Add'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text) ?? 0;
                if (amount <= 0) return;

                final updatedBudget = Budget(
                  category: budget.category,
                  limit: budget.limit,
                  spent: budget.spent + amount,
                );
                provider.editBudget(index, updatedBudget);
                Navigator.pop(context);
              },
              child: const Text('Add Money'),
            ),
          ],
        );
      },
    );
  }
}
