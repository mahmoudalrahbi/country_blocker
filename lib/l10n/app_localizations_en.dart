// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Country Blocker';

  @override
  String get home => 'Home';

  @override
  String get blocklist => 'Blocklist';

  @override
  String get logs => 'Logs';

  @override
  String get settings => 'Settings';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get notActive => 'Not Active';

  @override
  String get blockingEnabled => 'Blocking Enabled';

  @override
  String get blockingDisabled => 'Blocking Disabled';

  @override
  String get enableBlocking => 'Enable Blocking';

  @override
  String get countriesBlocked => 'Countries Blocked';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get noRecentActivity => 'No recent blocked calls';

  @override
  String get addFirstCountry => 'Add your first country to block';

  @override
  String get addCountry => 'Add Country';

  @override
  String get selectCountry => 'Select Country';

  @override
  String get searchCountry => 'Search Country';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get delete => 'Delete';

  @override
  String get undo => 'Undo';

  @override
  String get itemDeleted => 'Item deleted';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get overview => 'Overview';

  @override
  String get permissionRequired => 'Permissions Required';

  @override
  String get permissionDescription =>
      'To protect you from unwanted calls, Country Blocker needs access to read your phone state and contacts.\n\nWe do not upload or share your data.';

  @override
  String get grantPermissions => 'Grant Permissions';

  @override
  String get openAppSettings => 'Open App Settings';

  @override
  String get pleaseEnterCountryCode => 'Please enter a country code';

  @override
  String get unknownRegion => 'Unknown Region';

  @override
  String countryAddedToBlocklist(String country) {
    return '$country added to blocklist';
  }

  @override
  String get addBlockRule => 'Add Block Rule';

  @override
  String get enterCustomRule => 'Enter Custom Rule';

  @override
  String get selectCountryDescription =>
      'Search and select a country from the list to block.';

  @override
  String get enterCustomRuleDescription =>
      'Block calls from specific international or local prefixes.';

  @override
  String get countryCode => 'COUNTRY CODE';

  @override
  String get tapToSelectCountry => 'Tap to select country';

  @override
  String get nameOptional => 'NAME (OPTIONAL)';

  @override
  String get nameExample => 'e.g. Work Contacts';

  @override
  String get customCode => 'Custom Code';

  @override
  String get blockingDescription =>
      'All incoming calls starting with this prefix will be automatically blocked.';

  @override
  String get saveToBlockList => 'Save to Block List';

  @override
  String get protectionStatus => 'PROTECTION STATUS';

  @override
  String get blockingActive => 'Blocking Active';

  @override
  String get blockingActiveDescription =>
      'Incoming calls from your blocked country list are being automatically rejected.';

  @override
  String get blockingDisabledDescription =>
      'Call blocking is currently disabled. Enable it to start blocking unwanted calls.';

  @override
  String get disableBlocking => 'Disable Blocking';

  @override
  String get blockedCalls => 'Blocked Calls';

  @override
  String get formattedTotalBlocked => 'Total blocked';

  @override
  String get countries => 'Countries';
}
