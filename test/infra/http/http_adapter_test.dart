import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
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
    final jsonBody = body != null ? jsonEncode(body) : null;

    await client.post(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );
  }
}

@GenerateMocks([Client])
void main() {
  late Client client;
  late HttpAdapter sut;
  late String url;

  setUp(() {
    client = MockClient();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });

  group('post', () {
    test(
      'Should call post with correct values',
      () async {
        when(client.post(
          Uri.parse(url),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
          body: jsonEncode({'any_key': 'any_value'}),
        )).thenAnswer((_) => Future(() => Response('body', 200)));

        await sut
            .request(url: url, method: 'post', body: {'any_key': 'any_value'});

        verify(client.post(
          Uri.parse(url),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
          body: jsonEncode({'any_key': 'any_value'}),
        ));
      },
    );
    test('Should call post without body', () async {
      when(client.post(
        Uri.parse(url),
        headers: anyNamed('headers'),
      )).thenAnswer((_) =>
          Future(() => Response(jsonEncode({'any_key': 'any_value'}), 200)));

      await sut.request(
        url: url,
        method: 'post',
      );

      verify(
        client.post(
          Uri.parse(url),
          headers: anyNamed('headers'),
        ),
      );
    });
  });
}
