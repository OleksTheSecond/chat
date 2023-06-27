import 'package:chat_lab/screens/auth_screen.dart';
import 'package:chat_lab/screens/chat_screen.dart';
import 'package:chat_lab/screens/users_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatLab',
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              color: Colors.purpleAccent,
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20)),
          colorSchemeSeed: Colors.purpleAccent,
          brightness: Brightness.light,
          useMaterial3: true),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return UsersSreen();
                }
                return AuthScreen();
              },
              stream: FirebaseAuth.instance.authStateChanges(),
            );
          }
          return Container();
        },
      ),
    );
  }
}
