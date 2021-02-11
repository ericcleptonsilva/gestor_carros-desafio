class ProductModels {
  ProductModels({
    this.model,
    this.brand,
    this.year,
    this.price,
    this.photo,
  });
  final String model;
  final String brand;
  final int year;
  final int price;
  final String photo;

  factory ProductModels.fromJson(Map<String, dynamic> json) => ProductModels(
        model: json["model"],
        brand: json["brand"],
        year: json["year"],
        price: json["price"],
        photo: json["photo"],
      );
  Map<String, dynamic> toJson() => {
        "model": model,
        "brand": brand,
        "year": year,
        "price": price,
        "photo": photo,
      };
}
