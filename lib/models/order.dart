
class Order {
  final String? id;
  final String userId;
  final String carId;
  final DateTime startDate;
  final DateTime endDate;
  final double totalPrice;
  final String status;
  final String message;
  final String? deliveryAddress;
  final String? paymentId;

  Order({
    this.id,
    required this.userId,
    required this.carId,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    this.status = 'pending',
    this.message = '',
    this.deliveryAddress,
    this.paymentId,
  });

  // Getter để lấy tên xe một cách an toàn
  

  // Chuyển đổi object thành JSON để GỬI LÊN server
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'carId': carId, 
      //Định dạng ISO 8601
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),

      'total_price': totalPrice,
      'status': status,
      'message': message,
      'delivery_address': deliveryAddress,
    };
  }
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'], 
      userId: json['userId'] ?? '',
      carId: json['carId'] ?? '',
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : DateTime.now(),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : DateTime.now(),
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,

      status: json['status'] ?? 'pending',
      message: json['message'] ?? '',
      deliveryAddress: json['delivery_address'],
      paymentId: json['paymentId'],
    );
  }
}
