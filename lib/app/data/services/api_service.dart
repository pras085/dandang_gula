import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ApiService extends GetxService {
  final String baseUrl;
  final String apiKey;

  // Headers yang akan disertakan di setiap request
  late Map<String, String> _headers;

  ApiService({required this.baseUrl, required this.apiKey}) {
    _headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };
  }

  // GET request
  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParams}) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(
        queryParameters: queryParams,
      );

      debugPrint('GET Request: $uri');

      final response = await http
          .get(
            uri,
            headers: _headers,
          )
          .timeout(const Duration(seconds: 30));

      return _processResponse(response);
    } catch (e) {
      debugPrint('GET Error: $e');
      throw Exception('Failed to perform GET request: $e');
    }
  }

  // POST request
  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      debugPrint('POST Request: $uri');
      debugPrint('POST Body: $body');

      final response = await http
          .post(
            uri,
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 30));

      return _processResponse(response);
    } catch (e) {
      debugPrint('POST Error: $e');
      throw Exception('Failed to perform POST request: $e');
    }
  }

  // PUT request
  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      debugPrint('PUT Request: $uri');

      final response = await http
          .put(
            uri,
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 30));

      return _processResponse(response);
    } catch (e) {
      debugPrint('PUT Error: $e');
      throw Exception('Failed to perform PUT request: $e');
    }
  }

  // DELETE request
  Future<dynamic> delete(String endpoint) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      debugPrint('DELETE Request: $uri');

      final response = await http
          .delete(
            uri,
            headers: _headers,
          )
          .timeout(const Duration(seconds: 30));

      return _processResponse(response);
    } catch (e) {
      debugPrint('DELETE Error: $e');
      throw Exception('Failed to perform DELETE request: $e');
    }
  }

  // Process response and handle errors
  dynamic _processResponse(http.Response response) {
    debugPrint('Response Status Code: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');

    switch (response.statusCode) {
      case 200:
      case 201:
        // Parse response body
        try {
          return jsonDecode(response.body);
        } catch (e) {
          return response.body;
        }

      case 400:
        throw Exception('Bad request: ${response.body}');

      case 401:
        throw Exception('Unauthorized: ${response.body}');

      case 403:
        throw Exception('Forbidden: ${response.body}');

      case 404:
        throw Exception('Not found: ${response.body}');

      case 500:
      case 502:
      case 503:
        throw Exception('Server error: ${response.body}');

      default:
        throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  // Set authentication token
  void setAuthToken(String token) {
    _headers['Authorization'] = 'Bearer $token';
  }
}