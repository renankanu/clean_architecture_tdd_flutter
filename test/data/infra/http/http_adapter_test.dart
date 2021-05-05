import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'http_adapter_test.mocks.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  Future<void> request({
    required String url,
    required String method,
    Map? body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    await client.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
  }
}

@GenerateMocks([Client])
void main() {
  late MockClient client;
  late HttpAdapter sut;
  late String url;

  setUp(() {
    client = MockClient();
    sut = HttpAdapter(client);
    url = faker.internet.httpsUrl();
  });
  group('post', () {
    test('Should call post with correct values', () async {
      when(client.post(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
        body: jsonEncode({'any_key': 'any_value'}),
      )).thenAnswer((_) => Future(() => Response('body', 200)));

      await sut.request(
        url: url,
        method: 'post',
        body: {'any_key': 'any_value'},
      );

      verify(
        client.post(
          Uri.parse(url),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
          body: jsonEncode({'any_key': 'any_value'}),
        ),
      );
    });
  });
}
