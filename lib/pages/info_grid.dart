import 'package:flutter/material.dart';

class MyGridView extends StatelessWidget {
  final int age;
  final int height;
  final int weight;
  final int gender;
  

  MyGridView({
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 2.0,
              children: [
                buildInfoRow("assets/images/age.png", "Age : $age"),
                buildInfoRow("assets/images/height.png", "Height : $height"),
                buildInfoRow("assets/images/scale.png", "Weight : $weight"),
                buildInfoRow(
                  gender == 0 ? "assets/images/female.png" : "assets/images/male.png",
                  gender == 0 ? "Female" : "Male",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(String imagePath, String text) {
    return Row(
      children: [
        Expanded(
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.blue.withOpacity(0.5),
              BlendMode.srcATop,
            ),
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: [
                    Color.fromRGBO(175, 250, 233, 1),
                    Color.fromARGB(255, 121, 213, 211),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcATop,
              child: Image.asset(
                imagePath,
                width: 50,
                height: 50,
                scale: 1.0,
              ),
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400
            ),
          ),
        ),
      ],
    );
  }
}