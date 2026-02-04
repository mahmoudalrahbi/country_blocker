import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/blocked_provider.dart';
import 'add_country_screen.dart';

import 'dart:io';
import '../services/permissions_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BlockedProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Blocker'),
        centerTitle: true,
        actions: [
          if (Platform.isAndroid)
            IconButton(
              icon: const Icon(Icons.shield),
              tooltip: 'Enable Call Blocking',
              onPressed: () {
                PermissionsService.requestRole();
              },
            ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.blockedList.isEmpty
              ? const Center(
                  child: Text(
                    'No blocked countries yet.\nTap + to add one.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: provider.blockedList.length,
                  itemBuilder: (context, index) {
                    final country = provider.blockedList[index];
                    return ListTile(
                      leading: Text(
                        country.isoCode,
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(country.name),
                      subtitle: Text('+${country.phoneCode}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          provider.removeCountry(country.phoneCode);
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddCountryScreen(),
            ),
          );
        },
      ),
    );
  }
}
