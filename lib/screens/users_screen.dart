import 'package:chat_lab/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class UsersSreen extends StatelessWidget {
  const UsersSreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SomeChat'),
        actions: [
          DropdownButton(
            underline: Container(),
            iconEnabledColor: Colors.black,
            items: [
              DropdownMenuItem(
                  value: 'logout',
                  child: Container(
                    child: Row(children: const [
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 6,
                      ),
                      Text("Вийти")
                    ]),
                  ))
            ],
            onChanged: (value) {
              if (value == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: StreamBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final users = snapshot.data?.docs;
          final userEmail = FirebaseAuth.instance.currentUser?.uid;

          return StreamBuilder(
            builder: (ctx, snp) {
              return ListView.builder(
                  itemCount: users?.length,
                  itemBuilder: (context, index) => users?[index].id != userEmail
                      ? Card(
                          margin: EdgeInsets.all(15),
                          child: Padding(
                              padding: EdgeInsets.all(8),
                              child: ListTile(
                                title: Text(users?[index]['username']),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChatScreen(users![index].id)),
                                  );
                                },
                              )),
                        )
                      : Container());
            },
            stream: FirebaseFirestore.instance.collection("chat").snapshots(),
          );
        },
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
      ),
    );
  }
}
