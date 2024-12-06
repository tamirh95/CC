import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HouseDropdownArrayWidget extends StatefulWidget {
  final String rowId; // ID of the row in example_table
  final Function(String) onValueSelected;
  const HouseDropdownArrayWidget({super.key, required this.rowId, required this.onValueSelected});

  @override
  _HouseDropdownArrayWidgetState createState() => _HouseDropdownArrayWidgetState();
}

class _HouseDropdownArrayWidgetState extends State<HouseDropdownArrayWidget> {
   final SupabaseClient supabase = Supabase.instance.client;
 String? selectedValue;
  List<Map<String, dynamic>> options = []; 


  @override
  void initState() {
    super.initState();
    _fetchOptions();
  }


  Future<void> _fetchOptions() async {
      
      
      final response = await supabase
          .from('clients')
          .select('House_ID')
          .eq('Client_Email', widget.rowId)
          .single();
     
    
        
        List<dynamic> uuids = List<dynamic>.from(response['House_ID']);
    
        // Fetch names from areas for the UUIDs
      
          final nameResponse = await supabase
              .from('houses') // Replace with your table name
              .select('House_id,Home_Address')
              .inFilter('House_id', uuids);
        
         
            setState(() {
              options = List<Map<String, dynamic>>.from(nameResponse);
            });
         
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedValue,
      items: options.map((option) {
        return DropdownMenuItem<String>(
          value: option['House_id'],
          child: Text(option['Home_Address']),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedValue = value;
        });
        widget.onValueSelected(value!); // Call the callback with the selected value
      },
      hint: const Text('Select an option'),
    );
  }
}
