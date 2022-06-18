class ProductModel {
  final int id;
  final String name;
  final int price;

  ProductModel({required this.id, required this.name, required this.price});

  ProductModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        price = json['price'];

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'price': price};
  }
}
