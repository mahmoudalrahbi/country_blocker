import 'package:firebase_analytics/firebase_analytics.dart';
import 'analytics_service.dart';

class FirebaseAnalyticsService implements AnalyticsService {
  final FirebaseAnalytics _analytics;

  FirebaseAnalyticsService(this._analytics);

  @override
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) {
    return _analytics.logEvent(name: name, parameters: parameters);
  }

  @override
  Future<void> setEnabled(bool enabled) {
    return _analytics.setAnalyticsCollectionEnabled(enabled);
  }
}
