import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Workout extends StatelessWidget {
  final String name;
  final int numberOfSets;
  final int minutes;
  final String imagePath;
  Workout(
      {super.key,
      required this.name,
      required this.numberOfSets,
      required this.minutes,
      required this.imagePath});

  // ignore: non_constant_identifier_names
  factory Workout.Instance() {
    return Workout(
      name: "",
      numberOfSets: 0,
      minutes: 0,
      imagePath: "",
    );
  }
  double titleFontSize = 25;
  double subtitleFontSize = 16;
  double sizeBoxHeight = 20;

  @override
  Widget build(BuildContext context) {
    //Check for screen size and adjust the font size accordingly
    if (MediaQuery.of(context).size.width < 400) {
      titleFontSize = 20;
      subtitleFontSize = 14;
      sizeBoxHeight = 15;
    } else if (MediaQuery.of(context).size.width < 600) {
      titleFontSize = 22;
      subtitleFontSize = 15;
      sizeBoxHeight = 17;
    } else if (MediaQuery.of(context).size.width < 800) {
      titleFontSize = 25;
      subtitleFontSize = 16;
      sizeBoxHeight = 20;
    } else {
      titleFontSize = 30;
      subtitleFontSize = 18;
      sizeBoxHeight = 25;
    }

    return Container(
      width: double.infinity,
      height: 145,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 5.0,
              spreadRadius: 1.1)
        ],
      ),
      child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: TextStyle(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: sizeBoxHeight),
                        Text("$numberOfSets Exercies",
                            style: TextStyle(
                                fontSize: subtitleFontSize,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2),
                        const SizedBox(height: 3),
                        Text("$minutes Minutes",
                            style: TextStyle(
                                fontSize: subtitleFontSize,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2),
                        const Spacer(),
                        const SizedBox(height: 3),
                      ],
                    ),
                  ),
                  const SizedBox(width: 60),
                  Expanded(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          // child: Image.asset(imagePath, fit: BoxFit.fill))),
                          child: Image.network(imagePath, fit: BoxFit.fill)))
                ],
              ),
            ),
          )),
    );
  }
}
