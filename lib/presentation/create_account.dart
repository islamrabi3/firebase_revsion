import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_revsion/presentation/home_page.dart';
import 'package:firebase_revsion/services/firebase_services/auth_services.dart';
import 'package:flutter/material.dart';

class CreateNewAccount extends StatefulWidget {
  const CreateNewAccount({super.key});

  @override
  State<CreateNewAccount> createState() => _CreateNewAccountState();
}

class _CreateNewAccountState extends State<CreateNewAccount> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Create New Account'),
            TextField(
              decoration: const InputDecoration(hintText: 'Email'),
              controller: emailController,
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Password'),
              controller: passwordController,
            ),
            ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  firebaseAuthServices
                      .createUserWithEmailAndPassword(
                          emailController.text, passwordController.text)
                      .then((value) async {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(value.user!.uid)
                        .set({'email': value.user?.email});

                    setState(() {
                      isLoading = false;
                    });
                    navigateReplacement(const ImageUploader(), context);
                  });
                },
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Create Account'))
          ],
        ),
      ),
    );
  }
}

navigateReplacement(Widget widget, BuildContext context) {
  return Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => widget));
}
