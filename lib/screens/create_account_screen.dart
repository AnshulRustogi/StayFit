import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/firebase_user_info.dart';
import '../screens/login_screen.dart';
import '../utilities/fittrack_text_style.dart';
import 'package:get/get.dart';
import '../network_utils/firebase/user_data_manager.dart';
import '../utilities/fittrack_colors.dart';
import 'after_login_screen.dart';
import '../utilities/alert.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0F172A),
        title: const Text(
          'Create an account',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Your Name',
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintStyle: FittrackTextStyle.hintTextStyle(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(16.0),
                      ),
                      style: const TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'E-mail',
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintStyle: FittrackTextStyle.hintTextStyle(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(16.0),
                      ),
                      style: const TextStyle(color: Colors.black),
                      validator: (value) {
                        if (!EmailValidator.validate(value!)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        hintText: 'Password (8+ characters)',
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintStyle: FittrackTextStyle.hintTextStyle(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(16.0),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: kColorMainApp,
                          ),
                          onPressed: () {
                            if (!_showPassword) {
                              setState(() {
                                _showPassword = true;
                              });
                            } else {
                              setState(() {
                                _showPassword = false;
                              });
                            }
                          },
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a password';
                        } else if (value.length < 8) {
                          return 'Password must be at least 8 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
              const SizedBox(height: 240.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    // onPressed: () {
                    //   createUserWithEmailAndPassword();
                    // },
                    //When pressed, the button will call the createUserWithEmailAndPassword() method in background
                    // and load a loading gif while the user is being created

                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Get.dialog(
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                        final FirebaseUserInfo? user =
                            await createUserWithEmailAndPassword();
                        Get.back();
                        if (user != null) {
                          Get.offAll(() => const AfterLoginScreen());
                        } else {
                          Get.dialog(
                            AlertDialog(
                              title: const Text('Error'),
                              content: const Text(
                                  'Something went wrong\nMaybe the email is already in use, check using Forgot Password'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                    Get.back();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0F172A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      minimumSize: const Size(double.infinity, 60.0),
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Already have an account?',
                    style: TextStyle(
                      color: Color(0xff0F172A),
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  TextButton(
                    onPressed: () {
                      Get.to(() => const LoginScreen());
                    },
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                        color: Color(0xff0F172A),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Moderat',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<FirebaseUserInfo?> createUserWithEmailAndPassword() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final name = _nameController.text.trim();

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      FirebaseUserInfo firebaseUserInfo = FirebaseUserInfo(
          userEmail: user!.email,
          userName: name,
          userProfilePhotoUrl: user.email);

      if (await addUser(user.uid, firebaseUserInfo)) {
        Get.offAll(() => const AfterLoginScreen());
      }
      return firebaseUserInfo;

      // print('Yeni kullanıcı oluşturuldu: ${user.uid}');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        alert('Error', 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        alert('Error', 'The account already exists for that email.');
      }
      // return FirebaseUserInfo;
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
