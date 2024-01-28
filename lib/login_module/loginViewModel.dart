import 'package:flutter/foundation.dart';
import 'package:paraleloapp1/data/data_repository.dart';

class LoginViewModel {
  final DataRepository repository;

  bool isLoading = false;
  String? errorMessage;

  LoginViewModel(this.repository);

  Future<bool> login(String username, String password) async {
    isLoading = true;
    errorMessage = null;

    try {
      bool success = await repository.login(username, password);
      if (!success) {
        errorMessage = "Invalid credentials";
      } else {
        return true;
      }
    } catch (e) {
      errorMessage = "Conection error";
    } finally {
      isLoading = false;
    }
    return false;
  }
}
