import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddIncomeScreenState createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  void _saveIncome() {
    final source = _sourceController.text.trim();
    final amount = double.tryParse(_amountController.text) ?? 0;

    if (source.isEmpty || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập thông tin hợp lệ!')),
      );
      return;
    }

    Provider.of<AuthProvider>(context, listen: false)
        .addIncome(source, amount)
        .then((_) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thêm thu nhập')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _sourceController,
              decoration: InputDecoration(labelText: 'Nguồn thu nhập'),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Số tiền'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveIncome,
              child: Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }
}
