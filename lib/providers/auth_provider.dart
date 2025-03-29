// ignore_for_file: avoid_print, duplicate_ignore

// import 'dart:io';

import 'package:flutter/material.dart';
import '../services/pocketbase_service.dart';
import '../models/user.dart';
import '../models/expense.dart';
import '../models/income.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  final PocketbaseService _pocketBaseService = PocketbaseService();
  User? _user;
  final List<Expense> _expenses = [];
  final List<Income> _incomes = [];

  static String? token; // Lưu token để gửi yêu cầu API

  User? get user => _user;
  List<Expense> get expenses => _expenses;
  List<Income> get incomes => _incomes;

  void setUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }

  // Future<void> updateUserAvatar(String avatar) async {
  //   if (_user != null) {
  //     _user!.avatar = avatar;
  //     notifyListeners();
  //     final avatarFile = File(avatar);
  //     await PocketbaseService().uploadUserAvatar(_user!.id, avatarFile);
  //   }
  // }

  // 📌 Đăng ký
  Future<bool> register(String email, String password, String username) async {
    try {
      final userData =
          await _pocketBaseService.registerUser(email, password, username);
      if (userData != null && userData['id'] != null) {
        _user = User(
            id: userData['id'],
            email: userData['email'],
            username: userData['username']);
        print("✅ User registered: ${_user!.email}");
        await fetchExpenses();
        await fetchIncomes();
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('❌ Register Error: $e');
    }
    return false;
  }

  // 📌 Đăng nhập
  Future<bool> login(String email, String password) async {
    try {
      final userData = await _pocketBaseService.login(email, password);
      if (userData != null && userData['id'] != null) {
        _user = User(
            id: userData['id'],
            email: userData['email'],
            username: userData['username']);
        print("✅ User logged in: ${_user!.email}");

        await Future.wait([
          fetchExpenses(),
          fetchIncomes(),
        ]);

        notifyListeners();
        return true;
      }
    } catch (e) {
      print('❌ Login Error: $e');
    }
    return false;
  }

  final _storage = FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // 📌 Đăng xuất
  void logout() {
    try {
      _pocketBaseService.logout();
      _user = null;
      _expenses.clear();
      _incomes.clear();
      print("✅ User logged out");
      notifyListeners();
    } catch (e) {
      print('❌ Logout Error: $e');
    }
  }

  // ===================== 📌 CHI TIÊU (Expense) =====================

  // 📌 Thêm chi tiêu mới
  Future<void> addExpense(String name, double amount) async {
    if (_user == null || _user!.id.isEmpty) {
      print("❌ Lỗi: Người dùng chưa đăng nhập!");
      throw Exception("Người dùng chưa đăng nhập!");
    }

    final newExpense = Expense(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(), // Sử dụng số mili giây để tạo id ngắn hơn
      userId: _user!.id,
      amount: amount,
      name: name,
      date: DateTime.now(),
    );

    try {
      await _pocketBaseService.addExpense(newExpense); // Kiểm tra API ở đây
      _expenses.add(newExpense);
      print("✅ Đã thêm chi tiêu: ${newExpense.name} - ${newExpense.amount}");
      notifyListeners();
    } catch (e) {
      print("❌ Lỗi khi thêm chi tiêu: $e");
      throw Exception("Không thể thêm chi tiêu. Lỗi: $e");
    }
  }

  // 📌 Xóa chi tiêu
  Future<void> deleteExpense(String id) async {
    try {
      await _pocketBaseService.deleteExpense(id);
      _expenses.removeWhere((expense) => expense.id == id);
      print("✅ Đã xóa chi tiêu: $id");
      notifyListeners();
    } catch (e) {
      print("❌ Lỗi khi xóa chi tiêu: $e");
    }
  }

  // 📌 Lấy danh sách chi tiêu
  Future<void> fetchExpenses() async {
    if (_user == null || _user!.id.isEmpty) {
      print("❌ Lỗi: Người dùng chưa đăng nhập!");
      return;
    }

    print("🔍 Đang tải danh sách chi tiêu của user: ${_user!.id}");

    try {
      final fetchedExpenses = await _pocketBaseService.getExpenses(_user!.id);
      print("✅ Đã tải danh sách chi tiêu: ${fetchedExpenses.length} khoản");

      _expenses.clear();
      _expenses.addAll(fetchedExpenses);
      notifyListeners();

      for (var exp in fetchedExpenses) {
        print("💰 ${exp.name} - ${exp.amount}");
      }
    } catch (e) {
      print("❌ Lỗi khi tải danh sách chi tiêu: $e");
    }
  }

  // ===================== 📌 THU NHẬP (Income) =====================

  // 📌 Thêm thu nhập mới
  Future<void> addIncome(String source, double inAmount) async {
    if (_user == null || _user!.id.isEmpty) {
      print("❌ Lỗi: Người dùng chưa đăng nhập!");
      throw Exception("Người dùng chưa đăng nhập!");
    }

    final newIncome = Income(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(), // Sử dụng số mili giây để tạo id ngắn hơn
      userId: _user!.id,
      inAmount: inAmount,
      source: source,
      date: DateTime.now(), // Add the required date parameter
    );

    try {
      await _pocketBaseService.addIncome(newIncome); // Kiểm tra API ở đây
      _incomes.add(newIncome);
      print("✅ Đã thêm thu nhập: ${newIncome.source} - ${newIncome.inAmount}");
      notifyListeners();
    } catch (e) {
      print("❌ Lỗi khi thêm thu nhập: $e");
      throw Exception("Không thể thêm thu nhập. Lỗi: $e");
    }
  }

  // 📌 Xóa thu nhập
  Future<void> deleteIncome(String id) async {
    try {
      await _pocketBaseService.deleteIncome(id);
      _incomes.removeWhere((income) => income.id == id);
      print("✅ Đã xóa thu nhập: $id");
      notifyListeners();
    } catch (e) {
      print("❌ Lỗi khi xóa thu nhập: $e");
    }
  }

  // 📌 Lấy danh sách thu nhập
  Future<void> fetchIncomes() async {
    if (_user == null || _user!.id.isEmpty) {
      print("❌ Lỗi: Người dùng chưa đăng nhập!");
      return;
    }

    print("🔍 Đang tải danh sách thu nhập của user: ${_user!.id}");

    try {
      final fetchedIncomes = await _pocketBaseService.getIncomes(_user!.id);
      print("✅ Đã tải danh sách thu nhập: ${fetchedIncomes.length} khoản");

      _incomes.clear();
      _incomes.addAll(fetchedIncomes);
      notifyListeners();

      for (var exp in fetchedIncomes) {
        print("💰 ${exp.source} - ${exp.inAmount}");
      }
    } catch (e) {
      print("❌ Lỗi khi tải danh sách thu nhập: $e");
    }
  }
}
