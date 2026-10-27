// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class L10nFa extends L10n {
  L10nFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'آزمایشگاه الگوریتم';

  @override
  String get appSubtitle => 'Trading Research Lab';

  @override
  String get navHome => 'خانه';

  @override
  String get navGroupResearch => 'پژوهش';

  @override
  String get navLibrary => 'کتابخانه الگوریتم';

  @override
  String get navBuilder => 'ساخت آزمایش';

  @override
  String get navQueue => 'صف اجرا و جست‌وجو';

  @override
  String get navReports => 'گزارش‌ها';

  @override
  String get navCompare => 'مقایسه';

  @override
  String get navPnl => 'ماشین‌حساب سود و زیان';

  @override
  String get navGroupLearning => 'یادگیری و تحلیل';

  @override
  String get navLearning => 'چرخه یادگیری';

  @override
  String get navChart => 'نمودار';

  @override
  String get navData => 'داده';

  @override
  String get navGroupLater => 'بعداً';

  @override
  String get navPaper => 'حساب مجازی و سفارش';

  @override
  String get navRisk => 'ریسک و انضباط';

  @override
  String get navJournal => 'ژورنال';

  @override
  String get navMarket => 'بازار و رویداد';

  @override
  String get navGroupSystem => 'سیستم';

  @override
  String get navSettings => 'تنظیمات';

  @override
  String get phase2 => 'فاز ۲';

  @override
  String get openMenu => 'باز کردن منو';

  @override
  String get statusMode => 'حالت اجرا';

  @override
  String get statusModeResearch => 'پژوهش · بدون سفارش واقعی';

  @override
  String get statusAccounting => 'ارز مبنا';

  @override
  String get statusLive => 'داده زنده';

  @override
  String get statusLiveOff => 'خاموش';

  @override
  String get statusLiveFresh => 'تازه';

  @override
  String get statusLiveStale => 'کهنه';

  @override
  String get statusLiveReconnecting => 'در حال اتصال دوباره';

  @override
  String get statusEngine => 'موتور Go';

  @override
  String get statusEngineRunning => 'فعال';

  @override
  String get statusEnginePaused => 'متوقف';

  @override
  String get statusEngineDown => 'قطع';

  @override
  String statusWorkers(int count) {
    return '$count کارگر';
  }

  @override
  String get statusFx => 'نرخ تبدیل نمایشی';

  @override
  String get statusFxNone => 'هنوز نرخی ثبت نشده';

  @override
  String get statusFxManual => 'دستی';

  @override
  String get engineUnreachable =>
      'موتور در دسترس نیست. آخرین وضعیت نمایش داده می‌شود؛ دوباره تلاش می‌کنیم…';

  @override
  String get screenHomeSub =>
      'وضعیت موتور، آخرین چرخه یادگیری و آزمایش‌های اخیر';

  @override
  String get screenLibrarySub => 'الگوریتم‌ها، نسخه‌ها و دستورالعمل‌ها';

  @override
  String get screenBuilderSub =>
      'فرضیه، داده، الگوریتم، هزینه‌ها و برنامه اعتبارسنجی در شش گام';

  @override
  String get screenQueueSub => 'پیشرفت اجراها، بودجه و همه تلاش‌ها';

  @override
  String get screenReportsSub => 'نتیجه هر اجرا به زبان ساده، با همه فرض‌ها';

  @override
  String get screenCompareSub => 'اول تفاوت فرض‌ها، بعد معیارها';

  @override
  String get screenPnlSub =>
      'محاسبه دوباره سود و زیان با سرمایه، اندازه و هزینه‌های دیگر';

  @override
  String get screenLearningSub => 'قهرمان، چالشگر و دروازه ارتقا';

  @override
  String get screenChartSub => 'شمع‌ها، شاخص‌های موتور و نشانگر تصمیم‌ها';

  @override
  String get screenDataSub => 'مجموعه‌داده‌ها، پوشش، مشکلات کیفیت و داده زنده';

  @override
  String get screenSettingsSub => 'نرخ تبدیل نمایشی و تنظیمات موتور';

  @override
  String comingIn(String milestone) {
    return 'این صفحه در مرحله $milestone ساخته می‌شود.';
  }

  @override
  String get comingInHint => 'تا آن زمان، ساختار و مسیر آن آماده است.';

  @override
  String get chartSpikeTitle => 'آزمون نمودار (M0)';

  @override
  String get chartSpikeHint =>
      'شمع‌های نمونه و ثابت. اشاره‌گر را روی نمودار حرکت دهید و اندازه پنجره را تغییر دهید.';

  @override
  String get chartCrosshair => 'زیر اشاره‌گر';

  @override
  String get chartCrosshairNone => 'اشاره‌گر روی نمودار نیست';
}
