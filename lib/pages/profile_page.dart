import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app_with_firebase/components/my_back_button.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  //current logged in user
  final User? currentUser = FirebaseAuth.instance.currentUser;

  //future to fatch user details
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.email)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserDetails(),
        builder: (context, snapshot) {
          // loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // error state
          else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          // data recived
          else if (snapshot.hasData) {
            // extract data
            Map<String, dynamic>? user = snapshot.data?.data();

            return Center(
              child: Column(          
                children: [
                  // back button
                  const Padding(
                    padding:  EdgeInsets.only(top: 10.0, left: 25),
                    child: Row(
                      children: [
                        MyBackButton(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25,),

                  // profile picture
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(25),
                    child: const Icon(
                      Icons.person,
                      size: 64,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  // Username and email
                  Text(
                    user!['username'],
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    user['email'],
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          } else {
            return const Text('No data');
          }
        },
      ),
    );
  }
}
