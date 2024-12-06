import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController firstNameController = TextEditingController(); 
    final TextEditingController lastNameController = TextEditingController(); 
    final TextEditingController cellPhoneController = TextEditingController(); 


    Future<void> signUp() async {
      final email = emailController.text.trim();
      final password = passwordController.text;
    
      final firstName = firstNameController.text.trim();
      final lastName = lastNameController.text;
      final cellPhone = cellPhoneController.text.trim();

      if (email.isEmpty || password.isEmpty ||firstName.isEmpty || lastName.isEmpty || cellPhone.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fields are required')),
        );
        return;
      }

      try {
        // Sign up the user
        final response = await Supabase.instance.client.auth.signUp(
          email: email,
          password: password,
        );
   
        if (response.user != null) {
          // Add custom fields to 'profiles' table
          await Supabase.instance.client.from('clients').insert({
            'Client_Email':email,
            'First_Name': firstName,
            'Last_Name': lastName,
            'Cell_Phone': cellPhone,
 
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign-up successful! Please log in.')),
          );
          
          Navigator.pop(context); // Navigate back to the login screen
        } 
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unexpected error: $e')),
        );
      }
    }
  

     @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up'), backgroundColor: Colors.blue,centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email (Required)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password (Required)',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),        
              const SizedBox(height: 10),
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name (Required)',
                  border: OutlineInputBorder(),
                ),
              ),
               const SizedBox(height: 10),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name (Required)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: cellPhoneController,
                decoration: const InputDecoration(
                  labelText: 'Cell Phone Number (Required)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: signUp,
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}