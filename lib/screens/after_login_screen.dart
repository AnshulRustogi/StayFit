import 'package:StayFit/utilities/alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:StayFit/utilities/fittrack_text_style.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:StayFit/models/firebase_user_info.dart';
import 'package:StayFit/utilities/common.dart';
import 'package:StayFit/utilities/fittrack_colors.dart';
import 'package:StayFit/utilities/fittrack_text.dart';
import 'package:StayFit/network_utils/firebase/user_data_manager.dart';
import 'package:StayFit/network_utils/firebase/workout_data_manager.dart';
import 'package:StayFit/models/workout.dart';
import 'package:StayFit/screens/exercise_list_screen.dart';

class AfterLoginScreen extends StatefulWidget {
  // const WorkoutScreen({Key? key}) : super(key: key);
  const AfterLoginScreen({Key? key}) : super(key: key);

  @override
  State<AfterLoginScreen> createState() => _AfterLoginScreenState();
}

class _AfterLoginScreenState extends State<AfterLoginScreen> {
  bool isLoading = true;
  bool isError = false;
  bool isWorkoutAvailable = false;
  late FirebaseUserInfo userInfo;
  late List<Workout> workoutList;
  String firebaseUId = FirebaseAuth.instance.currentUser!.uid;
  late String userGoal;
  List<String> goals = [
    "Body Building",
    "Weight Loss",
    "Flexibility",
    "All Workout"
  ];

  @override
  void initState() {
    super.initState();
    userInfo = FirebaseUserInfo.Instance();
    isLoading = true;
    isWorkoutAvailable = false;
    getUserInfo();
    getworkoutList();
    userGoal = "Body Building";
  }

  Future<void> getUserInfo() async {
    getCurrentUserInfo(firebaseUId, userInfo);
    int intervalWait = 0;
    while (true) {
      if (intervalWait == 20) {
        setState(() {
          isError = true;
        });
        break;
      } else if (userInfo.userName != "") {
        setState(() {
          isLoading = false;
        });
        break;
      }
      intervalWait++;
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<void> getworkoutList() async {
    workoutList = <Workout>[];
    getAllWorkouts(workoutList);
    int intervalWait = 0;
    while (true) {
      if (intervalWait > 20) {
        setState(() {
          isError = true;
        });
        break;
      } else if (workoutList.isNotEmpty) {
        setState(() {
          isError = false;
          isWorkoutAvailable = true;
        });
        break;
      }
      intervalWait++;
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  List<Workout> filterWorkoutList() {
    List<Workout> filteredWorkoutList = <Workout>[];
    if (userGoal == "All Workout") {
      return workoutList;
    }
    for (Workout currentWorkout in workoutList) {
      // Checking if the workout is for the user's goal
      if (currentWorkout.goal.contains(userGoal)) {
        filteredWorkoutList.add(currentWorkout);
      }
    }
    return filteredWorkoutList;
  }

  Widget printworkoutList() {
    // Put the exercise widget from workoutList in a column
    return Column(children: [
      for (Workout currentWorkout in filterWorkoutList())
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: InkWell(
            onTap: () {
              Get.to(() => ExerciseListScreen(
                    workout: currentWorkout,
                  ));
            },
            child: currentWorkout,
          ),
        ),
      const SizedBox(
        height: 20.0,
      )
    ]);
  }

  Widget loadingPage() {
    if (isError) {
      return const Center(
        child: Text("Something went wrong, please try again later"),
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget getGoal() {
    return Placeholder();
  }

  void updateProfile() {
    alert("Feature to be added", "This feature is not available yet",
        colorText: Colors.red, backgroundColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: kColorMainApp,
          title: Text(
            kDaysPageTitle,
            style: FittrackTextStyle.appBarTextStyle(),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.supervised_user_circle,
                color: Colors.white,
              ),
              onPressed: () {
                updateProfile();
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.power_settings_new,
                color: Colors.red,
              ),
              onPressed: () {
                Common.openLogoutDialog(context);
              },
            ),
          ],
        ),
        body: (isLoading || isError)
            ? loadingPage()
            : Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification:
                        (OverscrollIndicatorNotification overscroll) {
                      overscroll.disallowIndicator();
                      return true;
                    },
                    child: RawScrollbar(
                        child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Welcome back, ${userInfo.userName}!",
                                      style: FittrackTextStyle.pageTitleStyle(),
                                    ),
                                    const SizedBox(
                                      height: 2.0,
                                    ),
                                    Row(
                                      children: const [
                                        Text(kDaysPageDescription,
                                            style: TextStyle(fontSize: 18)),
                                      ],
                                    ),
                                  ])),
                          Container(
                            width: double.infinity,
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20),
                            child: DropdownButton<String>(
                              value: userGoal,
                              icon: const Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(color: Colors.black),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  userGoal = newValue!;
                                });
                              },
                              items: goals.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          isWorkoutAvailable
                              ? printworkoutList()
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                        ],
                      ),
                    )))));
  }
}
