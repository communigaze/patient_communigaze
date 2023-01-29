import 'package:flutter/material.dart';

class GlassmorphismCard extends StatelessWidget {
  final Key key;
  String title;
  String content;
  String imageUrl;
  Gradient gradientColour;
  GlassmorphismCard({
    required this.key,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.gradientColour,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      key: key,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: EdgeInsets.all(20.0),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          gradient: gradientColour,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              content,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),

            SizedBox(height: 10.0),
            //insert image
            Image.asset(
              imageUrl,
              width: 200.0,
              height: 200.0,
            ),
          ],
        ),
      ),
    );
  }
}
