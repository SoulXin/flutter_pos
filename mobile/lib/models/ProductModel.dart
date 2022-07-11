class ProductModel {
  final int id;
  final String name;
  final int price;
  final int? categoryId;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    this.categoryId,
  });

  ProductModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        price = json['price'],
        categoryId = json['categories_id'];

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'price': price};
  }
}
