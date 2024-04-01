// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/api/api.dart';
import 'package:pomodoro/api/auth.dart';
import 'package:pomodoro/screens/main_screens/HomeScreen.dart';
import 'package:pomodoro/utils/helper.dart';
import 'package:pomodoro/utils/local_storage.dart';
import 'package:pomodoro/utils/urls.dart';
import 'package:pomodoro/widgets/custom_button.dart';
import 'package:pomodoro/widgets/custom_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalStorage localStorage = LocalStorage();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String email = '';
  String password = '';
  String error = '';

  bool isObscure = true;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  handleLogin() {
    FocusScope.of(context).unfocus();
    setState(() {
      isLoading = true;
    });

    String loginUrl = URLS.kLoginUrl;
    Map<String, dynamic> loginData = {
      'email': email,
      'password': password,
    };

    APIService()
        .sendAuthRequest(
      loginUrl,
      loginData,
    )
        .then((data) async {
      FocusScope.of(context).unfocus();

      if (data['status'] == 200) {
        print(data);
        await localStorage.writeData('user', data['data']['user']);
        await localStorage.writeStringData('token', data['data']['token']);

        Helper().showSnackBar(
          context,
          'Login Successful',
          Theme.of(context).primaryColor,
        );
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      } else {
        setState(() {
          isLoading = false;
          error = data['error'];
        });
        Helper().showSnackBar(
          context,
          error,
          Colors.red,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Pomodoro',
                    style: TextStyle(
                      fontSize: 35,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Login to continue',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 25),
                  CustomTextFormField(
                    width: width,
                    // autofocus: true,
                    controller: emailController,
                    labelText: 'Email',
                    hintText: 'Email Address',
                    prefixIcon: Icons.email,
                    textCapitalization: TextCapitalization.none,
                    borderRadius: 10,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    width: width,
                    controller: passwordController,
                    labelText: 'Password',
                    hintText: 'Password',
                    prefixIcon: Icons.lock,
                    suffixIcon:
                        !isObscure ? Icons.visibility : Icons.visibility_off,
                    textCapitalization: TextCapitalization.none,
                    borderRadius: 10,
                    keyboardType: TextInputType.visiblePassword,
                    isObscure: isObscure,
                    suffixIconOnPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Forgot Password?'),
                    ),
                  ),
                  CustomButton(
                    text: 'Login',
                    isLoading: isLoading,
                    isDisabled: isLoading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        handleLogin();
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'or',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildGoogleButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleButton() {
    signInWithGoogle() async {
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      setState(() {
        isLoading = true;
      });

      // // Trigger the authentication flow
      // final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // // Obtain the auth details from the request
      // final GoogleSignInAuthentication? googleAuth =
      //     await googleUser?.authentication;

      // // Create a new credential
      // final credential = GoogleAuthProvider.credential(
      //   accessToken: googleAuth?.accessToken,
      //   idToken: googleAuth?.idToken,
      // );
      // print(credential);
      // print(googleUser);

      setState(() {
        isLoading = false;
      });

      // Once signed in, return the UserCredential
      // return await FirebaseAuth.instance.signInWithCredential(credential);
    }

    return GestureDetector(
      onTap: !isLoading ? signInWithGoogle : null,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: !isLoading
              ? Theme.of(context).primaryColor
              : Theme.of(context).primaryColor.withOpacity(0.5),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/google.png',
              width: 25,
              height: 25,
            ),
            const SizedBox(width: 10),
            Text(
              !isLoading ? 'Sign in with Google' : 'Signing in...',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
