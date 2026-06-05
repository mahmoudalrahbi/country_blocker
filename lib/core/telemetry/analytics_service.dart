abstract class AnalyticsService {
  Future<void> logEvent(String name, {Map<String, Object>? parameters});
  Future<void> setEnabled(bool enabled);
}

class NoOpAnalyticsService implements AnalyticsService {
  @override
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {}

  @override
  Future<void> setEnabled(bool enabled) async {}
}

/// Wraps a delegate [AnalyticsService] with consent gating.
/// When disabled, [logEvent] is a no-op and [setEnabled(false)] propagates to
/// the delegate so the underlying SDK also stops collecting.
class ConsentGatedAnalyticsService implements AnalyticsService {
  final AnalyticsService _delegate;
  bool _enabled;

  ConsentGatedAnalyticsService(this._delegate, {required bool enabled})
      : _enabled = enabled;

  @override
  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    if (!_enabled) return;
    return _delegate.logEvent(name, parameters: parameters);
  }

  @override
  Future<void> setEnabled(bool enabled) async {
    _enabled = enabled;
    return _delegate.setEnabled(enabled);
  }
}
