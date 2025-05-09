import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService with ChangeNotifier {
  User? _currentUser;
  static List<User> _users = [
    User(username: 'Nghia', password: '123456'),
  ];
  bool _isDarkMode = false;

  AuthService() {
    _loadUser();
  }

  User? get currentUser => _currentUser;
  bool get isDarkMode => _isDarkMode;

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('currentUser');
    final usersData = prefs.getString('users');
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;

    if (usersData != null) {
      final List<dynamic> usersJson = jsonDecode(usersData);
      _users = usersJson.map((json) => User.fromJson(json)).toList();
    }

    if (userData != null) {
      _currentUser = User.fromJson(jsonDecode(userData));
      final userIndex = _users.indexWhere((u) => u.username == _currentUser!.username);
      if (userIndex != -1) {
        _currentUser = _users[userIndex];
      }
      notifyListeners();
    }
  }

  Future<bool> register(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (_users.any((user) => user.username == username)) return false;

    final newUser = User(username: username, password: password);
    _users.add(newUser);
    await prefs.setString('users', jsonEncode(_users.map((u) => u.toJson()).toList()));
    notifyListeners();
    return true;
  }

  Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final userIndex = _users.indexWhere((u) => u.username == username && u.password == password);
    if (userIndex != -1) {
      _currentUser = User(
        username: _users[userIndex].username,
        password: _users[userIndex].password,
        favorites: List.from(_users[userIndex].favorites),
        history: List.from(_users[userIndex].history),
      );
      await prefs.setString('currentUser', jsonEncode(_currentUser!.toJson()));
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    if (_currentUser != null) {
      final userIndex = _users.indexWhere((u) => u.username == _currentUser!.username);
      if (userIndex != -1) {
        _users[userIndex] = _currentUser!;
        await prefs.setString('users', jsonEncode(_users.map((u) => u.toJson()).toList()));
      }
    }
    _currentUser = null;
    await prefs.remove('currentUser');
    notifyListeners();
  }

  Future<void> toggleFavorite(String spotName) async {
    final prefs = await SharedPreferences.getInstance();
    if (_currentUser != null) {
      if (_currentUser!.favorites.contains(spotName)) {
        _currentUser!.favorites.remove(spotName);
      } else {
        _currentUser!.favorites.add(spotName);
      }
      final userIndex = _users.indexWhere((u) => u.username == _currentUser!.username);
      if (userIndex != -1) {
        _users[userIndex] = _currentUser!;
        await prefs.setString('users', jsonEncode(_users.map((u) => u.toJson()).toList()));
      }
      await prefs.setString('currentUser', jsonEncode(_currentUser!.toJson()));
      notifyListeners();
    }
  }

  List<String> getFavorites() {
    return _currentUser?.favorites ?? [];
  }

  Future<void> addToHistory(String spotName) async {
    final prefs = await SharedPreferences.getInstance();
    if (_currentUser != null) {
      if (!_currentUser!.history.contains(spotName)) {
        _currentUser!.history.insert(0, spotName);
        if (_currentUser!.history.length > 10) _currentUser!.history.removeLast();
      } else {
        _currentUser!.history.remove(spotName);
        _currentUser!.history.insert(0, spotName);
      }
      final userIndex = _users.indexWhere((u) => u.username == _currentUser!.username);
      if (userIndex != -1) {
        _users[userIndex] = _currentUser!;
        await prefs.setString('users', jsonEncode(_users.map((u) => u.toJson()).toList()));
      }
      await prefs.setString('currentUser', jsonEncode(_currentUser!.toJson()));
      notifyListeners();
    }
  }

  List<String> getHistory() {
    return _currentUser?.history ?? [];
  }

  // Thêm phương thức để xóa toàn bộ lịch sử
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    if (_currentUser != null) {
      _currentUser!.history.clear(); // Xóa toàn bộ lịch sử
      final userIndex = _users.indexWhere((u) => u.username == _currentUser!.username);
      if (userIndex != -1) {
        _users[userIndex] = _currentUser!;
        await prefs.setString('users', jsonEncode(_users.map((u) => u.toJson()).toList()));
      }
      await prefs.setString('currentUser', jsonEncode(_currentUser!.toJson()));
      notifyListeners();
    }
  }

  void toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = value;
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }
}