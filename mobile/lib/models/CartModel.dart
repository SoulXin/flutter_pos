class CartModel {
  final int id;
  final int productId;
  final String name;
  final int price;
  int quantity;

  CartModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  CartModel.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'],
        productId = json['products_id'],
        name = json['products']['name'],
        price = json['products']['price'],
        quantity = json['quantity'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }
}
