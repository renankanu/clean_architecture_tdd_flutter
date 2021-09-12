import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'remote_authentication_test.mocks.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;
  final String method;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
    required this.method,
  });

  Future<void> auth() async {
    await httpClient.request(url: url, method: method);
  }
}

abstract class HttpClient {
  Future<void> request({
    required String url,
    required String method,
  });
}

@GenerateMocks([HttpClient])
void main() {
  test('Should call HttpClient with correct values', () async {
    final httpClient = MockHttpClient();
    final url = faker.internet.httpUrl();
    final sut = RemoteAuthentication(
      httpClient: httpClient,
      url: url,
      method: 'POST',
    );

    await sut.auth();

    verify(httpClient.request(
      url: url,
      method: 'POST',
    ));
  });
}
