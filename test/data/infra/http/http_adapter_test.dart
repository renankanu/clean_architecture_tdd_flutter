import 'dart:convert';

import 'package:clean_architecture_tdd_flutter/data/http/http.dart';
import 'package:clean_architecture_tdd_flutter/infra/http/http.dart';
import 'package:faker/faker.dart';
import 'package:http/http.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'http_adapter_test.mocks.dart';

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
    PostExpectation mockRequestAny() => when(
        client.post(any, headers: anyNamed('headers'), body: anyNamed('body')));

    void mockResponseAny(int statusCode, {String body = ''}) {
      mockRequestAny()
          .thenAnswer((_) => Future(() => Response(body, statusCode)));
    }

    setUp(() {
      mockResponseAny(200, body: jsonEncode({'any_key': 'any_value'}));
    });
    test('Should call post with correct values', () async {
      await sut
          .request(url: url, method: 'post', body: {'any_key': 'any_value'});

      verify(client.post(Uri.parse(url),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
          body: jsonEncode({'any_key': 'any_value'})));
    });
    test('Should call post without body', () async {
      await sut.request(url: url, method: 'post');

      verify(client.post(any, headers: anyNamed('headers')));
    });
    test('Should return data if post returns 200', () async {
      final response = await sut.request(
        url: url,
        method: 'post',
        body: {'any_key': 'any_value'},
      );

      expect(response, {'any_key': 'any_value'});
    });
    test('Should return null if post returns 200 with no data', () async {
      mockResponseAny(200, body: '');
      final response = await sut.request(
        url: url,
        method: 'post',
        body: {'any_key': 'any_value'},
      );

      expect(response, null);
    });
    test('Should return null if post returns 204', () async {
      mockResponseAny(204, body: '');
      final response = await sut.request(
        url: url,
        method: 'post',
        body: {'any_key': 'any_value'},
      );

      expect(response, null);
    });
    test('Should return null if post returns 204 with data', () async {
      mockResponseAny(204);
      final response = await sut.request(
        url: url,
        method: 'post',
        body: {'any_key': 'any_value'},
      );

      expect(response, null);
    });
    test('Should return BadRequestError if post returns 400', () async {
      mockResponseAny(400);
      final future = sut.request(url: url, method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });
  });
}
