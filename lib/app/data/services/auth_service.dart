import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService extends GetxService {
  // Storage key for user data
  static const String USER_STORAGE_KEY = 'user_data';

  // Observable user state
  final _currentUser = Rxn<User?>();

  // Shared Preferences instance
  late SharedPreferences _prefs;

  // Getters for user information
  User? get currentUser => _currentUser.value;
  bool get isLoggedIn => _currentUser.value != null;
  String get userRole => _currentUser.value?.role ?? '';

  @override
  void onInit() {
    super.onInit();
    // Initialize by loading user data from SharedPreferences
    _initPrefs();
  }

  // Initialize SharedPreferences and load user data
  Future<void> _initPrefs() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _loadUserFromStorage();
    } catch (e) {
      debugPrint('Failed to initialize SharedPreferences: $e');
    }
  }

  // Load user data from SharedPreferences
  void _loadUserFromStorage() {
    try {
      final String? userStr = _prefs.getString(USER_STORAGE_KEY);
      if (userStr != null && userStr.isNotEmpty) {
        final Map<String, dynamic> userData = jsonDecode(userStr) as Map<String, dynamic>;
        _currentUser.value = User.fromJson(userData);
        debugPrint('User loaded from SharedPreferences: ${_currentUser.value?.name}');
      }
    } catch (e) {
      debugPrint('Error loading user data from SharedPreferences: $e');
      // If there's an error, clear potentially corrupted data
      _prefs.remove(USER_STORAGE_KEY);
    }
  }

  // Mock login function that would normally connect to an API
  Future<bool> login(String username, String password, String role) async {
    try {
      // Simulate API call with delay
      await Future.delayed(const Duration(seconds: 1));

      // In a real app, you would validate credentials against an API
      // This is just a mock implementation
      if (username.isNotEmpty && password.isNotEmpty) {
        // Create a mock user based on the selected role
        final user = User(
          id: '12345',
          name: _getUserNameForRole(role),
          email: username,
          role: role,
          branchId: '1',
          branchName: 'Kedai Dandang Gula MT. Haryono',
        );

        // Save to SharedPreferences
        await _saveUserToStorage(user);

        // Update current user
        _currentUser.value = user;

        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  // Save user data to SharedPreferences
  Future<void> _saveUserToStorage(User user) async {
    try {
      final String userJson = jsonEncode(user.toJson());
      await _prefs.setString(USER_STORAGE_KEY, userJson);
      debugPrint('User saved to SharedPreferences');
    } catch (e) {
      debugPrint('Error saving user to SharedPreferences: $e');
      throw Exception('Failed to save user data: $e');
    }
  }

  // Helper function to get user name based on role
  String _getUserNameForRole(String role) {
    switch (role) {
      case 'admin':
        return 'Joe Heiden';
      case 'pusat':
        return 'Martha Elbert';
      case 'kasir':
        return 'Jun Aizawa';
      case 'gudang':
        return 'Martha Elbert';
      case 'branchmanager':
        return 'Joe Heiden';
      default:
        return 'User';
    }
  }

  // Log out the current user
  Future<void> logout() async {
    try {
      // Remove user data from SharedPreferences
      await _prefs.remove(USER_STORAGE_KEY);
      // Clear current user
      _currentUser.value = null;
      // Navigate to login screen
      Get.offAllNamed('/login');
      debugPrint('User logged out successfully');
    } catch (e) {
      debugPrint('Error during logout: $e');
      throw Exception('Failed to log out: $e');
    }
  }
}
