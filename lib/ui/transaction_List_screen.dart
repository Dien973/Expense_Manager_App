import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/expense.dart';
import '../models/income.dart';
import 'package:intl/intl.dart';
import 'add_income_screen.dart';
import 'add_expenses_screen.dart';

class TransactionListScreen extends StatelessWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final expenses = authProvider.expenses;
    final incomes = authProvider.incomes;

    // Sắp xếp giao dịch theo ngày (mới nhất trước)
    final transactions = [...expenses, ...incomes];
    transactions.sort((a, b) {
      final dateA = a is Expense ? a.date : (a as Income).date;
      final dateB = b is Expense ? b.date : (b as Income).date;
      return dateB.compareTo(dateA);
    });

    // Nhóm giao dịch theo tháng
    final Map<String, List<dynamic>> groupedTransactions = {};
    for (var transaction in transactions) {
      final isExpense = transaction is Expense;
      final date = isExpense ? transaction.date : (transaction as Income).date;
      final monthKey = DateFormat('MM/yyyy').format(date);

      if (!groupedTransactions.containsKey(monthKey)) {
        groupedTransactions[monthKey] = [];
      }
      groupedTransactions[monthKey]!.add(transaction);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý giao dịch')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddIncomeScreen()),
                    );
                  },
                  child: const Text("Thêm Thu Nhập",
                      style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddExpensesScreen()),
                    );
                  },
                  child: const Text("Thêm Chi Tiêu",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          Expanded(
            child: groupedTransactions.isEmpty
                ? const Center(child: Text("Chưa có giao dịch nào."))
                : CustomScrollView(
                    slivers: [
                      ...groupedTransactions.entries.map((entry) {
                        final month = entry.key;
                        final items = entry.value;

                        return SliverList(
                          delegate: SliverChildListDelegate([
                            Container(
                              color: Colors.blueGrey[100],
                              padding: const EdgeInsets.all(8),
                              child: Center(
                                child: Text(
                                  "Tháng $month",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            ...items.map((item) {
                              final isExpense = item is Expense;
                              final color =
                                  isExpense ? Colors.red : Colors.green;
                              final amountText = isExpense
                                  ? "- ${item.amount.toStringAsFixed(2)} VNĐ"
                                  : "+ ${(item as Income).inAmount.toStringAsFixed(2)} VNĐ";

                              final icon = isExpense
                                  ? Icons.shopping_cart
                                  : Icons.monetization_on;

                              return Card(
                                elevation: 3,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: ListTile(
                                  leading: Icon(icon, color: color),
                                  title: Text(
                                    isExpense
                                        ? item.name
                                        : (item as Income).source,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(DateFormat('dd/MM/yyyy')
                                      .format(isExpense
                                          ? item.date
                                          : (item as Income).date)),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(amountText,
                                          style: TextStyle(
                                              color: color,
                                              fontWeight: FontWeight.bold)),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.grey),
                                        onPressed: () {
                                          if (isExpense) {
                                            authProvider.deleteExpense(item.id);
                                          } else {
                                            authProvider.deleteIncome(
                                                (item as Income).id);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ]),
                        );
                      }).toList(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
