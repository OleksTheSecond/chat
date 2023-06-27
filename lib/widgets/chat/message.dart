import 'package:chat_lab/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Messages extends StatelessWidget {
  const Messages(this.speakingUser);
  final String speakingUser;
  final allChat = 'gYo5RXlXPuXkonZWKVkuRGuHqiL2';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        var currentId = FirebaseAuth.instance.currentUser?.uid;
        var allDocs = snapshot.data?.docs;

        var firstChat = allDocs
            ?.where((element) => element['userId'] == currentId)
            .where((element) => element['toUser'] == speakingUser)
            .toList();

        var secondChat = allDocs
            ?.where((element) => element['userId'] == speakingUser)
            .where((element) => element['toUser'] == currentId)
            .toList();

        List<QueryDocumentSnapshot<Map<String, dynamic>>>? chatDocs = [];
        if (firstChat != null && secondChat != null) {
          chatDocs = (firstChat + secondChat);
          chatDocs.sort((a, b) => b['time'].compareTo(a['time']));
        }

        if (speakingUser == allChat) {
          chatDocs = allDocs;
        }
        final user = FirebaseAuth.instance.currentUser;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs?.length,
          itemBuilder: (context, index) => MessageBubble(
            chatDocs?[index]['text'],
            chatDocs?[index]['userId'] == user?.uid,
            chatDocs?[index]['userName'],
            mkey: ValueKey(chatDocs?[index].id),
          ),
        );
      },
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('time', descending: true)
          .snapshots(),
    );
  }
}
