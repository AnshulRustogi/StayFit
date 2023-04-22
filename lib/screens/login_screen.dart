import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/create_account_screen.dart';
import '../screens/after_login_screen.dart';
import '../screens/forgot_password_screen.dart';
import 'package:get/get.dart';
import '../utilities/alert.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> signInWithEmailAndPassword() async {
    // isLoading = true;
    setState(() {
      isLoading = true;
    });
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      if (userCredential.user != null) {
        Get.to(() => const AfterLoginScreen());
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'user-not-found') {
        alert('Error', 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        alert('Error', 'Wrong password provided for that user.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
      alert('Error', 'Something wrong happened');
    }
  }

  Widget loadingPage(BuildContext context) {
    print("Function called");
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  // @override
  // void initState() {
  //   super.initState();
  //   isLoading = false;
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: isLoading
            ? loadingPage(context)
            : Container(
                margin: const EdgeInsets.only(top: 102.0),
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Hi, Welcome back',
                      style: TextStyle(
                        fontSize: 27.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Text(
                      'Login in to your account',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Your Email',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: const TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: const TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 15.0),
                    ElevatedButton(
                      onPressed: () {
                        Get.to(() => const ForgotPasswordScreen());
                      },
                      //Remove the button border and button background color
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        shadowColor: Colors.white,
                        elevation: 0,
                      ),
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 60.0,
                        child: ElevatedButton(
                          onPressed: () {
                            signInWithEmailAndPassword();
                            if (_emailController.text.isEmpty ||
                                _passwordController.text.isEmpty ||
                                _emailController.text.contains("@") == false ||
                                _emailController.text.contains(".") == false) {
                              // Get.snackbar(
                              //   'Error',
                              //   'Please enter a valid email and password',
                              //   snackPosition: SnackPosition.BOTTOM,
                              //   backgroundColor: Colors.red,
                              //   colorText: Colors.white,
                              //   duration: const Duration(seconds: 2),
                              // );
                              alert('Error',
                                  'Please enter a valid email and password');
                            } else {
                              signInWithEmailAndPassword();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F172A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 150.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 60.0,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => const CreateAccountScreen());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 0, 4, 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
