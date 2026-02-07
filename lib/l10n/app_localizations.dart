import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Country Blocker'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @blocklist.
  ///
  /// In en, this message translates to:
  /// **'Blocklist'**
  String get blocklist;

  /// No description provided for @logs.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get logs;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @notActive.
  ///
  /// In en, this message translates to:
  /// **'Not Active'**
  String get notActive;

  /// No description provided for @blockingEnabled.
  ///
  /// In en, this message translates to:
  /// **'Blocking Enabled'**
  String get blockingEnabled;

  /// No description provided for @blockingDisabled.
  ///
  /// In en, this message translates to:
  /// **'Blocking Disabled'**
  String get blockingDisabled;

  /// No description provided for @enableBlocking.
  ///
  /// In en, this message translates to:
  /// **'Enable Blocking'**
  String get enableBlocking;

  /// No description provided for @countriesBlocked.
  ///
  /// In en, this message translates to:
  /// **'Countries Blocked'**
  String get countriesBlocked;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @noRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent blocked calls'**
  String get noRecentActivity;

  /// No description provided for @addFirstCountry.
  ///
  /// In en, this message translates to:
  /// **'Add your first country to block'**
  String get addFirstCountry;

  /// No description provided for @addCountry.
  ///
  /// In en, this message translates to:
  /// **'Add Country'**
  String get addCountry;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get selectCountry;

  /// No description provided for @searchCountry.
  ///
  /// In en, this message translates to:
  /// **'Search Country'**
  String get searchCountry;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @itemDeleted.
  ///
  /// In en, this message translates to:
  /// **'Item deleted'**
  String get itemDeleted;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @permissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Permissions Required'**
  String get permissionRequired;

  /// No description provided for @permissionDescription.
  ///
  /// In en, this message translates to:
  /// **'To protect you from unwanted calls, Country Blocker needs access to read your phone state and contacts.\n\nWe do not upload or share your data.'**
  String get permissionDescription;

  /// No description provided for @grantPermissions.
  ///
  /// In en, this message translates to:
  /// **'Grant Permissions'**
  String get grantPermissions;

  /// No description provided for @openAppSettings.
  ///
  /// In en, this message translates to:
  /// **'Open App Settings'**
  String get openAppSettings;

  /// No description provided for @pleaseEnterCountryCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter a country code'**
  String get pleaseEnterCountryCode;

  /// No description provided for @unknownRegion.
  ///
  /// In en, this message translates to:
  /// **'Unknown Region'**
  String get unknownRegion;

  /// No description provided for @countryAddedToBlocklist.
  ///
  /// In en, this message translates to:
  /// **'{country} added to blocklist'**
  String countryAddedToBlocklist(String country);

  /// No description provided for @addBlockRule.
  ///
  /// In en, this message translates to:
  /// **'Add Block Rule'**
  String get addBlockRule;

  /// No description provided for @enterCustomRule.
  ///
  /// In en, this message translates to:
  /// **'Enter Custom Rule'**
  String get enterCustomRule;

  /// No description provided for @selectCountryDescription.
  ///
  /// In en, this message translates to:
  /// **'Search and select a country from the list to block.'**
  String get selectCountryDescription;

  /// No description provided for @enterCustomRuleDescription.
  ///
  /// In en, this message translates to:
  /// **'Block calls from specific international or local prefixes.'**
  String get enterCustomRuleDescription;

  /// No description provided for @countryCode.
  ///
  /// In en, this message translates to:
  /// **'COUNTRY CODE'**
  String get countryCode;

  /// No description provided for @tapToSelectCountry.
  ///
  /// In en, this message translates to:
  /// **'Tap to select country'**
  String get tapToSelectCountry;

  /// No description provided for @nameOptional.
  ///
  /// In en, this message translates to:
  /// **'NAME (OPTIONAL)'**
  String get nameOptional;

  /// No description provided for @nameExample.
  ///
  /// In en, this message translates to:
  /// **'e.g. Work Contacts'**
  String get nameExample;

  /// No description provided for @customCode.
  ///
  /// In en, this message translates to:
  /// **'Custom Code'**
  String get customCode;

  /// No description provided for @blockingDescription.
  ///
  /// In en, this message translates to:
  /// **'All incoming calls starting with this prefix will be automatically blocked.'**
  String get blockingDescription;

  /// No description provided for @saveToBlockList.
  ///
  /// In en, this message translates to:
  /// **'Save to Block List'**
  String get saveToBlockList;

  /// No description provided for @permissionRequiredToEnable.
  ///
  /// In en, this message translates to:
  /// **'Permissions required to enable blocking'**
  String get permissionRequiredToEnable;

  /// No description provided for @deleteBlocklistEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove from blocklist?'**
  String get deleteBlocklistEntryTitle;

  /// No description provided for @deleteBlocklistEntryMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {country} from the blocklist?'**
  String deleteBlocklistEntryMessage(String country);

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @tapToAdd.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add one'**
  String get tapToAdd;

  /// No description provided for @blockingStateChanged.
  ///
  /// In en, this message translates to:
  /// **'{country} blocking {state}'**
  String blockingStateChanged(String country, String state);

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'disabled'**
  String get disabled;

  /// No description provided for @clearLogsTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Logs?'**
  String get clearLogsTitle;

  /// No description provided for @clearLogsMessage.
  ///
  /// In en, this message translates to:
  /// **'This will delete all call history. This action cannot be undone.'**
  String get clearLogsMessage;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'YESTERDAY'**
  String get yesterday;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'JUST NOW'**
  String get justNow;

  /// No description provided for @protectionStatus.
  ///
  /// In en, this message translates to:
  /// **'PROTECTION STATUS'**
  String get protectionStatus;

  /// No description provided for @blockingActive.
  ///
  /// In en, this message translates to:
  /// **'Blocking Active'**
  String get blockingActive;

  /// No description provided for @blockingActiveDescription.
  ///
  /// In en, this message translates to:
  /// **'Incoming calls from your blocked country list are being automatically rejected.'**
  String get blockingActiveDescription;

  /// No description provided for @blockingDisabledDescription.
  ///
  /// In en, this message translates to:
  /// **'Call blocking is currently disabled. Enable it to start blocking unwanted calls.'**
  String get blockingDisabledDescription;

  /// No description provided for @disableBlocking.
  ///
  /// In en, this message translates to:
  /// **'Disable Blocking'**
  String get disableBlocking;

  /// No description provided for @blockedCalls.
  ///
  /// In en, this message translates to:
  /// **'Blocked Calls'**
  String get blockedCalls;

  /// No description provided for @formattedTotalBlocked.
  ///
  /// In en, this message translates to:
  /// **'Total blocked'**
  String get formattedTotalBlocked;

  /// No description provided for @countries.
  ///
  /// In en, this message translates to:
  /// **'Countries'**
  String get countries;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @helpCenterComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Help Center coming soon'**
  String get helpCenterComingSoon;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'Block unwanted international calls by country code. Take control of your phone and protect yourself from spam and fraud.'**
  String get aboutDescription;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'© 2026 {appTitle}. All rights reserved.'**
  String copyright(String appTitle);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
