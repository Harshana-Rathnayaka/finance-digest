import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'custom_exception.dart';

class Network {
  final String url = 'https://finnhub.io/api/v1/news?';
  final String apiKey = 'crals9pr01qhk4bqotb0crals9pr01qhk4bqotbg';
  dynamic responseJson;
  static const int timeoutDuration = 20;

  // GET
  Future<dynamic> getData(apiUrl) async {
    var fullUrl = Uri.parse(url + apiUrl);

    try {
      final response = await http.get(fullUrl, headers: {'X-Finnhub-Token': apiKey}).timeout(const Duration(seconds: timeoutDuration));
      responseJson = _responseHandler(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Request Timed Out');
    } on FormatException {
      throw FetchDataException('Format Exception');
    }
    return responseJson;
  }

  // exception handler based on status
  dynamic _responseHandler(http.Response response) {
    /* For some reason this API returns 200 StatusCode with a HTML page during certain circumstances.
    * Therefore, the following code ensures that its JSON when getting 200 StatusCode
    *  */
    if (response.statusCode == 200 && response.headers['content-type']?.contains('application/json') == true) {
      return response;
    }

    switch (response.statusCode) {
      case 200:
        // if the body is HTML but the status is 200
        throw FetchDataException('Unexpected response format. Expected JSON but received HTML or other format.');
      case 400:
        throw BadRequestException(jsonDecode(response.body));
      case 401:
      case 403:
        throw UnauthorizedException(jsonDecode(response.body));
      case 404:
        throw NotFoundException(jsonDecode(response.body));
      case 500:
      case 502:
      case 503:
        throw InternalServerErrorException(jsonDecode(response.body));
      default:
        throw FetchDataException('Error occurred while communicating with the server with StatusCode: ${response.statusCode}');
    }
  }
}
