import 'ui/transaction_list_screen.dart';

import 'ui/account_Screen.dart';
import 'ui/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: library_prefixes
import 'providers/auth_provider.dart'
    as authProvider; // Dùng alias để tránh xung đột
import 'ui/login_screen.dart';
import 'ui/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => authProvider.AuthProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense Management',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginPage(),
          '/signup': (context) => RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/account': (context) => AccountScreen(),
          '/transactions': (context) => TransactionListScreen(),
        },
      ),
    );
  }
}
