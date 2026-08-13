class FeedbackModel {
  final String id;
  final String userName;
  final String content;
  final double rating;
  final DateTime date;

  FeedbackModel({
    required this.id,
    required this.userName,
    required this.content,
    required this.rating,
    required this.date,
  });
  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'],
      userName: json['userName'],
      content: json['content'],
      rating: json['rating'],
      date: json['date'],
    );
  }
}
