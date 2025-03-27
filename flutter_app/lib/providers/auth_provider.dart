import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _token;
  String? _error;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;
  String? get error => _error;

  final _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:9000/api',
    contentType: 'application/json',
  ));

  Future<bool> login(String username, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _dio.post('/users/login', data: {
        'username': username,
        'password': password,
      });

      if (response.data['code'] == 200) {
        final userData = response.data['data'];
        _token = userData['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.data['message'] ?? '登录失败';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = '网络错误，请稍后重试';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String username, String password, String email) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _dio.post('/users/register', data: {
        'username': username,
        'password': password,
        'email': email,
      });

      if (response.data['code'] == 200) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.data['message'] ?? '注册失败';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = '网络错误，请稍后重试';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    notifyListeners();
  }
}
