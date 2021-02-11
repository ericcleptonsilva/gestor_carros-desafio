import 'package:mobx/mobx.dart';

part 'list_store.g.dart';

class ListStore = _ListStore with _$ListStore;

abstract class _ListStore with Store {
  @observable
  String photo;
  String model;
  String brand;
  String year;
  String price;
  String CarsList;

  @action
  void setPhoto(String value) => photo = value;

  void setModel(String value) => model = value;

  void setBrand(String value) => brand = value;

  void setYear(String value) => year = value;

  void setPrice(String value) => price = value;

  @computed
  bool get photoValid => photo != null && photo.length > 2;
  String get photoError {
    if (photo == null || photoValid)
      return null;
    else if (photo.isEmpty)
      return "Campo obrigatório!";
    else
      return "Nome muito Curto";
  }

  bool get modelValid => model != null && model.length > 2;
  String get modelError {
    if (model == null || modelValid)
      return null;
    else if (model.isEmpty)
      return "Campo obrigatóri!";
    else
      return "Nome muito Curto";
  }

  bool get brandValid => brand != null && brand.length > 2;
  String get brandError {
    if (brand == null || brandValid)
      return null;
    else if (brand.isEmpty)
      return "Campo obrigatório!";
    else
      return "Nome muito Curto";
  }

  bool get yearValid => year != null && year.length > 3;
  String get yearError {
    if (year == null || yearValid)
      return null;
    else if (year.isEmpty)
      return "Campo obrigatório! Ex.: 2021";
    else
      return "Ano muito Curto";
  }

  bool get priceValid => price != null && price.length > 9;
  String get priceError {
    if (price == null || priceValid)
      return null;
    else if (price.isEmpty)
      return "Campo obrigatório! Ex.: R\$30.000,00";
    else
      return "Valor muito Curto";
  }
}
