import 'package:flutter/material.dart';
import 'package:hicodechildrights/forgot_password.dart';
import 'package:hicodechildrights/log_in.dart';
import 'package:hicodechildrights/otp_verification.dart';
import 'package:hicodechildrights/sign_up.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LogInPage(),
    );
  }
}
