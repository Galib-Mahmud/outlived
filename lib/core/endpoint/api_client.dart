// lib/core/endpoint/api_client.dart

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:http/http.dart' as http;

import '../storage/local_storage.dart';
import 'api_endpoint.dart';

class ApiClient {
  final String baseUrl;
  final http.Client _httpClient;
  final Duration timeout;

  ApiClient({
    required this.baseUrl,
    http.Client? httpClient,
    this.timeout = const Duration(seconds: 30),
  }) : _httpClient = httpClient ?? http.Client();

  // ─── Default headers (no auth) ────────────────────────────────────
  final Map<String, String> _defaultHeaders = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  // ─── URL Builder ──────────────────────────────────────────────────
  String _buildUrl(String endpoint) {
    final base = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final path = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    return '$base$path';
  }

  // ─── Auth Header ──────────────────────────────────────────────────
  // Reads token from in-memory cache — SYNCHRONOUS, zero async gap.
  // UserInfo.init() in main() guarantees the cache is populated before
  // any controller's onInit() fires.
  Map<String, String> _authHeaders() {
    final token = UserInfo.getAccessTokenSync();
    return {
      ..._defaultHeaders,
      if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
    };
  }

  // Consolidates the repeated "build headers for this call" logic that
  // used to be duplicated in get/post/put/patch/delete.
  Map<String, String> _prepareHeaders(
      bool requiresAuth, Map<String, String>? extra) {
    final base = requiresAuth ? _authHeaders() : {..._defaultHeaders};
    return {...base, ...?extra};
  }

  // Prevents concurrent requests from each independently firing their own
  // refresh call when several 401s land at once.
  Future<bool>? _refreshInFlight;

  Future<bool> _refreshAccessToken() {
    return _refreshInFlight ??= () async {
      try {
        final refreshTok = await UserInfo.getRefreshToken();
        if (refreshTok == null || refreshTok.isEmpty) return false;
        final url = Uri.parse(_buildUrl(ApiEndpoint.refreshToken));
        final response = await _httpClient
            .post(
          url,
          headers: _defaultHeaders,
          body: jsonEncode({'refresh': refreshTok}),
        )
            .timeout(timeout);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final newAccess = data['access'];
          if (newAccess is String && newAccess.isNotEmpty) {
            await UserInfo.setAccessToken(newAccess);
            return true;
          }
        }
        return false;
      } catch (_) {
        return false;
      } finally {
        _refreshInFlight = null;
      }
    }();
  }

  // ─── GET ──────────────────────────────────────────────────────────
  Future<dynamic> get(
      String endpoint, {
        Map<String, String>? headers,
        bool requiresAuth = true,
        bool isRetry = false,
      }) async {
    final url = Uri.parse(_buildUrl(endpoint));
    final mergedHeaders = _prepareHeaders(requiresAuth, headers);
    _logRequest("GET", url, mergedHeaders, null);
    final response = await _send(
          () => _httpClient.get(url, headers: mergedHeaders),
      url: url,
      method: "GET",
    );
    if (response.statusCode == 401 && requiresAuth && !isRetry) {
      if (await _refreshAccessToken()) {
        return get(endpoint, headers: headers, requiresAuth: requiresAuth, isRetry: true);
      }
    }
    return _handleResponse(response, url, method: "GET");
  }

  // ─── POST ─────────────────────────────────────────────────────────
  Future<dynamic> post(
      String endpoint, {
        Map<String, String>? headers,
        dynamic body,
        bool requiresAuth = true,
        bool isRetry = false,
        void Function(int statusCode)? onStatusCode,
      }) async {
    final url = Uri.parse(_buildUrl(endpoint));
    final mergedHeaders = _prepareHeaders(requiresAuth, headers);
    final encodedBody = body != null ? jsonEncode(body) : null;
    _logRequest("POST", url, mergedHeaders, body);
    final response = await _send(
          () => _httpClient.post(url, headers: mergedHeaders, body: encodedBody),
      url: url,
      method: "POST",
    );
    if (response.statusCode == 401 && requiresAuth && !isRetry) {
      if (await _refreshAccessToken()) {
        return post(endpoint, headers: headers, body: body, requiresAuth: requiresAuth, isRetry: true, onStatusCode: onStatusCode);
      }
    }
    // Fires with the raw status code for the response that actually gets
    // returned (i.e. after any 401-refresh retry has resolved) — before
    // _handleResponse decides whether to throw. Lets callers distinguish
    // e.g. 201 Created from a 200 that also happens to succeed, or see
    // the exact failing code alongside whatever exception follows.
    onStatusCode?.call(response.statusCode);
    return _handleResponse(response, url, method: "POST");
  }

  // ─── PUT ──────────────────────────────────────────────────────────
  Future<dynamic> put(
      String endpoint, {
        Map<String, String>? headers,
        dynamic body,
        bool requiresAuth = true,
        bool isRetry = false,
      }) async {
    final url = Uri.parse(_buildUrl(endpoint));
    final mergedHeaders = _prepareHeaders(requiresAuth, headers);
    final encodedBody = body != null ? jsonEncode(body) : null;
    _logRequest("PUT", url, mergedHeaders, body);
    final response = await _send(
          () => _httpClient.put(url, headers: mergedHeaders, body: encodedBody),
      url: url,
      method: "PUT",
    );
    if (response.statusCode == 401 && requiresAuth && !isRetry) {
      if (await _refreshAccessToken()) {
        return put(endpoint, headers: headers, body: body, requiresAuth: requiresAuth, isRetry: true);
      }
    }
    return _handleResponse(response, url, method: "PUT");
  }

  // ─── PATCH ────────────────────────────────────────────────────────
  Future<dynamic> patch(
      String endpoint, {
        Map<String, String>? headers,
        dynamic body,
        bool requiresAuth = true,
        bool isRetry = false,
      }) async {
    final url = Uri.parse(_buildUrl(endpoint));
    final mergedHeaders = _prepareHeaders(requiresAuth, headers);
    final encodedBody = body != null ? jsonEncode(body) : null;
    _logRequest("PATCH", url, mergedHeaders, body);
    final response = await _send(
          () => _httpClient.patch(url, headers: mergedHeaders, body: encodedBody),
      url: url,
      method: "PATCH",
    );
    if (response.statusCode == 401 && requiresAuth && !isRetry) {
      if (await _refreshAccessToken()) {
        return patch(endpoint, headers: headers, body: body, requiresAuth: requiresAuth, isRetry: true);
      }
    }
    return _handleResponse(response, url, method: "PATCH");
  }

  // ─── DELETE ───────────────────────────────────────────────────────
  Future<dynamic> delete(
      String endpoint, {
        Map<String, String>? headers,
        dynamic body,
        bool requiresAuth = true,
        bool isRetry = false,
      }) async {
    final url = Uri.parse(_buildUrl(endpoint));
    final mergedHeaders = _prepareHeaders(requiresAuth, headers);
    final encodedBody = body != null ? jsonEncode(body) : null;
    _logRequest("DELETE", url, mergedHeaders, body);
    final response = await _send(
          () => _httpClient.delete(url, headers: mergedHeaders, body: encodedBody),
      url: url,
      method: "DELETE",
    );
    if (response.statusCode == 401 && requiresAuth && !isRetry) {
      if (await _refreshAccessToken()) {
        return delete(endpoint, headers: headers, body: body, requiresAuth: requiresAuth, isRetry: true);
      }
    }
    return _handleResponse(response, url, method: "DELETE");
  }

  // ─── MULTIPART ────────────────────────────────────────────────────
  Future<dynamic> multipart(
      String endpoint, {
        required String method,
        Map<String, String>? headers,
        Map<String, String>? fields,
        Map<String, File>? files,
        bool requiresAuth = true,
      }) async {
    final url = Uri.parse(_buildUrl(endpoint));
    final token = requiresAuth ? UserInfo.getAccessTokenSync() : null;
    final request = http.MultipartRequest(method, url);
    if (token != null && token.isNotEmpty) {
      request.headers["Authorization"] = "Bearer $token";
    }
    request.headers["Accept"] = "application/json";
    if (headers != null) request.headers.addAll(headers);
    if (fields != null) request.fields.addAll(fields);
    if (files != null) {
      for (final entry in files.entries) {
        request.files.add(
            await http.MultipartFile.fromPath(entry.key, entry.value.path));
      }
    }
    if (kDebugMode) {
      print("🌐 [$method MULTIPART] URL: $url");
      print("📋 Fields: $fields");
      print("📎 Files: ${files?.keys.toList()}");
    }

    final http.Response response;
    try {
      final streamedResponse = await request.send().timeout(timeout);
      response = await http.Response.fromStream(streamedResponse);
    } on TimeoutException {
      throw NetworkException(
        message: "Request timed out. Please try again.",
        uri: url,
      );
    } on SocketException {
      throw NetworkException(
        message: "No internet connection.",
        uri: url,
      );
    } on http.ClientException catch (e) {
      throw NetworkException(message: e.message, uri: url);
    }

    return _handleResponse(response, url, method: "$method MULTIPART");
  }

  // ─── Shared send wrapper (timeout + network error translation) ────
  Future<http.Response> _send(
      Future<http.Response> Function() request, {
        required Uri url,
        required String method,
      }) async {
    try {
      return await request().timeout(timeout);
    } on TimeoutException {
      throw NetworkException(
        message: "Request timed out. Please try again.",
        uri: url,
      );
    } on SocketException {
      throw NetworkException(
        message: "No internet connection.",
        uri: url,
      );
    } on http.ClientException catch (e) {
      throw NetworkException(message: e.message, uri: url);
    }
  }

  // ─── Response Handler ─────────────────────────────────────────────
  dynamic _handleResponse(http.Response response, Uri url,
      {required String method}) {
    if (kDebugMode) {
      print("📩 [$method] Status: ${response.statusCode}");
      print("📩 [$method] Body: ${response.body}");
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      try {
        return jsonDecode(response.body);
      } catch (e) {
        throw HttpException(
          message: "Invalid JSON format",
          statusCode: response.statusCode,
          uri: url,
          body: response.body,
        );
      }
    }

    final errorMessage = _extractErrorMessage(response.body);

    switch (response.statusCode) {
      case 400:
        throw HttpException(
            message: errorMessage,
            statusCode: 400,
            uri: url,
            body: response.body);
      case 401:
        throw UnauthorizedException(uri: url, body: response.body);
      case 403:
        throw ForbiddenException(uri: url, body: response.body);
      case 404:
        throw NotFoundException(uri: url, body: response.body);
      case 500:
      case 502:
      case 503:
        throw ServerException(uri: url, body: response.body);
      default:
        throw HttpException(
            message: errorMessage,
            statusCode: response.statusCode,
            uri: url,
            body: response.body);
    }
  }

  // Handles: {"detail": "msg"}, {"detail": ["msg1","msg2"]},
  // {"field": ["msg"]} (DRF validation errors), and bare list bodies,
  // instead of assuming a Map with a string 'detail'.
  String _extractErrorMessage(String body) {
    if (body.isEmpty) return "Request failed";
    try {
      final decoded = jsonDecode(body);

      String stringify(dynamic val) {
        if (val is List) return val.map(stringify).join(', ');
        return val.toString();
      }

      if (decoded is Map<String, dynamic>) {
        if (decoded.containsKey('detail')) {
          return stringify(decoded['detail']);
        }
        return decoded.entries
            .map((e) => "${e.key}: ${stringify(e.value)}")
            .join(" | ");
      }
      if (decoded is List) {
        return stringify(decoded);
      }
      return decoded.toString();
    } catch (_) {
      return body;
    }
  }

  // ─── Logger ───────────────────────────────────────────────────────
  void _logRequest(String method, Uri url, Map<String, String> headers,
      dynamic body) {
    if (!kDebugMode) return;
    print("─────────────────────────────────────");
    print("🌐 [$method] $url");
    print("📋 Headers: $headers");
    if (body != null) print("📦 Body: $body");
    print("─────────────────────────────────────");
  }
}

// ─── Exceptions ───────────────────────────────────────────────────
class HttpException implements Exception {
  final String message;
  final int statusCode;
  final Uri uri;
  final String? body;

  const HttpException({
    required this.message,
    required this.statusCode,
    required this.uri,
    this.body,
  });

  @override
  String toString() => "HttpException [$statusCode]: $message | URL: $uri";
}

// New: for connection failures / timeouts, distinct from server-returned
// HTTP errors, since there's no statusCode to report in these cases.
class NetworkException implements Exception {
  final String message;
  final Uri uri;

  const NetworkException({required this.message, required this.uri});

  @override
  String toString() => "NetworkException: $message | URL: $uri";
}

class UnauthorizedException extends HttpException {
  UnauthorizedException({required Uri uri, String? body})
      : super(
      message: "Unauthorized. Please log in again.",
      statusCode: 401,
      uri: uri,
      body: body);
}

class ForbiddenException extends HttpException {
  ForbiddenException({required Uri uri, String? body})
      : super(
      message: "Access denied.",
      statusCode: 403,
      uri: uri,
      body: body);
}

class NotFoundException extends HttpException {
  NotFoundException({required Uri uri, String? body})
      : super(
      message: "Resource not found.",
      statusCode: 404,
      uri: uri,
      body: body);
}

class ServerException extends HttpException {
  ServerException({required Uri uri, String? body})
      : super(
      message: "Server error. Please try again later.",
      statusCode: 500,
      uri: uri,
      body: body);
}