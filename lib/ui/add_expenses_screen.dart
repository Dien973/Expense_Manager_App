import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AddExpensesScreen extends StatefulWidget {
  const AddExpensesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddExpensesScreenState createState() => _AddExpensesScreenState();
}

class _AddExpensesScreenState extends State<AddExpensesScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  bool _isLoading = false; // Thêm biến kiểm soát trạng thái

  void _saveExpenses() async {
    final name = _nameController.text.trim();
    final amount = double.tryParse(_amountController.text) ?? 0;

    if (name.isEmpty || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập thông tin hợp lệ!')),
      );
      return;
    }

    Provider.of<AuthProvider>(context, listen: false)
        .addExpense(name, amount)
        .then((_) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }); // Điều hướng đến trang danh sách chi tiêu
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thêm chi tiêu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Chi'),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Số tiền'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : _saveExpenses, // Không thể nhấn khi đang xử lý
              child: _isLoading
                  ? CircularProgressIndicator() // Hiển thị loading
                  : Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }
}
