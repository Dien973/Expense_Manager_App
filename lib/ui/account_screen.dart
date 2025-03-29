// import 'dart:io';

import '../ui/add_expenses_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:image_picker/image_picker.dart';
import '../providers/auth_provider.dart';
import 'add_income_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // final ImagePicker _picker = ImagePicker();

  // Future<void> _pickImage(BuildContext context) async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     File imageFile = File(pickedFile.path);
  //     Provider.of<AuthProvider>(context, listen: false)
  //         .updateUserAvatar(imageFile.path);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).fetchIncomes();
    Provider.of<AuthProvider>(context, listen: false).fetchExpenses();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final incomes = authProvider.incomes;
    final expenses = authProvider.expenses;

    //Tính tổng thu nhập
    double totalIncome =
        incomes.fold(0, (sum, income) => sum + income.inAmount);

    //Tính tổng chi tiêu
    double totalExpense =
        expenses.fold(0, (sum, expense) => sum + expense.amount);

    //Tính số dư
    double balance = totalIncome - totalExpense;

    return Scaffold(
      appBar: AppBar(title: Text('Hồ sơ cá nhân')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // GestureDetector(
            //   onTap: () => _pickImage(context),
            //   child: CircleAvatar(
            //     radius: 50,
            //     backgroundImage:
            //         user?.avatar != null ? NetworkImage(user!.avatar!) : null,
            //     child: user?.avatar == null
            //         ? Icon(Icons.camera_alt, size: 40, color: Colors.grey)
            //         : null,
            //   ),
            // ),
            SizedBox(height: 10),

            // Thông tin người dùng
            Text(
              user?.username ?? 'Chưa có tên người dùng',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              user?.email ?? 'Chưa có email',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),

            // Hiển thị số dư + nút thêm chi tiêu
            Card(
              elevation: 4,
              color: Colors.green.shade100,
              child: ListTile(
                title: Text('Số dư hiện tại'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${balance.toStringAsFixed(2)} VNĐ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            // Hiển thị tổng thu nhập + nút thêm thu nhập
            Card(
              elevation: 4,
              color: Colors.green.shade100,
              child: ListTile(
                title: Text('Tổng thu nhập'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 20),
                    Text(
                      '${totalIncome.toStringAsFixed(2)} VNĐ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      icon:
                          Icon(Icons.add_circle, color: Colors.green, size: 28),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AddIncomeScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),

            Card(
              elevation: 4,
              color: Colors.green.shade100,
              child: ListTile(
                title: Text('Tổng chi tiêu'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${totalExpense.toStringAsFixed(2)} VNĐ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      icon:
                          Icon(Icons.add_circle, color: Colors.green, size: 28),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AddExpensesScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Nút đăng xuất
            ElevatedButton(
              onPressed: () {
                authProvider.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Đăng xuất', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
