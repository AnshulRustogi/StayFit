import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Exercise extends StatelessWidget {
  final String exerciseDescription;
  final int exerciseDuration;
  final String exerciseName;
  final String exerciseSteps;
  final String exerciseVideoLink;
  final String exerciseImageLink;

  const Exercise(
      {super.key,
      required this.exerciseDescription,
      required this.exerciseDuration,
      required this.exerciseName,
      required this.exerciseSteps,
      required this.exerciseVideoLink,
      required this.exerciseImageLink});

  // ignore: non_constant_identifier_names
  factory Exercise.Instance() {
    return const Exercise(
      exerciseDescription: "",
      exerciseDuration: 0,
      exerciseName: "",
      exerciseSteps: "",
      exerciseVideoLink: "",
      exerciseImageLink: "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 140,
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
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
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          //Using image of square size
                          child: Image.network(
                            exerciseImageLink,
                            fit: BoxFit.cover,
                          ))),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(exerciseName,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text("${exerciseDuration} Minutes",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2),
                      ],
                    ),
                  ),
                  //Adding a next button to navigate to the next screen
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.purple,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
