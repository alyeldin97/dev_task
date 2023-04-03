import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'failure.dart';

abstract class NetWorkService {
  Future<dynamic> getRequest(url);
}

class HttpNetworkServiceImpl implements NetWorkService {
  @override
  Future getRequest(url) async {
    var headers = {
      'Content-Type': 'application/json',
    };
    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      return jsonDecode(response.body);
    } catch (exception) {
      if (exception is SocketException) {
        throw AppFailures.socketFailure;
      } else {
        throw AppFailures.defaultFailure;
      }
    }
  }
}
