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

  @action
  void setPhoto(String value) => photo = value;

  void setModel(String value) => model = value;

  void setBrand(String value) => brand = value;

  void setYear(String value) => year = value;

  void setPrice(String value) => price = value;

  @computed
  bool get isFormValid =>
      photo.isEmpty &&
      model.isEmpty &&
      brand.isEmpty &&
      year.isEmpty &&
      price.isEmpty;
}
