import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app_with_firebase/components/my_button.dart';
import 'package:social_media_app_with_firebase/components/my_textfield.dart';

import '../helper/helper_functions.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text controllers
  final userController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confiremPasswordController = TextEditingController();

  // register method
  void registerUser() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    // make sure passwords match
    if (passwordController.text != confiremPasswordController.text) {
      // pop loading circle
      Navigator.pop(context);

      // show error message to user
      displayMessageToUser('Passwords don\'t match!', context);
      return;
    }
    // if passwords match
    else {
      // try creating user
      try {
        // create the user

        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        // create new user document and add to firestore
        createUserDocument(userCredential);
        // pop loading circle
        if(context.mounted) Navigator.pop(context);
        // continue with additional logic if needed, like navigating to another page or saving user info
      } on FirebaseAuthException catch (e) {
        // pop loading circle
        Navigator.pop(context);

        // show error message to user
        displayMessageToUser(e.message ?? 'An error occurred', context);
      }
    }
  }

  // creat user document and collect them in firestore
  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'username': userController.text
      });
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
              Icon(
                Icons.person,
                size: 40,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "M I N I M A L",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 50,
              ),

              // username textfield
              MyTextfield(
                hintText: "Username",
                obscureText: false,
                controller: userController,
              ),
              SizedBox(
                height: 10,
              ),

              // email textfield
              MyTextfield(
                hintText: "Email",
                obscureText: false,
                controller: emailController,
              ),
              SizedBox(
                height: 10,
              ),

              // password textfield
              MyTextfield(
                  hintText: "Password",
                  obscureText: true,
                  controller: passwordController),
              SizedBox(
                height: 10,
              ),

              // confirm password textfield
              MyTextfield(
                  hintText: "Confirm Password",
                  obscureText: true,
                  controller: confiremPasswordController),

              SizedBox(
                height: 10,
              ),

              // forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Forgot Password?",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),

              // Register button
              MyButton(text: "Register", onTap: registerUser),

              SizedBox(
                height: 20,
              ),

              // Already have an account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Login here",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
