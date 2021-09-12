import '../../domain/usecases/usecases.dart';
import '../http/http.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;
  final String method;

  RemoteAuthentication({
    required this.httpClient,
    required this.url,
    required this.method,
  });

  Future<void> auth(AuthenticationParams params) async {
    await httpClient.request(url: url, method: method, body: params.toJson());
  }
}
