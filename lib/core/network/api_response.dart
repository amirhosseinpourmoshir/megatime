class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final int? statusCode;
  final Map<String, dynamic>? errors;
  final int? total;
  final int? page;
  final int? perPage;
  final int? totalPages;
  final String? nextPageUrl;
  final String? prevPageUrl;
  
  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
    this.errors,
    this.total,
    this.page,
    this.perPage,
    this.totalPages,
    this.nextPageUrl,
    this.prevPageUrl,
  });
  
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    // استخراج داده از ساختارهای مختلف
    dynamic responseData = json['data'];
    bool isSuccess = json['success'] ?? json['status'] == 'success';
    String message = json['message'] ?? json['msg'] ?? json['error'] ?? '';
    
    // اگر data از نوع Map بود و حاوی data بود
    if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
      responseData = responseData['data'];
    }
    
    // اگر داده لیست بود و از Pagination استفاده می‌کرد
    T? parsedData;
    int? total;
    int? page;
    int? perPage;
    int? totalPages;
    String? nextPageUrl;
    String? prevPageUrl;
    
    if (responseData != null) {
      if (responseData is List) {
        parsedData = fromJsonT(responseData);
      } else if (responseData is Map<String, dynamic>) {
        // بررسی Pagination
        if (responseData.containsKey('items') || responseData.containsKey('data')) {
          final items = responseData['items'] ?? responseData['data'];
          if (items is List) {
            parsedData = fromJsonT(items);
          }
          total = responseData['total'];
          page = responseData['current_page'] ?? responseData['page'];
          perPage = responseData['per_page'] ?? responseData['perPage'];
          totalPages = responseData['last_page'] ?? responseData['totalPages'];
          nextPageUrl = responseData['next_page_url'];
          prevPageUrl = responseData['prev_page_url'];
        } else {
          parsedData = fromJsonT(responseData);
        }
      } else {
        parsedData = fromJsonT(responseData);
      }
    }
    
    return ApiResponse(
      success: isSuccess,
      message: message,
      data: parsedData,
      statusCode: json['statusCode'],
      errors: json['errors'],
      total: total,
      page: page,
      perPage: perPage,
      totalPages: totalPages,
      nextPageUrl: nextPageUrl,
      prevPageUrl: prevPageUrl,
    );
  }
  
  // ============ Helper Methods ============
  
  bool get isSuccess => success && data != null;
  bool get hasError => !success;
  bool get hasData => data != null;
  bool get isList => data is List;
  bool get isMap => data is Map;
  bool get hasPagination => total != null && page != null;
  bool get hasNextPage => nextPageUrl != null;
  bool get hasPrevPage => prevPageUrl != null;
  
  T? getData() => data;
  
  List<dynamic>? getList() {
    if (data is List) {
      return data as List<dynamic>;
    }
    return null;
  }
  
  Map<String, dynamic>? getMap() {
    if (data is Map<String, dynamic>) {
      return data as Map<String, dynamic>;
    }
    return null;
  }
  
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
      'statusCode': statusCode,
      'errors': errors,
      'total': total,
      'page': page,
      'perPage': perPage,
      'totalPages': totalPages,
      'nextPageUrl': nextPageUrl,
      'prevPageUrl': prevPageUrl,
    };
  }
  
  @override
  String toString() {
    return 'ApiResponse{success: $success, message: $message, data: $data, statusCode: $statusCode}';
  }
}