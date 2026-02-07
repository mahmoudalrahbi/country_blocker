// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'حاظر الدول';

  @override
  String get home => 'الرئيسية';

  @override
  String get blocklist => 'قائمة الحظر';

  @override
  String get logs => 'السجلات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get active => 'نشط';

  @override
  String get inactive => 'غير نشط';

  @override
  String get notActive => 'غير نشط';

  @override
  String get blockingEnabled => 'الحظر مفعل';

  @override
  String get blockingDisabled => 'الحظر معطل';

  @override
  String get enableBlocking => 'تفعيل الحظر';

  @override
  String get countriesBlocked => 'دول محظورة';

  @override
  String get recentActivity => 'النشاط الأخير';

  @override
  String get noRecentActivity => 'لا توجد مكالمات محظورة مؤخرًا';

  @override
  String get addFirstCountry => 'أضف أول دولة للحظر';

  @override
  String get addCountry => 'إضافة دولة';

  @override
  String get selectCountry => 'اختر الدولة';

  @override
  String get searchCountry => 'بحث عن دولة';

  @override
  String get cancel => 'إلغاء';

  @override
  String get add => 'إضافة';

  @override
  String get delete => 'حذف';

  @override
  String get undo => 'تراجع';

  @override
  String get itemDeleted => 'تم حذف العنصر';

  @override
  String get language => 'اللغة';

  @override
  String get theme => 'المظهر';

  @override
  String get system => 'النظام';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get about => 'حول';

  @override
  String get version => 'الإصدار';

  @override
  String get contactSupport => 'اتصل بالدعم';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get overview => 'نظرة عامة';

  @override
  String get permissionRequired => 'الأذونات مطلوبة';

  @override
  String get permissionDescription =>
      'لحمايتك من المكالمات غير المرغوب فيها، يحتاج التطبيق إلى إذن للوصول إلى حالة الهاتف وجهات الاتصال.\n\nنحن لا نقوم برفع أو مشاركة بياناتك.';

  @override
  String get grantPermissions => 'منح الأذونات';

  @override
  String get openAppSettings => 'فتح إعدادات التطبيق';

  @override
  String get pleaseEnterCountryCode => 'الرجاء إدخال رمز الدولة';

  @override
  String get unknownRegion => 'منطقة غير معروفة';

  @override
  String countryAddedToBlocklist(String country) {
    return 'تم إضافة $country إلى قائمة الحظر';
  }

  @override
  String get addBlockRule => 'إضافة قاعدة حظر';

  @override
  String get enterCustomRule => 'إدخال قاعدة مخصصة';

  @override
  String get selectCountryDescription => 'ابحث واختر دولة من القائمة لحظرها.';

  @override
  String get enterCustomRuleDescription =>
      'حظر المكالمات من بادئات دولية أو محلية محددة.';

  @override
  String get countryCode => 'رمز الدولة';

  @override
  String get tapToSelectCountry => 'اضغط لاختيار الدولة';

  @override
  String get nameOptional => 'الاسم (اختياري)';

  @override
  String get nameExample => 'مثال: جهات اتصال العمل';

  @override
  String get customCode => 'رمز مخصص';

  @override
  String get blockingDescription =>
      'سيتم حظر جميع المكالمات الواردة التي تبدأ بهذه البادئة تلقائيًا.';

  @override
  String get saveToBlockList => 'حفظ في قائمة الحظر';

  @override
  String get protectionStatus => 'حالة الحماية';

  @override
  String get blockingActive => 'الحظر مفعل';

  @override
  String get blockingActiveDescription =>
      'يتم رفض المكالمات الواردة من قائمة الدول المحظورة تلقائيًا.';

  @override
  String get blockingDisabledDescription =>
      'حظر المكالمات معطل حاليًا. قم بتمكينه لبدء حظر المكالمات غير المرغوب فيها.';

  @override
  String get disableBlocking => 'تعطيل الحظر';

  @override
  String get blockedCalls => 'المكالمات المحظورة';

  @override
  String get formattedTotalBlocked => 'إجمالي المحظور';

  @override
  String get countries => 'الدول';
}
