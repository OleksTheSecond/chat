import 'package:chat_lab/widgets/chat/message.dart';
import 'package:chat_lab/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen(this.speakingUserId);

  final String speakingUserId;

  @override
  Widget build(BuildContext context) {
    final firebasPath = "chats/z3Q25OkanlFzkHMXMfcD/messages";

    return Scaffold(
      appBar: AppBar(
        title: const Text('SomeChat'),
      ),
      body: Container(
        child: Column(children: [
          Expanded(child: Messages(speakingUserId)),
          NewMessage(speakingUserId)
        ]),
      ),
    );
  }
}
