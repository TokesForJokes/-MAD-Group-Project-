import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/finance_provider.dart';
import '../models/transaction.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  TransactionType _selectedType = TransactionType.income; // Default to deposit

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FinanceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Transaction Details',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildTextField('Description', _descriptionController),
            const SizedBox(height: 16),
            _buildTextField('Amount', _amountController,
                inputType: TextInputType.number),
            const SizedBox(height: 16),
            _buildTransactionTypeSelector(),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  final double amount =
                      double.tryParse(_amountController.text) ?? 0.0;
                  final String description = _descriptionController.text;

                  if (description.isEmpty || amount <= 0) {
                    _showErrorDialog(context, 'Please enter valid data.');
                    return;
                  }

                  provider.addTransaction(Transaction(
                    description: description,
                    amount: amount,
                    type: _selectedType,
                    date: DateTime.now(),
                  ));
                  Navigator.pop(context);
                },
                child: const Text(
                  'Add Transaction',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType inputType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildTransactionTypeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Transaction Type:',
          style: TextStyle(fontSize: 18),
        ),
        DropdownButton<TransactionType>(
          value: _selectedType,
          items: const [
            DropdownMenuItem(
              value: TransactionType.income,
              child: Text('Deposit'),
            ),
            DropdownMenuItem(
              value: TransactionType.expense,
              child: Text('Withdrawal'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedType = value!;
            });
          },
        ),
      ],
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
