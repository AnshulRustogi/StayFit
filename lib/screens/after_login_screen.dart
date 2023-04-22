import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utilities/fittrack_text_style.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import '../models/firebase_user_info.dart';
import '../utilities/common.dart';
import '../utilities/fittrack_colors.dart';
import '../utilities/fittrack_text.dart';
import '../network_utils/firebase/user_data_manager.dart';
import '../network_utils/firebase/workout_data_manager.dart';
import '../models/workout.dart';
import 'exercise_list_screen.dart';

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

  @override
  void initState() {
    super.initState();
    userInfo = FirebaseUserInfo.Instance();
    isLoading = true;
    isWorkoutAvailable = false;
    getUserInfo();
    getworkoutList();
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

  Widget printworkoutList() {
    // Put the exercise widget from workoutList in a column
    return Column(children: [
      for (Workout currentWorkout in workoutList)
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: InkWell(
            onTap: () {
              // ignore: avoid_print
              print("Tapped on exercise");
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
                                    const Text(
                                      kDaysPageDescription,
                                    ),
                                    const SizedBox(
                                      height: 29.0,
                                    )
                                  ])),
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
