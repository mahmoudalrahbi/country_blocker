import 'package:country_blocker/core/error/failures.dart';
import 'package:country_blocker/core/providers.dart';
import 'package:country_blocker/core/usecase/usecase.dart';
import 'package:country_blocker/features/country_blocking/domain/usecases/add_blocked_country.dart';
import 'package:country_blocker/features/country_blocking/domain/usecases/get_blocked_countries.dart';
import 'package:country_blocker/features/country_blocking/domain/usecases/increment_blocked_calls.dart';
import 'package:country_blocker/features/country_blocking/domain/usecases/remove_blocked_country.dart';
import 'package:country_blocker/features/country_blocking/domain/usecases/toggle_country_blocking.dart';
import 'package:country_blocker/features/country_blocking/domain/usecases/toggle_global_blocking.dart';
import 'package:country_blocker/shared/presentation/screens/home_screen.dart';
import 'package:country_blocker/shared/presentation/screens/permission_guard_screen.dart';
import 'package:country_blocker/shared/services/permissions_service.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_screen_test.mocks.dart';

import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks([
  PermissionsService,
  GetBlockedCountries,
  AddBlockedCountry,
  RemoveBlockedCountry,
  ToggleCountryBlocking,
  ToggleGlobalBlocking,
  IncrementBlockedCalls,
  SharedPreferences,
])
void main() {
  late MockPermissionsService mockPermissionsService;
  late MockGetBlockedCountries mockGetBlockedCountries;
  late MockAddBlockedCountry mockAddBlockedCountry;
  late MockRemoveBlockedCountry mockRemoveBlockedCountry;
  late MockToggleCountryBlocking mockToggleCountryBlocking;
  late MockToggleGlobalBlocking mockToggleGlobalBlocking;
  late MockIncrementBlockedCalls mockIncrementBlockedCalls;
  late MockSharedPreferences mockSharedPreferences;
  
  setUp(() {
    mockPermissionsService = MockPermissionsService();
    mockGetBlockedCountries = MockGetBlockedCountries();
    mockAddBlockedCountry = MockAddBlockedCountry();
    mockRemoveBlockedCountry = MockRemoveBlockedCountry();
    mockToggleCountryBlocking = MockToggleCountryBlocking();
    mockToggleGlobalBlocking = MockToggleGlobalBlocking();
    mockIncrementBlockedCalls = MockIncrementBlockedCalls();
    mockSharedPreferences = MockSharedPreferences();
    
    // Default stubs
    when(mockGetBlockedCountries(any))
        .thenAnswer((_) async => const Right([]));
    when(mockPermissionsService.hasPhonePermissions())
        .thenAnswer((_) async => true);
    // Mock shared preferences defaults to avoid null errors if accessed
    when(mockSharedPreferences.getStringList(any)).thenReturn(null);
    when(mockSharedPreferences.getString(any)).thenReturn(null);
    when(mockSharedPreferences.getBool(any)).thenReturn(null);
    when(mockSharedPreferences.getInt(any)).thenReturn(null);
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
        permissionsServiceProvider.overrideWithValue(mockPermissionsService),
        getBlockedCountriesProvider.overrideWithValue(mockGetBlockedCountries),
        addBlockedCountryProvider.overrideWithValue(mockAddBlockedCountry),
        removeBlockedCountryProvider.overrideWithValue(mockRemoveBlockedCountry),
        toggleCountryBlockingProvider.overrideWithValue(mockToggleCountryBlocking),
        toggleGlobalBlockingProvider.overrideWithValue(mockToggleGlobalBlocking),
        incrementBlockedCallsProvider.overrideWithValue(mockIncrementBlockedCalls),
      ],
      child: const MaterialApp(
        home: HomeScreen(),
      ),
    );
  }

  testWidgets('HomeScreen shows PermissionGuardScreen when permissions denied', (tester) async {
    // arrange
    when(mockPermissionsService.hasPhonePermissions())
        .thenAnswer((_) async => false);

    // act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // assert
    expect(find.byType(PermissionGuardScreen), findsOneWidget);
  });

  testWidgets('HomeScreen shows content when permissions granted', (tester) async {
    // arrange
    when(mockPermissionsService.hasPhonePermissions())
        .thenAnswer((_) async => true);
    
    // act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();
    
    // Allow async tasks to complete (loadBlockedCountries)
    await tester.pump(const Duration(milliseconds: 100));
    
    // If loading is still true, this will show CircularProgressIndicator
    // We expect loading to complete
    if (find.byType(CircularProgressIndicator).evaluate().isNotEmpty) {
      // Need more time or async completion?
      await tester.pump(const Duration(seconds: 1));
    }

    // assert
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(PermissionGuardScreen), findsNothing);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Country Blocker'), findsOneWidget);
  });
}
