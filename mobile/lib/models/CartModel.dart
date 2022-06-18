class CartModel {
  final int id;
  final String name;
  final int price;
  final int quantity;

  CartModel({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  CartModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        price = json['price'],
        quantity = json['quantity'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }
}
