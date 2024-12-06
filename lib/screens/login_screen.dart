import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'signup_screen.dart';
import '../client_screens/client_home_screen.dart';
import 'package:provider/provider.dart';
import '../client_screens/notification_message.dart';
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    Future<void> login() async {
      try {
        final response = await Supabase.instance.client.auth.signInWithPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Provider.of<NotificationProvider>(context, listen: false).messages;
        if (response.session != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ClientHomeScreen()),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Login"), backgroundColor: Colors.blue,centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: const Text("Login")),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                  
                );
              },
              child: const Text("Sign Up"),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}