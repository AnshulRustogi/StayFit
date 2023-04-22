class Exercise {
  final String exerciseDescription;
  final int exerciseDuration;
  final String exerciseName;
  final String exerciseSteps;
  final String exerciseVideoLink;
  final String exerciseImageLink;

  const Exercise(
      {required this.exerciseDescription,
      required this.exerciseDuration,
      required this.exerciseName,
      required this.exerciseSteps,
      required this.exerciseVideoLink,
      required this.exerciseImageLink})
      : super();

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
}
