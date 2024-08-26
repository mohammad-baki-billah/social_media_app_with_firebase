import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app_with_firebase/components/my_button.dart';
import 'package:social_media_app_with_firebase/components/my_textfield.dart';
import 'package:social_media_app_with_firebase/helper/helper_functions.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // login method
  void login() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    //try sing in user
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      // pop the loading circle
      if (context.mounted) Navigator.pop(context);
    }
    // display error message
    on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      displayMessageToUser(e.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              Icon(Icons.person,
                  size: 40,
                  color: Theme.of(context).colorScheme.inversePrimary),
              const SizedBox(
                height: 20,
              ),

              // app name
              const Text(
                'M I N I M A L',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 50,
              ),
              // email textfield
              MyTextfield(
                  hintText: 'Email',
                  obscureText: false,
                  controller: emailController),

              const SizedBox(
                height: 10,
              ),

              // password textfield
              MyTextfield(
                hintText: 'Password',
                obscureText: true,
                controller: passwordController,
              ),
              const SizedBox(
                height: 10,
              ),
              // forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Forgot Password?',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ],
              ),

              const SizedBox(
                height: 25,
              ),
              // sing in button
              MyButton(text: 'Login', onTap: login),
              const SizedBox(
                height: 25,
              ),
              // don't have an account? register here
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("Don't have an accoutn? "),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "Register Here",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
