import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/blocked_country.dart';
import '../providers/blocked_provider.dart';

class AddCountryScreen extends StatefulWidget {
  const AddCountryScreen({super.key});

  @override
  State<AddCountryScreen> createState() => _AddCountryScreenState();
}

class _AddCountryScreenState extends State<AddCountryScreen> {
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  String _isoCode = 'UNKNOWN'; // Default

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _save() {
    final code = _codeController.text.trim();
    final name = _nameController.text.trim();

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a country code')),
      );
      return;
    }

    final country = BlockedCountry(
      isoCode: _isoCode,
      phoneCode: code,
      name: name.isEmpty ? 'Unknown Region' : name,
    );

    Provider.of<BlockedProvider>(context, listen: false).addCountry(country);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Block Country')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.public),
              label: const Text('Select from List'),
              onPressed: () {
                showCountryPicker(
                  context: context,
                  showPhoneCode: true,
                  onSelect: (Country country) {
                    setState(() {
                      _codeController.text = country.phoneCode;
                      _nameController.text = country.name;
                      _isoCode = country.countryCode; 
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            const Text('Or enter manually:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Phone Code (e.g. 1, 44)',
                prefixText: '+',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Country Name (Optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text('BLOCK THIS COUNTRY'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
