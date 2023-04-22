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
      if (intervalWait == 20) {
        setState(() {
          isError = true;
          isLoading = true;
        });
        break;
      }
      if (exerciseList.isNotEmpty) {
        //Duplicate the exercliseList[0] 20 times
        for (int i = 0; i < 20; i++) {
          exerciseList.add(exerciseList[0]);
        }
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
                          // display heading without any margin at the top or padding at the bottom
                          // Container(child: Placeholder())
                          // Container which shows workout name in bold and a large font size
                          // Then in the next line below the workout name it shows, in very light purple color, the number of exercises in the workout along with a icon of dumbbell
                          // Then in the same line it shows the duration of the workout in minutes along with a icon of clock
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
                                      fontSize: 25,
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
                              children: List.generate(exerciseList.length,
                                  (index) => exercise(context, index)),
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

  Widget exercise(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        print("Exercise ${index + 1} clicked");
      },
      child: Container(
        width: double.infinity,
        height: 100,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                              widget.workout.imagePath,
                              fit: BoxFit.cover,
                            ))),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(exerciseList[index].exerciseName,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          const Text("Exercies",
                              style: TextStyle(
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
      ),
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