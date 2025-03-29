import 'package:ct312h_project/models/income.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/auth_provider.dart';
import '../models/expense.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final expenses = authProvider.expenses;
    final incomes = authProvider.incomes;

    //Tính tổng thu nhập
    double totalIncome =
        incomes.fold(0, (sum, income) => sum + income.inAmount);

    //Tính tổng chi tiêu
    double totalExpense =
        expenses.fold(0, (sum, expense) => sum + expense.amount);

    //Tính số dư
    double balance = totalIncome - totalExpense;
    double weeklyExpenses = calculateExpenses(expenses, 'week');
    double monthlyExpenses = calculateExpenses(expenses, 'month');
    double yearlyExpenses = calculateExpenses(expenses, 'year');

    double weeklyIncomes = calculateIncomes(incomes, 'week');
    double monthlyIncomes = calculateIncomes(incomes, 'month');
    double yearlyIncomes = calculateIncomes(incomes, 'year');

    return Scaffold(
      appBar: AppBar(title: Text('Phân tích chi tiêu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tổng số dư
            Card(
              color: Colors.blueAccent,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "💰 Số dư hiện tại",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "${balance.toStringAsFixed(2)} VNĐ",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),

            // Chi tiêu theo tuần, tháng, năm
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildCard("📅 Chi tiêu Tuần", weeklyExpenses),
                buildCard("📆 Chi tiêu Tháng", monthlyExpenses),
                buildCard("📊 Chi tiêu Năm", yearlyExpenses),
              ],
            ),
            SizedBox(height: 20),

            // Thu nhập theo tuần, tháng, năm
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildCard("📅 Thu nhập Tuần", weeklyIncomes),
                buildCard("📆 Thu nhập Tháng", monthlyIncomes),
                buildCard("📊 Thu nhập Năm", yearlyIncomes),
              ],
            ),
            SizedBox(height: 20),

            // Biểu đồ chi tiêu
            Expanded(
              child: BarChart(
                BarChartData(
                  barGroups: getBarGroups(
                      weeklyExpenses, monthlyExpenses, yearlyExpenses),
                  titlesData: FlTitlesData(
                    leftTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: true)),
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 0:
                            return Text('Tuần');
                          case 1:
                            return Text('Tháng');
                          case 2:
                            return Text('Năm');
                          default:
                            return Text('');
                        }
                      },
                    )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm tính tổng số dư
  double calculateTotalBalance(List<Expense> expenses) {
    return expenses.fold(0, (sum, exp) => sum + exp.amount);
  }

  // Hàm tính tổng chi tiêu theo khoảng thời gian
  double calculateExpenses(List<Expense> expenses, String type) {
    DateTime now = DateTime.now();
    return expenses.where((exp) {
      switch (type) {
        case 'week':
          return exp.date.isAfter(now.subtract(Duration(days: 7)));
        case 'month':
          return exp.date.month == now.month && exp.date.year == now.year;
        case 'year':
          return exp.date.year == now.year;
        default:
          return false;
      }
    }).fold(0, (sum, exp) => sum + exp.amount);
  }

  // Hàm tính tổng chi tiêu theo khoảng thời gian
  double calculateIncomes(List<Income> incomes, String type) {
    DateTime now = DateTime.now();
    return incomes.where((exp) {
      switch (type) {
        case 'week':
          return exp.date.isAfter(now.subtract(Duration(days: 7)));
        case 'month':
          return exp.date.month == now.month && exp.date.year == now.year;
        case 'year':
          return exp.date.year == now.year;
        default:
          return false;
      }
    }).fold(0, (sum, exp) => sum + exp.inAmount);
  }

  // Hàm tạo thẻ hiển thị
  Widget buildCard(String title, double amount) {
    return Card(
      color: Colors.orangeAccent,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(title,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 5),
            Text("${amount.toStringAsFixed(2)} VNĐ",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ],
        ),
      ),
    );
  }

  // Hàm tạo dữ liệu biểu đồ
  List<BarChartGroupData> getBarGroups(double week, double month, double year) {
    return [
      BarChartGroupData(
          x: 0,
          barRods: [BarChartRodData(toY: week, color: Colors.blue, width: 20)]),
      BarChartGroupData(x: 1, barRods: [
        BarChartRodData(toY: month, color: Colors.green, width: 20)
      ]),
      BarChartGroupData(
          x: 2,
          barRods: [BarChartRodData(toY: year, color: Colors.red, width: 20)]),
    ];
  }
}
