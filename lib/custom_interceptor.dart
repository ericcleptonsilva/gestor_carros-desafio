/*
import 'package:dio/dio.dart';

class CacheIntercepertor extends InterceptorsWrapper {
  @override
  Future onReponse(Response response) async {
    print('Response[${response.statusCode}] => PATH: ${response.request.path}');
    if (response.request.extra.containsKey('refresh') &&
        response.request.extra['refresh']) {
      var cache = await _getCache(response.request.uri);
      if (cache == null || cache.expired) {
        save(response.request.uri.toString(), response.data);
      }
    }
    return super.onResponse(response);
  }
}
*/
