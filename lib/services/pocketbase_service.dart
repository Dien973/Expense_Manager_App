import 'dart:io';

import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;
import '../models/expense.dart';
import '../models/income.dart';

class PocketbaseService {
  final PocketBase _pocketBase = PocketBase('http://127.0.0.1:8090');
  String? _authToken;

  Future<String?> uploadUserAvatar(String userId, File image) async {
    try {
      final formData = <String, dynamic>{
        'avatar': await http.MultipartFile.fromPath('avatar', image.path),
      };

      final response = await _pocketBase
          .collection('users')
          .update(userId, body: {}, files: [formData['avatar']]);

      final avatarFilename = response.data['avatar'];

      return avatarFilename != null
          ? 'http://127.0.0.1:8090/api/files/users/$userId/$avatarFilename'
          : null;
    } catch (e) {
      print('❌ Lỗi tải ảnh lên PocketBase: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final authData = await _pocketBase
          .collection('users')
          .authWithPassword(email, password);
      return authData.record.toJson();
    } catch (e) {
      print("❌ Login Error: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> registerUser(
    String email,
    String password,
    String username,
    /*String avatar*/
  ) async {
    try {
      final record = await _pocketBase.collection('users').create(body: {
        "username": username,
        "email": email,
        "password": password,
        "passwordConfirm": password,
        // "avatar": avatar ?? "defaultavatar.jpg",
      });
      print("📌 Phản hồi từ PocketBase: ${record.toJson()}");
      return record.toJson();
    } catch (e) {
      print("❌ Register Error: $e");
      return null;
    }
  }

  // Đăng xuất và xóa token
  void logout() {
    _pocketBase.authStore.clear();
    print("✅ Đã đăng xuất");
  }

  String? get authToken => _authToken;

  // ───────────────────────────────────────────────────────────
  // 💰 EXPENSES (Chi tiêu)
  // ───────────────────────────────────────────────────────────

  Future<void> addExpense(Expense expense) async {
    try {
      await _pocketBase.collection('expenses').create(body: expense.toJson());
      print("✅ Đã thêm chi tiêu: ${expense.name} - ${expense.amount}");
    } catch (e) {
      print("❌ Lỗi khi thêm chi tiêu: $e");
    }
  }

  Future<List<Expense>> getExpenses(String userId) async {
    try {
      // Kiểm tra giá trị của userId
      if (userId.isEmpty) {
        throw Exception("User ID không hợp lệ.");
      }

      // Kiểm tra cú pháp của bộ lọc
      final filter = 'userId="$userId"';
      if (!RegExp(r'^userId="[^"]+"$').hasMatch(filter)) {
        throw Exception("Bộ lọc không hợp lệ.");
      }

      final records = await _pocketBase.collection('expenses').getFullList(
            filter: 'userId="$userId"',
            sort: '-date',
          );

      return records.map((record) => Expense.fromJson(record.data)).toList();
    } catch (e) {
      if (e is ClientException) {
        if (e.statusCode == 403) {
          print(
              "❌ Lỗi khi tải danh sách chi tiêu: Chỉ superusers mới có thể thực hiện hành động này.");
        } else if (e.statusCode == 400) {
          print(
              "❌ Lỗi khi tải danh sách chi tiêu: Yêu cầu không hợp lệ. Vui lòng kiểm tra lại các tham số.");
        } else {
          print("❌ Lỗi khi tải danh sách chi tiêu: $e");
        }
      } else {
        print("❌ Lỗi khi tải danh sách chi tiêu: $e");
      }
      return [];
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      await _pocketBase.collection('expenses').delete(id);
      print("✅ Đã xóa chi tiêu: $id");
    } catch (e) {
      print("❌ Lỗi khi xóa chi tiêu: $e");
    }
  }

  // ───────────────────────────────────────────────────────────
  // 💵 INCOME (Thu nhập)
  // ───────────────────────────────────────────────────────────

  Future<void> addIncome(Income income) async {
    try {
      await _pocketBase.collection('incomes').create(body: income.toJson());
      print("✅ Thu nhập đã được thêm: ${income.source} - ${income.inAmount}");
    } catch (e) {
      print("❌ Lỗi khi thêm thu nhập: $e");
    }
  }

  Future<List<Income>> getIncomes(String userId) async {
    try {
      // Kiểm tra giá trị của userId
      if (userId.isEmpty) {
        throw Exception("User ID không hợp lệ.");
      }

      // Kiểm tra cú pháp của bộ lọc
      final filter = 'userId="$userId"';
      if (!RegExp(r'^userId="[^"]+"$').hasMatch(filter)) {
        throw Exception("Bộ lọc không hợp lệ.");
      }

      final records = await _pocketBase.collection('incomes').getFullList(
            filter: filter,
            sort: '-date',
          );

      return records.map((record) => Income.fromJson(record.data)).toList();
    } catch (e) {
      if (e is ClientException) {
        if (e.statusCode == 403) {
          print(
              "❌ Lỗi khi tải danh sách thu nhập: Chỉ superusers mới có thể thực hiện hành động này.");
        } else if (e.statusCode == 400) {
          print(
              "❌ Lỗi khi tải danh sách thu nhập: Yêu cầu không hợp lệ. Vui lòng kiểm tra lại các tham số.");
        } else {
          print("❌ Lỗi khi tải danh sách thu nhập: $e");
        }
      } else {
        print("❌ Lỗi khi tải danh sách thu nhập: $e");
      }
      return [];
    }
  }

  Future<void> deleteIncome(String id) async {
    try {
      await _pocketBase.collection('incomes').delete(id);
      print("✅ Đã xóa thu nhập: $id");
    } catch (e) {
      print("❌ Lỗi khi xóa thu nhập: $e");
    }
  }
}
