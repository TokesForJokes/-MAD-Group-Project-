import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';
import '../models/goal.dart';

class SavingsPage extends StatelessWidget {
  const SavingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FinanceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Savings Goals'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Current Savings Goals',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildSavingsList(provider),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _showAddGoalDialog(context, provider),
              icon: const Icon(Icons.add),
              label: const Text('Add New Goal'),
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

  Widget _buildSavingsList(FinanceProvider provider) {
    if (provider.goals.isEmpty) {
      return const Center(
        child: Text(
          'No savings goals available. Please add one!',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: provider.goals.length,
        itemBuilder: (context, index) {
          final goal = provider.goals[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(goal.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  LinearProgressIndicator(
                    value: goal.currentAmount / goal.targetAmount,
                    minHeight: 8,
                    color: goal.currentAmount >= goal.targetAmount
                        ? Colors.green
                        : Colors.blue,
                    backgroundColor: Colors.grey[300],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${goal.currentAmount.toStringAsFixed(2)} / \$${goal.targetAmount.toStringAsFixed(2)}',
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
                        _showAddMoneyDialog(context, provider, index, goal),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () =>
                        _showEditGoalDialog(context, provider, index, goal),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context, FinanceProvider provider) {
    final nameController = TextEditingController();
    final targetController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Goal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Goal Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: targetController,
                decoration: const InputDecoration(labelText: 'Target Amount'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final newGoal = Goal(
                  name: nameController.text,
                  targetAmount: double.parse(targetController.text),
                  currentAmount: 0,
                );
                provider.addGoal(newGoal);
                Navigator.pop(context);
              },
              child: const Text('Add Goal'),
            ),
          ],
        );
      },
    );
  }

  void _showEditGoalDialog(
      BuildContext context, FinanceProvider provider, int index, Goal goal) {
    final nameController = TextEditingController(text: goal.name);
    final targetController =
        TextEditingController(text: goal.targetAmount.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Goal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Goal Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: targetController,
                decoration: const InputDecoration(labelText: 'Target Amount'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final updatedGoal = Goal(
                  name: nameController.text,
                  targetAmount: double.parse(targetController.text),
                  currentAmount: goal.currentAmount,
                );
                provider.editGoal(index, updatedGoal);
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
      BuildContext context, FinanceProvider provider, int index, Goal goal) {
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Money to Goal'),
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

                final updatedGoal = Goal(
                  name: goal.name,
                  targetAmount: goal.targetAmount,
                  currentAmount: goal.currentAmount + amount,
                );
                provider.editGoal(index, updatedGoal);
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
