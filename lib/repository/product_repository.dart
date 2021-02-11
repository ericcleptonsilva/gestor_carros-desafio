import 'package:dio/dio.dart';
import 'package:gestor_cars/models/product_model.dart';

void getHttp() async {
  try {
    Response response = await Dio().get("http://localhost:3000/posts");
    var listCarsjson = (response.data as List).map((item) {
      return ProductModels.fromJson(item);
    });
  } catch (e) {
    print(e);
  }
  ;
}
