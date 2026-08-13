import 'dart:io';

class Car {
  final String? id;
  final String title;
  final List<String> imageUrls;
  final String location;
  final String gearbox;
  final int seats;
  final String fuel;
  final double rating;
  final int trips;
  final double oldPrice;
  final double newPrice;
  final int discount;
  final bool isFavorite;
  final List<File>? featuredImages; 

  Car({
    this.id,
    required this.title,
    this.imageUrls = const [],
    required this.location,
    required this.gearbox,
    required this.seats,
    required this.fuel,
    required this.rating,
    required this.trips,
    required this.oldPrice,
    required this.newPrice,
    required this.discount,
    this.isFavorite = false, 
    this.featuredImages,
  });

  Car copyWith({
    String? id,
    String? title,
    List<String>? imageUrls,
    String? location,
    String? gearbox,
    int? seats,
    String? fuel,
    double? rating,
    int? trips,
    double? oldPrice,
    double? newPrice,
    int? discount,
    bool? isFavorite,
    List<File>? featuredImages,
    bool resetFeaturedImage = false,
  }) {
    return Car(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrls: imageUrls ?? this.imageUrls,
      location: location ?? this.location,
      gearbox: gearbox ?? this.gearbox,
      seats: seats ?? this.seats,
      fuel: fuel ?? this.fuel,
      rating: rating ?? this.rating,
      trips: trips ?? this.trips,
      oldPrice: oldPrice ?? this.oldPrice,
      newPrice: newPrice ?? this.newPrice,
      discount: discount ?? this.discount,
      isFavorite: isFavorite ?? this.isFavorite,
      featuredImages: resetFeaturedImage
          ? null
          : featuredImages ?? this.featuredImages,
    );
  }

  factory Car.fromJson(
    Map<String, dynamic> json,
    List<String> imageUrls, {
    bool isFavorite = false,
  }) {
    return Car(
      id: json['id'],
      title: json['title'] ?? '',
      imageUrls: imageUrls,
      location: json['location'] ?? '',
      gearbox: json['gearbox'] ?? '',
      seats: (json['seats'] ?? 0).toInt(),
      fuel: json['fuel'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      trips: (json['trips'] ?? 0).toInt(),
      oldPrice: (json['oldPrice'] ?? 0.0).toDouble(),
      newPrice: (json['newPrice'] ?? 0.0).toDouble(),
      discount: (json['discount'] ?? 0).toInt(),
      isFavorite: isFavorite, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'location': location,
      'gearbox': gearbox,
      'seats': seats,
      'fuel': fuel,
      'rating': rating,
      'trips': trips,
      'oldPrice': oldPrice,
      'newPrice': newPrice,
      'discount': discount,
    };
  }
}
