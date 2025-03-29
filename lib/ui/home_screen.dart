import 'transaction_List_screen.dart';
import 'package:flutter/material.dart';
import 'analysis_screen.dart';
import 'account_screen.dart';
// import 'add_expenses_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    // ExpenseListScreen(), // Màn hình danh sách chi tiêu
    // AddExpensesScreen(),
    TransactionListScreen(),
    // Container(), // Placeholder cho nút "+", không cần màn hình thực tế
    AnalysisScreen(), // Màn hình phân tích
    AccountScreen(), // Màn hình hồ sơ
  ];

  void _onItemTapped(int index) {
    // if (index == 2) {
    //   // Chuyển sang màn hình thêm giao dịch
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => AddTransaction()),
    //   );
    //   return;
    // }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.calendar_today), label: 'Chi tiết'),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.add_circle, size: 40), label: ''), // Nút "+"
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Báo cáo'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Hồ sơ'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
