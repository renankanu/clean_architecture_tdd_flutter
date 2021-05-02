import 'package:clean_architecture_tdd_flutter/domain/entities/entities.dart';

abstract class HttpClient {
  Future<Map> request({
    required String url,
    required String method,
    Map body,
  });
}
