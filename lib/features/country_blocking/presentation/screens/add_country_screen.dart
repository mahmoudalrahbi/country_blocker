import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../domain/entities/blocked_country.dart';
import '../../domain/usecases/add_blocked_country.dart';

/// Screen for adding a new country to the blocklist
class AddCountryScreen extends ConsumerStatefulWidget {
  const AddCountryScreen({super.key});

  @override
  ConsumerState<AddCountryScreen> createState() => _AddCountryScreenState();
}

class _AddCountryScreenState extends ConsumerState<AddCountryScreen> {
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  String _isoCode = 'UNKNOWN';
  int _selectedTab = 0; // 0 = Select Country, 1 = Custom Code

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final code = _codeController.text.trim();
    final name = _nameController.text.trim();

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a country code'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final country = BlockedCountry(
      isoCode: _isoCode,
      phoneCode: code,
      name: name.isEmpty ? 'Unknown Region' : name,
    );

    // Use notifier to add country
    final notifier = ref.read(countryBlockingNotifierProvider.notifier);
    await notifier.addCountry(AddBlockedCountryParams(country: country));

    // Check for errors
    final error = ref.read(errorMessageProvider);
    if (error != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      // Clear error
      notifier.clearError();
      return;
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${name.isEmpty ? 'Country' : name} added to blocklist'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Add Block Rule'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Segmented control
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.inputDecorationTheme.fillColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _TabButton(
                        label: 'Select Country',
                        isSelected: _selectedTab == 0,
                        onTap: () {
                          setState(() {
                            _selectedTab = 0;
                            _codeController.clear();
                            _nameController.clear();
                            _isoCode = 'UNKNOWN';
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: _TabButton(
                        label: 'Custom Code',
                        isSelected: _selectedTab == 1,
                        onTap: () {
                          setState(() {
                            _selectedTab = 1;
                            _codeController.clear();
                            _nameController.clear();
                            _isoCode = 'UNKNOWN';
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Form header
              Text(
                _selectedTab == 0 ? 'Select a Country' : 'Enter Custom Rule',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                _selectedTab == 0
                    ? 'Search and select a country from the list to block.'
                    : 'Block calls from specific international or local prefixes.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),

              // Country Code input
              Text(
                'COUNTRY CODE',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                readOnly: _selectedTab == 0,
                onTap: _selectedTab == 0 ? _showCountryPicker : null,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: _selectedTab == 0 ? 'Tap to select country' : '1',
                  prefixText: '+',
                  prefixStyle: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  suffixIcon: _selectedTab == 0
                      ? Icon(Icons.arrow_drop_down,
                          color: theme.colorScheme.onSurfaceVariant)
                      : null,
                ),
              ),
              const SizedBox(height: 24),

              // Name input
              Text(
                'NAME (OPTIONAL)',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: const InputDecoration(
                  hintText: 'e.g. Work Contacts',
                ),
              ),
              const SizedBox(height: 24),

              // Info box
              Card(
                color: theme.colorScheme.surfaceContainerHighest,
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'All incoming calls starting with this prefix will be automatically blocked.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Save button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'Save to Block List',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCountryPicker() {
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
  }
}

/// Custom tab button widget for segmented control
class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? Colors.white
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
        ),
      ),
    );
  }
}
