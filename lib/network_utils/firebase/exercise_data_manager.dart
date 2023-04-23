// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:StayFit/models/exercise.dart';

//Function to fetch all exercises from the database and return a list of exercises using the Exercise model
Future<void> getAllExercises(
    List<Exercise> exerciseList, String workoutName) async {
  FirebaseFirestore.instance
      .collection("Workouts")
      .doc(workoutName)
      .collection("Exercises")
      .get()
      .then((QuerySnapshot querySnapshot) {
    for (var doc in querySnapshot.docs) {
      final extractedData = doc.data() as Map<String, dynamic>;
      exerciseList.add(Exercise(
        exerciseDescription: extractedData['exerciseDescription'],
        exerciseName: extractedData['exerciseName'],
        exerciseDuration: extractedData['exerciseDuration'],
        exerciseSteps: extractedData['exerciseSteps'],
        exerciseVideoLink: extractedData['exerciseVideoLink'],
        exerciseImageLink: extractedData['exerciseImageLink'],
      ));
    }
  });

  // print("Exercises Extracted");
  // print("Number of Exercises: ${exerciseList.length}");
}
