import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {


    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController usernameController = TextEditingController(); 
    final TextEditingController firstNameController = TextEditingController(); 
    final TextEditingController lastNameController = TextEditingController(); 
    final TextEditingController homePhoneController = TextEditingController(); 
    final TextEditingController cellPhoneController = TextEditingController(); 
    final TextEditingController addressController = TextEditingController();
    final TextEditingController cityController = TextEditingController(); 
    final TextEditingController stateController = TextEditingController();
    final TextEditingController countryController = TextEditingController();
    final TextEditingController zipController = TextEditingController(); 
    final TextEditingController hvacController = TextEditingController(); 
    final TextEditingController sqftController = TextEditingController(); 
    final TextEditingController bedroomsController = TextEditingController(); 
    final TextEditingController bathroomsController = TextEditingController(); 
    final TextEditingController numWaterHeaterController = TextEditingController(); 
    String? typeWaterHeater;
    final TextEditingController storiesController = TextEditingController(); 
    bool isPool = false;
    bool isSewerLine = false;
    final TextEditingController smokeDetectorsController = TextEditingController(); 
    final List<String> waterHeaterTypes = ["Tank", "Tankless", "Unknown"];

    Future<void> signUp() async {
      final email = emailController.text.trim();
      final password = passwordController.text;
      final username = usernameController.text.trim();
      final homePhone = homePhoneController.text.trim().isNotEmpty
        ? int.tryParse(homePhoneController.text.trim())
        : null; 
      final firstName = firstNameController.text.trim();
      final lastName = lastNameController.text;
      final cellPhone = cellPhoneController.text.trim().isNotEmpty
        ? int.tryParse(cellPhoneController.text.trim())
        : null; 
      final address = addressController.text.trim();
      final city = cityController.text;
      final state = stateController.text;
      final country = countryController.text;
      final zipCode = zipController.text.trim().isNotEmpty
        ? int.tryParse(zipController.text.trim())
        : null; 
      final hvac = hvacController.text.trim().isNotEmpty
        ? int.tryParse(hvacController.text.trim())
        : null; 
      final sqft = sqftController.text.trim().isNotEmpty
        ? int.tryParse(sqftController.text.trim())
        : null; 
      final bedrooms = bedroomsController.text.trim().isNotEmpty
        ? int.tryParse(bedroomsController.text.trim())
        : null; 
      final bathrooms = bathroomsController.text.trim().isNotEmpty
        ? int.tryParse(bathroomsController.text.trim())
        : null; 
      final numWaterHeater = numWaterHeaterController.text.trim().isNotEmpty
        ? int.tryParse(numWaterHeaterController.text.trim())
        : null; 
      
      final stories = storiesController.text.trim().isNotEmpty
        ? int.tryParse(storiesController.text.trim())
        : null; 
      final smokeDetectors = smokeDetectorsController.text.trim().isNotEmpty
        ? int.tryParse(smokeDetectorsController.text.trim())
        : null; 

      if (email.isEmpty || password.isEmpty || username.isEmpty ||firstName.isEmpty || lastName.isEmpty || address.isEmpty || city.isEmpty || state.isEmpty || zipCode==null || country.isEmpty) {
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
            'Email':email,
            'UserName': username,
            'First_Name': firstName,
            'Last_Name': lastName,
            'Home_Phone': homePhone,
            'Cell_Phone': cellPhone,
            'Home_Address': address,
            'City': city,
            'State': state,
            'Country': country,
            'Zip_Code': zipCode,
            '#_HVAC': hvac,
            '#_SquareFeet': sqft,
            '#_Bedrooms': bedrooms,
            '#_Bathrooms': bathrooms,
            '#_Water_Heater': numWaterHeater,
            'Water_Heater_Type': typeWaterHeater,
            '#_Stories': stories,
            '#_Smoke_Detectors': smokeDetectors,
            'Pool':isPool,
            'Sewer_Line_Clean_Out':isSewerLine,

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
      appBar: AppBar(title: const Text('Sign Up'), backgroundColor: Colors.green,centerTitle: true),
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
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username (Required)',
                  border: OutlineInputBorder(),
                ),
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
                controller: homePhoneController,
                decoration: const InputDecoration(
                  labelText: 'Home Phone Number (Optional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: cellPhoneController,
                decoration: const InputDecoration(
                  labelText: 'Cell Phone Number (Optional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Street Address (Required)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: 'City (Required)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: stateController,
                decoration: const InputDecoration(
                  labelText: 'State (Required)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: zipController,
                decoration: const InputDecoration(
                  labelText: 'Zip Code (Required)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: countryController,
                decoration: const InputDecoration(
                  labelText: 'Country (Required)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: hvacController,
                decoration: const InputDecoration(
                  labelText: '# Hvac (Optional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: sqftController,
                decoration: const InputDecoration(
                  labelText: '# Square Feet (Optional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: bedroomsController,
                decoration: const InputDecoration(
                  labelText: '# Bedrooms (Optional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: bathroomsController,
                decoration: const InputDecoration(
                  labelText: '# Bathrooms (Optional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: numWaterHeaterController,
                decoration: const InputDecoration(
                  labelText: '# Water Heaters (Optional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Water Heater Type',
                  border: OutlineInputBorder(),
                ),
                value: typeWaterHeater,
                items: waterHeaterTypes.map((typeWaterHeater) {
                  return DropdownMenuItem(
                    value: typeWaterHeater,
                    child: Text(typeWaterHeater),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    typeWaterHeater = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: storiesController,
                decoration: const InputDecoration(
                  labelText: '# Stories (Optional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: smokeDetectorsController,
                decoration: const InputDecoration(
                  labelText: '# Smoke Detectors (Optional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                title: const Text('Do you have a pool'),
                value: isPool,
                onChanged: (bool? value) {
                  setState(() {
                    isPool = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                title: const Text('Do you have a Sewer Line Clean Out'),
                value: isSewerLine,
                onChanged: (bool? value) {
                  setState(() {
                    isSewerLine = value ?? false;
                  });
                },
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
    );
  }
}