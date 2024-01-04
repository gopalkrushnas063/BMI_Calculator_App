class HealthTip {
  final String title;
  final String tips;
  final String image;
  final int id;

  HealthTip({
    required this.title,
    required this.tips,
    required this.image,
    required this.id,
  });

  factory HealthTip.fromJson(Map<String, dynamic> json) {
    return HealthTip(
      title: json['title'] ?? "",
      tips: json['tips'] ?? "",
      image: json['image'] ?? "",
      id: json['id'] ?? 0,
    );
  }
}
