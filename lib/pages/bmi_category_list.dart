import 'package:flutter/material.dart';

class BMICategoryList extends StatelessWidget {
  final double bmiScore;

  BMICategoryList({required this.bmiScore});

  final List<Map<String, dynamic>> categories = [
    
    {'name': 'Underweight', 'range': '0.0-18.4', 'color': Colors.lightBlue},
    {'name': 'Normal', 'range': '18.5-24.9', 'color': Colors.green},
    {'name': 'Overweight', 'range': '25.0-29.9', 'color': const Color.fromARGB(255, 217, 200, 45)},
    {
      'name': 'Obese Class I',
      'range': '30.0-34.9',
      'color': Color(0xFFFFD700)
    }, // Deep Yellow
    {
      'name': 'Obese Class II',
      'range': '35.0-39.9',
      'color': Colors.orangeAccent
    }, // Light Orange
    {
      'name': 'Obese Class III',
      'range': '>=40',
      'color': Colors.deepOrange
    }, // Deep Orange
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final categoryName = category['name'] as String;
              final categoryRange = category['range'] as String;
              final bulletColor = category['color'] as Color;
              final isSelected = isCategorySelected(categoryRange);
          
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                     
                      if (isSelected)
                        Text(
                          '➤', 
                          style: TextStyle(
                            fontSize: 16,
                            color: bulletColor,
                          ),
                        ) else Container(
                        height: 10,
                        width: 13,
                      ),
                      SizedBox(width: 8),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: bulletColor,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        categoryName,
                        style: TextStyle(
                          fontSize: 16,
                          color: bulletColor,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    categoryRange,
                    style: TextStyle(
                      color: bulletColor,
                      fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  bool isCategorySelected(String categoryRange) {
    final rangeValues = categoryRange.split('-');
    if (rangeValues.length == 2) {
      final minRange = double.parse(rangeValues[0]);
      final maxRange = double.parse(rangeValues[1]);
      return bmiScore >= minRange && bmiScore <= maxRange;
    } else {
      final singleValue = double.parse(categoryRange.replaceAll('>=', ''));
      return bmiScore >= singleValue;
    }
  }
}
