import 'package:flutter/material.dart';
import 'package:hicodechildrights/button.dart';
import 'package:hicodechildrights/color.dart';
import 'package:hicodechildrights/log_in.dart';
import 'package:hicodechildrights/sign_up.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kayıt Ol'),
        foregroundColor: Colors.white,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppGradients.primaryGradient,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              // Logo and Title
              Column(
                children: [
                  Image.asset(
                    'lib/images/logo.png', // Replace with your logo path
                    height: 200,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Email Field
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Email adresinizi yazın',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Password Field
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  hintText: 'Şifrenizi yazın',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Confirm Password Field
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Şifre Tekrarı',
                  hintText: 'Şifrenizi yazın',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Gradient Button
              GradientButton(
                text: 'Kayıt Ol',
                onPressed: () {
                  Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LogInPage()),
                      );
                },
              ),
              const SizedBox(height: 20),
              // Or Divider
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('Or'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 20),
              // Social Login Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: IconButton(
                      icon: Image.asset(
                        'lib/images/google.png',
                        width: 30, // Width
                        height: 30, // Height
                        fit: BoxFit.contain, // Prevent image overflow
                      ),
                      iconSize: 40,
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    child: IconButton(
                      icon: Image.asset(
                        'lib/images/apple.png',
                        width: 60, // Width
                        height: 60, // Height
                        fit: BoxFit.contain, // Prevent image overflow
                      ),
                      iconSize: 40,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Log In Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Hesabın var mı? ',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LogInPage()),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero, // Limit button size to text
                      minimumSize: Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Giriş Yap',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
