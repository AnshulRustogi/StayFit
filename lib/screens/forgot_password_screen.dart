import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import 'package:get/get.dart';
import '../utilities/alert.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool isLoading = false;
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> forgotPassword() async {
    // isLoading = true;
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text);
      Get.to(() => const LoginScreen());
      alert('Success', 'Email sent to reset password',
          backgroundColor: Colors.green, colorText: Colors.white);
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'user-not-found') {
        alert('Error', 'No user found for that email.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      alert('Error', 'Something wrong happened');
    }
  }

  Widget loadingPage(BuildContext context) {
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
          appBar: AppBar(
            backgroundColor: const Color(0xff0F172A),
            title: const Text(
              'Forgot Password',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: isLoading
                ? loadingPage(context)
                : Container(
                    margin: const EdgeInsets.only(top: 15.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // const Text(
                          //   'Forgot Password',
                          //   style: TextStyle(
                          //     fontSize: 27.0,
                          //     fontWeight: FontWeight.w800,
                          //   ),
                          // ),
                          const Text(
                            'Enter your email',
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
                          // const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 60.0,
                              child: ElevatedButton(
                                onPressed: () {
                                  // signInWithEmailAndPassword();
                                  //Check if email and password is empty
                                  if (_emailController.text.isEmpty ||
                                      _emailController.text.contains("@") ==
                                          false ||
                                      _emailController.text.contains(".") ==
                                          false) {
                                    Get.snackbar(
                                      'Error',
                                      'Please enter a valid email and password',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      duration: const Duration(seconds: 2),
                                    );
                                  } else {
                                    forgotPassword();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0F172A),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14.0),
                                  ),
                                ),
                                child: const Text(
                                  'Continue',
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
          ),
        ));
  }
}
