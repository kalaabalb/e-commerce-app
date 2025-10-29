class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({required this.success, required this.message, this.data});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json)? fromJsonT,
  ) {
    try {
      return ApiResponse(
        success: json['success'] as bool? ?? false,
        message: json['message'] as String? ?? 'No message',
        data: (json['data'] != null && fromJsonT != null)
            ? fromJsonT(json['data'])
            : null,
      );
    } catch (e) {
      print('Error parsing ApiResponse: $e');
      return ApiResponse(
        success: false,
        message: 'Error parsing response: $e',
        data: null,
      );
    }
  }
}
