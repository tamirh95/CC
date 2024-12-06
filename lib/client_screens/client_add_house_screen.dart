import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'client_settings_screen.dart';

class AddHouseScreen extends StatefulWidget {
  const AddHouseScreen({super.key});

  @override
  State<AddHouseScreen> createState() => _AddHouseScreenState();
}

class _AddHouseScreenState extends State<AddHouseScreen> {
    final SupabaseClient supabase = Supabase.instance.client;
    final email = Supabase.instance.client.auth.currentUser?.email;
    
    final TextEditingController addressController = TextEditingController();
    final TextEditingController cityController = TextEditingController(); 
    final TextEditingController stateController = TextEditingController();
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

    Future<void> addHouse() async {
      final address = addressController.text.trim();
      final city = cityController.text.trim();
      final state = stateController.text.trim();
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

      if (address.isEmpty || city.isEmpty || state.isEmpty || zipCode==null ) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fields are required')),
        );
        return;
      }

      await Supabase.instance.client.from('houses').insert({
        'Owner_Email': email.toString(),
        
        'Home_Address': address,
        'City': city,
        'State': state,
        'Zip_Code': zipCode,
        '#_HVAC': hvac,
        '#_SquareFeet': sqft,
        '#_Bedrooms': bedrooms,
        '#_Bathrooms': bathrooms,
        '#_Water_Heater': numWaterHeater,
        'Type_Water_Heater': typeWaterHeater,
        '#_Stories': stories,
        '#_Smoke_Detectors': smokeDetectors,
        'Pool':isPool,
        'Sewer_Line_Clean_Out':isSewerLine,

          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Added Home')),
          );
          
          Navigator.pop(context); 
        

    }
  

     @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Home'), 
      backgroundColor: Colors.blue,
      centerTitle: true,
      leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
             Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen(),),
      (route) => false,

    );
          },
        ),),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             
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
                onPressed: addHouse,
                child: const Text('Add Home'),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}