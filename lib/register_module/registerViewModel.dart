import 'package:flutter/foundation.dart';
import 'package:paraleloapp1/data/data_repository.dart';

class RegisterViewModel {
  final DataRepository repository;

  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  RegisterViewModel(this.repository);

  Future<void> register(String username, String password) async {
    isLoading = true;
    errorMessage = null;
    successMessage = null;

    try {
      bool success = await repository.register(username, password);
      if (success) {
        successMessage = "Registration successful!";
      } else {
        errorMessage = "Registration failed";
      }
    } catch (e) {
      errorMessage = "An error occurred during registration";
    } finally {
      isLoading = false;
    }
  }
}
