class BMIRecord {
  int? id; // for identifying the record in the database
  double bmiScore;
  int age;
  int gender;
  int height;
  int weight;

  BMIRecord({
    this.id,
    required this.bmiScore,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
  });

  // Convert BMIRecord to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bmiScore': bmiScore,
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
    };
  }

  // Create a BMIRecord from a Map
  factory BMIRecord.fromMap(Map<String, dynamic> map) {
    return BMIRecord(
      id: map['id'],
      bmiScore: map['bmiScore'],
      age: map['age'],
      gender: map['gender'],
      height: map['height'],
      weight: map['weight'],
    );
  }
}
