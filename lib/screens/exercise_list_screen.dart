import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../utilities/fittrack_text_style.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import '../models/firebase_user_info.dart';
import '../utilities/common.dart';
import '../utilities/fittrack_colors.dart';
import '../network_utils/firebase/exercise_data_manager.dart';
import '../models/workout.dart';
import 'exercise_detail_screen.dart';

class ExerciseListScreen extends StatefulWidget {
  final Workout workout;
  // ignore: prefer_const_constructors_in_immutables
  ExerciseListScreen({Key? key, required this.workout}) : super(key: key);

  @override
  State<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  bool isLoading = true;
  bool isError = false;
  String userUid = FirebaseAuth.instance.currentUser!.uid;
  late List<Exercise> exerciseList;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    // _scrollController.addListener(_scrollListener);
    getExerciseList();
  }

  Future<void> getExerciseList() async {
    exerciseList = <Exercise>[];
    getAllExercises(exerciseList, widget.workout.name);
    int intervalWait = 0;
    while (true) {
      if (intervalWait == 50) {
        setState(() {
          isError = true;
          isLoading = true;
        });
        break;
      }
      if (exerciseList.isNotEmpty) {
        setState(() {
          isLoading = false;
        });
        break;
      }
      intervalWait++;
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  Widget loadingPage(BuildContext context) {
    if (isError) {
      return const Center(
        child: Text("Something went wrong"),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget exercisePage(BuildContext context) {
    return Stack(
      children: [
        //Loading background image and aligning it to the top
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.workout.imagePath),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),
        ),
        NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: RawScrollbar(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 200,
                  ),
                  ClipRRect(
                    //Adding white background to the list of exercises
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 10, bottom: 30),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${widget.workout.name} Workout",
                                    style: const TextStyle(
                                      // fontSize: 40,
                                      // Adjust the font size according to the length of the workout name
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    )),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: Container(
                                        padding: const EdgeInsets.all(10.0),
                                        color: Colors.purple.withOpacity(0.1),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.man_3,
                                              color: Colors.purple,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              "${widget.workout.numberOfSets} Exercises",
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.purple),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: Container(
                                        padding: const EdgeInsets.all(10.0),
                                        color: Colors.purple.withOpacity(0.1),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.timer,
                                              color: Colors.purple,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                                "${widget.workout.minutes} Minutes",
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.purple)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            color: Colors.white,
                            child: Column(
                              children: List.generate(
                                  exerciseList.length,
                                  // (index) => exercise(context, index)),
                                  (index) => exerciseWidget(index)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ))),
      ],
    );
  }

  Widget exerciseWidget(int index) {
    return InkWell(
      child: exerciseList[index],
      onTap: () {
        Get.to(() => ExerciseDetailScreen(
              exerciseList: exerciseList,
              currentExerciseIndex: index,
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Workout Details",
            style: FittrackTextStyle.appBarTextStyle(),
          ),
          elevation: 0,
          backgroundColor: const Color(0xff0F172A),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.purple,
              onPressed: () => Navigator.of(context).pop(),
              iconSize: 30,
              autofocus: true),
          centerTitle: false,
        ),
        body: isLoading ? loadingPage(context) : exercisePage(context));
  }
}
