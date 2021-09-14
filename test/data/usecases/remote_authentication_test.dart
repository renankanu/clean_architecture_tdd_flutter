import 'package:clean_architecture_tdd_flutter/data/http/http.dart';
import 'package:clean_architecture_tdd_flutter/data/usecases/usecases.dart';
import 'package:clean_architecture_tdd_flutter/domain/helpers/helpers.dart';
import 'package:clean_architecture_tdd_flutter/domain/usecases/usecases.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'remote_authentication_test.mocks.dart';

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
    final params = AuthenticationParams(
      email: faker.internet.email(),
      secret: faker.internet.password(),
    );

    await sut.auth(params);

    verify(mockHttpClient.request(
      url: url,
      method: 'POST',
      body: {'email': params.email, 'password': params.secret},
    ));
  });

  test('Should throw UnexpectedError if HttClient return 400', () async {
    when(mockHttpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
    )).thenThrow(HttpError.badRequest);

    final params = AuthenticationParams(
      email: faker.internet.email(),
      secret: faker.internet.password(),
    );

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
