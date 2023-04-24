import 'package:StayFit/utilities/alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:StayFit/models/exercise.dart';
import 'package:StayFit/utilities/fittrack_text_style.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:video_player/video_player.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final List<Exercise> exerciseList;
  final int currentExerciseIndex;
  // ignore: prefer_const_constructors_in_immutables
  ExerciseDetailScreen(
      {Key? key,
      required this.exerciseList,
      required this.currentExerciseIndex})
      : super(key: key);

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  late VideoPlayerController _controller;
  Future<void>? _initializeVideoPlayerFuture;
  bool isLoading = true;
  bool isError = false;
  late int currentIndex;
  String userUid = FirebaseAuth.instance.currentUser!.uid;
  late List<Exercise> exerciseList;

  @override
  void initState() {
    super.initState();

    isLoading = false;
    currentIndex = widget.currentExerciseIndex;
    exerciseList = widget.exerciseList;
    _controller = VideoPlayerController.network(
        exerciseList[currentIndex].exerciseVideoLink);
    _initializeVideoPlayerFuture = _controller.initialize().catchError(
      (error) {
        setState(() {
          isError = true;
        });
      },
    );

    _controller.setLooping(false);
    _controller.setVolume(1.0);

    //
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

  Widget mainPage(BuildContext context) {
    return Column(
      children: [
        Column(children: [
          videoPlayerWidget(context),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.all(15),
            // Set height of the container to remaining height of the screen
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                kToolbarHeight -
                380,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(exerciseList[currentIndex].exerciseName,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    exerciseList[currentIndex].exerciseDescription,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          stepsList(exerciseList[currentIndex].exerciseSteps)
                              .length,
                      itemBuilder: (context, index) {
                        return Text(
                          "${index + 1}) ${stepsList(exerciseList[currentIndex].exerciseSteps)[index]}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        );
                      }),
                ],
              ),
            ),
          ),
        ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 50,
              child: FloatingActionButton.extended(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                icon: const Icon(Icons.navigate_before),
                label: const Text("Back"),
                onPressed: () {
                  setState(() {
                    currentIndex -= 1;

                    //Checking if currentIndex == length of exerciseList if yes then go back and also raise an alert that all workouts have been finised
                    if (currentIndex < 0) {
                      currentIndex = 0;
                      alert("Wait wait",
                          "Already at the first exercise\nClick Button on top to go back",
                          backgroundColor: Colors.green,
                          colorText: Colors.white);
                    }
                    _controller.pause();
                    _controller.dispose();
                    _controller = VideoPlayerController.network(
                        exerciseList[currentIndex].exerciseVideoLink);
                    _initializeVideoPlayerFuture =
                        _controller.initialize().catchError((error) => {
                              setState(() {
                                isError = true;
                              })
                            });
                    _controller.setLooping(false);
                    _controller.setVolume(1);
                  });
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 50,
              child: FloatingActionButton.extended(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                icon: const Icon(Icons.navigate_next),
                label: const Text("Next"),
                onPressed: () {
                  setState(() {
                    currentIndex += 1;
                    //Checking if currentIndex == length of exerciseList if yes then go back and also raise an alert that all workouts have been finised
                    if (currentIndex == exerciseList.length) {
                      Get.back();
                      Get.snackbar("All workouts completed",
                          "You have completed all the workouts for today",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white);
                    }
                    _controller.pause();
                    _controller.dispose();
                    _controller = VideoPlayerController.network(
                        exerciseList[currentIndex].exerciseVideoLink);
                    _initializeVideoPlayerFuture =
                        _controller.initialize().catchError((error) => {
                              setState(() {
                                isError = true;
                              })
                            });
                    _controller.setLooping(false);
                    _controller.setVolume(1);
                  });
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  List<String> stepsList(String steps) {
    List<String> exerciseSteps;
    exerciseSteps = exerciseList[currentIndex].exerciseSteps.split("- ");
    exerciseSteps = exerciseSteps.sublist(1);
    return exerciseSteps;
  }

  Widget videoPlayerWidget(BuildContext context) {
    return isError
        ? Container(
            padding: const EdgeInsets.all(10),
            child: const Center(
              child: Text("Something went wrong",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                      fontWeight: FontWeight.w900)),
            ),
          )
        : Container(
            // height: MediaQuery.of(context).size.height / 2.8,
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              child: Column(
                children: [
                  FutureBuilder(
                      future: _initializeVideoPlayerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: AspectRatio(
                                // aspectRatio: _controller.value.aspectRatio,
                                // Fix ascept ratio: to 16:9
                                aspectRatio: 16.0 / 9.0,
                                child: VideoPlayer(_controller)),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  FloatingActionButton.extended(
                    backgroundColor: const Color(0xff0F172A),
                    icon: Icon(_controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow),
                    label: _controller.value.isPlaying
                        ? const Text("Pause")
                        : const Text("Play"),
                    onPressed: () {
                      setState(() {
                        if (_controller.value.isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                        }
                      });
                    },
                  ),
                ],
              ),
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
            "Back",
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
        body: isLoading ? loadingPage(context) : mainPage(context));
  }
}
