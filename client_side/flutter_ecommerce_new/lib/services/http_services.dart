import 'dart:convert';
import 'package:get/get_connect.dart';
import 'package:get/get.dart';

import '../utility/constants.dart';

class HttpService {
  final String baseUrl = MAIN_URL;

  Future<Response> getItems({required String endpointUrl}) async {
    try {
      print('🟡 [HTTP GET] $baseUrl/$endpointUrl');

      final response = await GetConnect(
        timeout: const Duration(seconds: 10),
      ).get('$baseUrl/$endpointUrl');

      print('🟡 [HTTP GET Response] Status: ${response.statusCode}');

      if (response.statusCode == null) {
        throw Exception(
          'Network error: No response from server. Check if server is running and IP address is correct.',
        );
      }

      if (response.statusCode! >= 400) {
        throw Exception('Server error: ${response.statusCode}');
      }

      return response;
    } catch (e) {
      print('🔴 [HTTP GET Error]: $e');
      return Response(
        statusCode: 500,
        statusText: e.toString(),
        body: {'success': false, 'message': 'Network error: $e'},
      );
    }
  }

  Future<Response> addItem({
    required String endpointUrl,
    required dynamic itemData,
  }) async {
    try {
      print('🟡 [HTTP POST] $baseUrl/$endpointUrl');
      print('🟡 [HTTP POST Data]: $itemData');

      final response = await GetConnect(timeout: const Duration(seconds: 10))
          .post(
            '$baseUrl/$endpointUrl',
            itemData,
            headers: {'Content-Type': 'application/json'},
          );

      print('🟡 [HTTP POST Response] Status: ${response.statusCode}');
      print('🟡 [HTTP POST Response] Has Error: ${response.hasError}');

      if (response.statusCode == null) {
        throw Exception(
          'Network error: No response from server. Check if server is running and IP address is correct.',
        );
      }

      return response;
    } catch (e) {
      print('🔴 [HTTP POST Error]: $e');
      return Response(
        statusCode: 500,
        statusText: e.toString(),
        body: {'success': false, 'message': 'Network error: $e'},
      );
    }
  }

  Future<Response> updateItem({
    required String endpointUrl,
    required String itemId,
    required dynamic itemData,
  }) async {
    try {
      print('🟡 [HTTP PUT] $baseUrl/$endpointUrl/$itemId');
      final response = await GetConnect(timeout: const Duration(seconds: 10))
          .put(
            '$baseUrl/$endpointUrl/$itemId',
            itemData,
            headers: {'Content-Type': 'application/json'},
          );
      print('🟡 [HTTP PUT Response] Status: ${response.statusCode}');

      if (response.statusCode == null) {
        throw Exception('Network error: No response from server');
      }

      return response;
    } catch (e) {
      print('🔴 [HTTP PUT Error]: $e');
      return Response(
        statusCode: 500,
        statusText: e.toString(),
        body: {'success': false, 'message': 'Network error: $e'},
      );
    }
  }

  Future<Response> deleteItem({
    required String endpointUrl,
    required String itemId,
  }) async {
    try {
      print('🟡 [HTTP DELETE] $baseUrl/$endpointUrl/$itemId');
      final response = await GetConnect(
        timeout: const Duration(seconds: 10),
      ).delete('$baseUrl/$endpointUrl/$itemId');
      print('🟡 [HTTP DELETE Response] Status: ${response.statusCode}');

      if (response.statusCode == null) {
        throw Exception('Network error: No response from server');
      }

      return response;
    } catch (e) {
      print('🔴 [HTTP DELETE Error]: $e');
      return Response(
        statusCode: 500,
        statusText: e.toString(),
        body: {'success': false, 'message': 'Network error: $e'},
      );
    }
  }
}