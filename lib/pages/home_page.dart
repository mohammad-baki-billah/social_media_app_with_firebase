import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app_with_firebase/components/my_drawer.dart';
import 'package:social_media_app_with_firebase/components/my_list_tile.dart';
import 'package:social_media_app_with_firebase/components/my_posts_button.dart';
import 'package:social_media_app_with_firebase/components/my_textfield.dart';

import '../database/firestore.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // firestore access
  final FirestoreDatabase database = FirestoreDatabase();

  // text controller
  final TextEditingController newPostController = TextEditingController();

  // posts message
  void postMessage() {
    // only post messages if there is somting in the textfield
    if (newPostController.text.isEmpty) {
      String message = newPostController.text;
      database.addPost(message);
    }

    // clear the controller
    newPostController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('W A L L'),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          // textfield box for user type
          Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              children: [
                // textfield
                Expanded(
                  child: MyTextfield(
                      hintText: "Say something...",
                      obscureText: false,
                      controller: newPostController),
                ),

                // posts button
                MyPostButton(onTap: postMessage),
              ],
            ),
          ),
          // posts
          StreamBuilder(
              stream: database.getPostsStream(),
              builder: (context, snapshot) {
                // show loading circle
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // get all posts
                final posts = snapshot.data!.docs;

                // no dada?
                if (snapshot.data == null || posts.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(25),
                      child: Text("No post.. Post something!"),
                    ),
                  );
                }

                // return as a list
                return Expanded(
                  child: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        // get each individual post
                        final post = posts[index];

                        // get data from each post
                        String message = post['PostMessage'];
                        String userEmail = post['UserEmail'];
                        // ignore: unused_local_variable
                        Timestamp timestamp = post['TimeStamp'];

                        // return as a list tile
                        return MyListTile(title: message, subtitle: userEmail);
                      }),
                );
              })
        ],
      ),
    );
  }
}
