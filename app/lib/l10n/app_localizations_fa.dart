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

  @override
  String get retry => 'تلاش دوباره';

  @override
  String loadFailed(String error) {
    return 'بارگیری ناموفق بود: $error';
  }

  @override
  String get pagePrev => 'قبلی';

  @override
  String get pageNext => 'بعدی';

  @override
  String pageOf(int from, int to, int total) {
    return '$from–$to از $total';
  }

  @override
  String get dataSubtitle =>
      'مجموعه‌های نسخه‌بندی‌شده، کیفیت، پوشش زمانی و دریافت زنده. اصلاح منبع همیشه نسخه تازه می‌سازد.';

  @override
  String get dataLiveStream => 'جریان زنده';

  @override
  String dataLiveStreamValue(int count, String source) {
    return '$count جفت · $source';
  }

  @override
  String get dataLiveOff => 'خاموش';

  @override
  String get dataLastBarAge => 'سن آخرین کندل';

  @override
  String dataSeconds(int n) {
    return '$n ثانیه';
  }

  @override
  String get dataOutagesToday => 'قطعی‌های امروز';

  @override
  String dataOutagesValue(int count, int minutes) {
    return '$count · مجموع $minutes دقیقه';
  }

  @override
  String get dataStorage => 'فضای ذخیره';

  @override
  String get dataDatasets => 'مجموعه‌های داده';

  @override
  String get dataColVersion => 'نسخه';

  @override
  String get dataColPair => 'جفت';

  @override
  String get dataColTimeframe => 'تایم‌فریم';

  @override
  String get dataColRange => 'بازه';

  @override
  String get dataColQuality => 'کیفیت';

  @override
  String get dataColExperiments => 'آزمایش‌های وابسته';

  @override
  String get dataQualityOk => 'سالم';

  @override
  String dataQualityGaps(int n) {
    return '$n شکاف';
  }

  @override
  String dataQualityFilled(int n) {
    return '$n پرشده';
  }

  @override
  String get dataDatasetsEmpty =>
      'هنوز نسخه‌ای از داده ساخته نشده است. از فرم واردسازی، اولین بازه را وارد کنید.';

  @override
  String get dataCoverage => 'پوشش زمانی';

  @override
  String get dataCoverageLegend => 'نوار نارنجی = شکاف یا داده نامعتبر';

  @override
  String get dataCoverageEmpty => 'هنوز کندلی ذخیره نشده است.';

  @override
  String get dataIssues => 'مشکلات کیفیت';

  @override
  String get dataIssuesEmpty => 'مشکلی ثبت نشده است.';

  @override
  String get issueGap => 'شکاف';

  @override
  String get issueOutOfOrder => 'ترتیب نادرست';

  @override
  String get issueDuplicate => 'تکراری';

  @override
  String get issueBadPrice => 'قیمت نامعتبر';

  @override
  String get issueZeroVolume => 'حجم صفر';

  @override
  String get issueCorrection => 'اصلاح منبع';

  @override
  String get issueOutage => 'قطعی';

  @override
  String get dataImport => 'واردسازی تاریخچه';

  @override
  String get dataSource => 'منبع';

  @override
  String get dataSourceArchive => 'Binance public archive (klines)';

  @override
  String get dataPairs => 'جفت‌ها';

  @override
  String get dataFrom => 'از';

  @override
  String get dataTo => 'تا';

  @override
  String get dataDateHelp => 'تاریخ میلادی، UTC، به شکل 2024-01-31';

  @override
  String get dataTimeframe => 'تایم‌فریم نسخه';

  @override
  String get dataGapPolicy => 'سیاست شکاف';

  @override
  String get gapFlag => 'علامت‌گذاری، بدون پرکردن';

  @override
  String get gapStop => 'توقف آزمایش';

  @override
  String get gapFfill => 'پرکردن با آخرین قیمت معلوم (بدون داده آینده)';

  @override
  String get dataImportButton => 'واردسازی و ساخت نسخه';

  @override
  String get dataImportNote =>
      'واردسازی مجدد همان بازه رکورد تکراری نمی‌سازد. هر نسخه شناسه محتوا دارد و آزمایش‌های قبلی تغییر نمی‌کنند.';

  @override
  String get dataImportRunning => 'در حال واردسازی…';

  @override
  String dataImportProgress(String symbol, int done, int total, int inserted) {
    return '$symbol: $done از $total فایل · $inserted کندل تازه';
  }

  @override
  String get dataImportDone => 'نسخه ساخته شد';

  @override
  String get dataImportFailed => 'واردسازی ناموفق بود';

  @override
  String get errPickPair => 'دست‌کم یک جفت انتخاب کنید.';

  @override
  String get errDate => 'تاریخ را به شکل 2024-01-31 وارد کنید.';

  @override
  String get errRange => '«از» باید پیش از «تا» باشد و «تا» از امروز نگذرد.';

  @override
  String get settingsCurrency => 'ارز مبنا و تبدیل به تومان';

  @override
  String get settingsAccounting => 'ارز مبنای محاسبات';

  @override
  String get settingsAccountingNote => 'ثابت؛ همه سود و زیان، ریسک و مقایسه‌ها';

  @override
  String get settingsDisplayRate => 'نرخ نمایشی';

  @override
  String get settingsDisplayRateNote =>
      'فقط در نمایش و خروجی؛ وارد محاسبه نمی‌شود';

  @override
  String get settingsRateField => 'نرخ امروز (تومان به ازای ۱ USDT)';

  @override
  String get settingsRateHelp => 'عدد مثبت، حداکثر دو رقم اعشار';

  @override
  String get settingsDateField => 'تاریخ اعمال';

  @override
  String get settingsSourceField => 'منبع / یادداشت';

  @override
  String get settingsSourceHelp => 'اختیاری؛ خالی یعنی «دستی»';

  @override
  String get settingsSaveRate => 'ثبت نرخ';

  @override
  String get settingsRateSaved => 'نرخ ثبت شد';

  @override
  String get settingsRateNote =>
      'واحد نمایش «تومان» است (۱ تومان = ۱۰ ریال). هر گزارش نرخی را که با آن تبدیل شده نگه می‌دارد؛ ثبت نرخ تازه، گزارش‌های قبلی را تغییر نمی‌دهد.';

  @override
  String get settingsHistory => 'تاریخچه نرخ‌ها';

  @override
  String get settingsColDate => 'تاریخ';

  @override
  String get settingsColRate => 'نرخ';

  @override
  String get settingsColSource => 'منبع';

  @override
  String get settingsColEntered => 'ثبت';

  @override
  String get settingsColReports => 'گزارش‌های وابسته';

  @override
  String get settingsHistoryEmpty =>
      'هنوز نرخی ثبت نشده است. نرخ امروز را در فرم بالا وارد کنید.';

  @override
  String get settingsOther => 'منابع موتور، پیش‌فرض‌های یادگیری و نگهداری';

  @override
  String get settingsOtherNote =>
      'این بخش‌ها همراه صف اجرا (M4) و چرخه یادگیری (M5) فعال می‌شوند.';

  @override
  String get errRate => 'نرخ باید عددی مثبت با حداکثر دو رقم اعشار باشد.';

  @override
  String get errFutureDate => 'تاریخ نمی‌تواند در آینده باشد.';
}
