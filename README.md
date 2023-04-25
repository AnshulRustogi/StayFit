# Stay Fit

## Description
StayFit is a mobile-application built using Flutter & Dart language. The app supports user authentication and displays workout along with instructional videos.

## Demo
[![Watch the video](https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExNDI1MTI3ODMwMjBlNGE3YjQ3MTNlNjgwM2E4YzYzNGQ2ZjJkNzczNCZlcD12MV9pbnRlcm5hbF9naWZzX2dpZklkJmN0PWc/HapMIl8c1kTSys3A9U/giphy.gif)](https://youtu.be/INzK47S8eN0)
## Tech Stack
- [Flutter](https://github.com/flutter/flutter): Flutter is Google's SDK for crafting beautiful, fast user experiences for mobile, web, and desktop from a single codebase.
- [Firbase Authentication](https://firebase.google.com/docs/auth): Supports API-based user authentication, with modern standards OAuth2.0 and OpenID Connect
- [Firestore Database](https://www.google.com/search?client=safari&rls=en&q=firestore+databse&ie=UTF-8&oe=UTF-8): Cloud-based NoSQL database with scalability from Firebase

## Run the app
Note: Make sure Flutter is installed on the system and verify using
```
flutter doctor -v
```
1) Clone to repository
```bash
git clone https://github.com/AnshulRustogi/StayFit
```
2) Change directory to the download repository
```bash
cd StayFit
```
3) Run the following command to get the dependencies
```
flutter pub get
```
### Setting up Firebase
4) After succesfull pull of all required dependencies, set-up firebase for authentication
    - Login onto to [firebase](https://firebase.google.com) and go to console
    - Click on add project, provide a name for reference (Eg: StayFit) and click on continue
    - After the project is loaded, click on Authentication -> Get Started -> Select Native Provider Email/Password, and enable it
    - Now go back to main project page, set up the firebase config files to Andriod and iOS [[Link for reference](https://sharma-vikashkr.medium.com/firebase-how-to-setup-an-app-in-firebase-9ddbacfe8ad1)] and place them in their respective folders
    
### Populating the database

5) Set up cloud firestore and add the following tables:
    1) Start a new collection called **'Users'** where user data like name and email will be stored post sign-up 
    2) Start another new collection called **'Workout'**
        * Add Document put Workout name (Eg: "Yoga")
        * Within the document add the following fields
            * **name**: Type 'string', again provide the workout name, should be same as Workout name
            * **goal**: Type 'array', provides the goal the current workout is servering too (can be multiple)
                Note: Current Supported Goals: "Body Building", "Weight Loss", "Flexibility" [^1]
                [^1]: More types of Goals can be added by editing [lib\screens\after_login_screen.dart](https://github.com/AnshulRustogi/StayFit/blob/main/lib/screens/after_login_screen.dart)
            * **imagePath**: Type 'string', A network based URL for the image of the workout
            * **minutes**: Type 'int', the approximate time required for completing the workout
            * **numberOfExercises**: Type 'int', the number of exercises the proposed workout has
        * Now add a collection called **'Exercises'** within the respective workout document and add the details for each exercises
            * **Document Name**: Put it as 1, 2, 3 and so on
            * Fields for each document
                * **exerciseName**: Type 'string', the name of the exercise
                * **exerciseDescription**: Type 'string', a short description on the exercise
                * **exerciseSteps**: Type 'string', the steps required for doing the workout[^2]
                [^2]: Note: Each set in the workout should be string as 
                    '- Step1 - Step2 - Step3 and so on'
                    Eg: - Stand at the front of your mat with your hands at your heart center. - Inhale and raise your arms overhead, then exhale and fold forward into a standing forward bend. - Inhale and lift halfway up, then exhale and step back into a plank position. - Lower down into a low push-up, then inhale and lift up into upward facing dog. - Exhale and lift your hips up into downward facing dog, then step forward and repeat the sequence.
                * **exerciseDuration**: Type 'int', the number of minutes required for doing the exercise
                * **exerciseImageLink**: Type 'string', the network based url for exercise image which is placed on the exercise card
                * **exerciseVideoLink**: Type 'string', the network based url for exercise instruction video of mp4 format which is placed in the exercise page for user to watch
        * Repeat above sets for each workout and exercise you want to add. 
        Please note: All fields, collection names are case-sensitive

**Sample Firestore screenshots**
<p align="center">
  <img alt="Light" src="https://github.com/anshulrustogi/StayFit/blob/main/images/firestore_user_collection.png?raw=true" width="33%">

  <img alt="Dark" src="https://github.com/anshulrustogi/StayFit/blob/main/images/firestore_workout_collection.png?raw=true" width="33%">
 <img alt="Dark" src="https://github.com/anshulrustogi/StayFit/blob/main/images/firestore_exercise_collection.png?raw=true" width="33%">
</p>


6) Now run the app using
```bash
flutter run
```



