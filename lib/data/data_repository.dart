import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:paraleloapp1/globals.dart';

class DataRepository {
  final String baseUrl = nodeURL;

  Future<bool> checkResponse(http.Response response) async {
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      if (responseData['success']) {
        return true;
      }
    }
    return false;
  }

  Future<bool> login(String username, String password) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      );

      bool r = await checkResponse(response);
      if (r) {
        currentUser = username;
      }
      return r;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String username, String password) async {
    var response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    return await checkResponse(response);
  }

  Future<List> fetchGoals() async {
    var response = await http.post(
      Uri.parse('$baseUrl/getAllGoals'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': currentUser}),
    );

    bool r = await checkResponse(response);
    if (r) {
      var responseData = json.decode(response.body);
      return responseData['data'];
    }
    return [];
  }

  Future<bool> addGoal(Map<String, dynamic> goalData) async {
    goalData['username'] = currentUser;
    var response = await http.post(
      Uri.parse('$baseUrl/goals'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(goalData),
    );
    return await checkResponse(response);
  }

  Future<bool> updateGoal(String goalId, Map<String, dynamic> goalData) async {
    try {
      var response = await http.put(
        Uri.parse('$baseUrl/goals/$goalId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(goalData),
      );
      return await checkResponse(response);
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteGoal(String goalId) async {
    var response = await http.delete(
      Uri.parse('$baseUrl/goals/$goalId'),
    );
    return await checkResponse(response);
  }
}
