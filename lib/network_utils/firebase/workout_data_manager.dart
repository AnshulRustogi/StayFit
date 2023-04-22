import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/workout.dart';

//Function to fetch all exercises from the database and return a list of exercises using the Exercise model
void getAllWorkouts(List<Workout> workoutList) {
  FirebaseFirestore.instance
      .collection("Workouts")
      .get()
      .then((QuerySnapshot querySnapshot) {
    for (var doc in querySnapshot.docs) {
      final extractedData = doc.data() as Map<String, dynamic>;
      workoutList.add(Workout(
        name: extractedData['name'],
        numberOfSets: extractedData['numberOfSets'],
        minutes: extractedData['minutes'],
        imagePath: extractedData['imagePath'],
      ));
    }
    print("Exercise Added");
    print("Number of exercises: ${workoutList.length}");
  });
}
