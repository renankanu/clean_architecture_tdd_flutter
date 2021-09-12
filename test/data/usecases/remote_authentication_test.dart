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
  late MockHttpClient mockHttpClient;
  late String url;
  late RemoteAuthentication sut;

  setUp(() {
    mockHttpClient = MockHttpClient();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(
      httpClient: mockHttpClient,
      url: url,
      method: 'POST',
    );
  });
  test('Should call HttpClient with correct values', () async {
    await sut.auth();

    verify(mockHttpClient.request(
      url: url,
      method: 'POST',
    ));
  });
}
