import 'dart:convert';
import 'package:get/get_connect.dart';
import 'package:get/get.dart';
import '../utility/constants.dart';

class HttpService extends GetConnect {
  final String baseUrl = MAIN_URL;

  @override
  void onInit() {
    httpClient.baseUrl = baseUrl;
    httpClient.timeout = Duration(seconds: 30);
    httpClient.addRequestModifier<void>((request) {
      print('🚀 Making ${request.method} request to: ${request.url}');
      return request;
    });
    super.onInit();
  }

  Future<Response> getItems({required String endpointUrl}) async {
    try {
      final response = await get('/$endpointUrl');
      print('✅ GET $endpointUrl - Status: ${response.statusCode}');
      return response;
    } catch (e) {
      print('❌ Error in getItems $endpointUrl: $e');
      return Response(
        statusCode: 500,
        statusText: 'Network error',
        body: {'success': false, 'message': 'Network error: $e'},
      );
    }
  }

  Future<Response> addItem(
      {required String endpointUrl, required dynamic itemData}) async {
    try {
      final response = await post('/$endpointUrl', itemData);
      print('✅ POST $endpointUrl - Status: ${response.statusCode}');
      print('Response: ${response.body}');
      return response;
    } catch (e) {
      print('❌ Error in addItem $endpointUrl: $e');
      return Response(
        statusCode: 500,
        statusText: 'Network error',
        body: {'success': false, 'message': 'Network error: $e'},
      );
    }
  }

  Future<Response> updateItem(
      {required String endpointUrl,
      required String itemId,
      required dynamic itemData}) async {
    try {
      final response = await put('/$endpointUrl/$itemId', itemData);
      print('✅ PUT $endpointUrl/$itemId - Status: ${response.statusCode}');
      return response;
    } catch (e) {
      print('❌ Error in updateItem $endpointUrl/$itemId: $e');
      return Response(
        statusCode: 500,
        statusText: 'Network error',
        body: {'success': false, 'message': 'Network error: $e'},
      );
    }
  }

  Future<Response> deleteItem(
      {required String endpointUrl, required String itemId}) async {
    try {
      final response = await delete('/$endpointUrl/$itemId');
      print('✅ DELETE $endpointUrl/$itemId - Status: ${response.statusCode}');
      return response;
    } catch (e) {
      print('❌ Error in deleteItem $endpointUrl/$itemId: $e');
      return Response(
        statusCode: 500,
        statusText: 'Network error',
        body: {'success': false, 'message': 'Network error: $e'},
      );
    }
  }
}
