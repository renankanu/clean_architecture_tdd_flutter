import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_architecture_tdd_flutter/data/http/http.dart';

import 'http_adapter_test.mocks.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  Future<Map?> request({
    required String url,
    required String method,
    Map? body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final jsonBody = body != null ? jsonEncode(body) : null;
    final response =
        await client.post(Uri.parse(url), headers: headers, body: jsonBody);
    return response.body.isEmpty ? null : jsonDecode(response.body);
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
      )).thenAnswer((_) =>
          Future(() => Response(jsonEncode({'any_key': 'any_value'}), 200)));

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

    test('Should call post without body', () async {
      when(client.post(
        any,
        headers: anyNamed('headers'),
      )).thenAnswer((_) =>
          Future(() => Response(jsonEncode({'any_key': 'any_value'}), 200)));

      await sut.request(
        url: url,
        method: 'post',
      );

      verify(
        client.post(
          any,
          headers: anyNamed('headers'),
        ),
      );
    });
  });

  test('Should return data if post returns 200', () async {
    when(client.post(
      Uri.parse(url),
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode({'any_key': 'any_value'}),
    )).thenAnswer((_) =>
        Future(() => Response(jsonEncode({'any_key': 'any_value'}), 200)));

    final response = await sut.request(
      url: url,
      method: 'post',
      body: {'any_key': 'any_value'},
    );

    expect(response, {'any_key': 'any_value'});
  });
  test('Should return null if post returns 200 with no data', () async {
    when(client.post(
      Uri.parse(url),
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode({'any_key': 'any_value'}),
    )).thenAnswer((_) => Future(() => Response('', 200)));

    final response = await sut.request(
      url: url,
      method: 'post',
      body: {'any_key': 'any_value'},
    );

    expect(response, null);
  });
}
