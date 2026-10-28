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

  @override
  String get invalid => 'نامعتبر';

  @override
  String get unitUsdt => 'USDT';

  @override
  String durationDays(int d) {
    return '$d روز';
  }

  @override
  String durationHours(int h) {
    return '$h ساعت';
  }

  @override
  String durationMinutes(int m) {
    return '$m دقیقه';
  }

  @override
  String get reportsNew => 'اجرای تازه';

  @override
  String get reportsEmpty =>
      'هنوز گزارشی ساخته نشده است. با «اجرای تازه» اولین آزمون را بسازید.';

  @override
  String reportsCompareSelected(int n) {
    return 'مقایسه $n گزارش';
  }

  @override
  String get reportsColTitle => 'گزارش';

  @override
  String get reportsColCreated => 'ساخته‌شده';

  @override
  String get reportsColNet => 'سود خالص (OOS)';

  @override
  String get reportsColReturn => 'بازده';

  @override
  String get reportsColTrades => 'معاملات';

  @override
  String get reportsColVerdict => 'نتیجه';

  @override
  String get reportsColHoldout => 'آزمون نهایی';

  @override
  String get reportsSelect => 'انتخاب برای مقایسه';

  @override
  String get newDatasets => 'نسخه‌های داده';

  @override
  String get newDatasetsHelp => 'یک نسخه برای هر جفت؛ همه با یک تایم‌فریم';

  @override
  String get newDatasetsEmpty =>
      'نسخه‌ای نیست. ابتدا در صفحه داده یک بازه وارد کنید.';

  @override
  String get newStrategy => 'راهبرد';

  @override
  String get newParams => 'پارامترها';

  @override
  String get newCapital => 'سرمایه اولیه';

  @override
  String get newFeeBps => 'کارمزد هر سمت';

  @override
  String get newSlipBps => 'لغزش هر سمت';

  @override
  String get bps => 'bps';

  @override
  String get bpsHelp => '۱ bps = ۰٫۰۱٪؛ مثلاً ۱۰ یعنی ۰٫۱٪';

  @override
  String get newFolds => 'تعداد گام‌های آزمون';

  @override
  String get newHoldout => 'سهم آزمون نهایی';

  @override
  String get newHoldoutHelp => 'درصد پایانی داده که پنهان می‌ماند';

  @override
  String get newRolling => 'پنجره آموزش غلتان';

  @override
  String get newRun => 'اجرا و ساخت گزارش';

  @override
  String get newRunning => 'در حال ارزیابی گام‌به‌گام…';

  @override
  String get errRequired => 'این مقدار لازم است.';

  @override
  String get errPositive => 'عددی مثبت وارد کنید.';

  @override
  String get errNumber => 'عدد معتبر وارد کنید.';

  @override
  String get errBps => 'عددی بین ۰ و ۱۰۰۰ با حداکثر دو رقم اعشار.';

  @override
  String get errPickDataset => 'دست‌کم یک نسخه داده انتخاب کنید.';

  @override
  String get reportTitle => 'گزارش';

  @override
  String get reportExportCsv => 'خروجی CSV';

  @override
  String get reportExportMetrics => 'معیارها CSV';

  @override
  String get reportExportJson => 'تعریف JSON';

  @override
  String get reportReproduce => 'اجرای مجدد (بازتولید)';

  @override
  String get reportReproduceOk => 'بازتولید شد: همه اعداد دقیقاً یکسان‌اند.';

  @override
  String get reportReproduceFail => 'بازتولید متفاوت بود؛ گزارش را بررسی کنید.';

  @override
  String get reportAddCompare => 'افزودن به مقایسه';

  @override
  String get reportInCompare => 'در فهرست مقایسه';

  @override
  String get reportOpenPnl => 'آزمودن سرمایه و کارمزد دیگر در ماشین‌حساب';

  @override
  String get reportSummary => 'خلاصه به زبان ساده';

  @override
  String get reportWaterfall => 'از سود ناخالص تا سود خالص';

  @override
  String get reportFinalEquity => 'ارزش نهایی حساب';

  @override
  String get reportToman => 'معادل تومانی';

  @override
  String reportTomanRate(String id, String date) {
    return 'نرخ #$id · $date';
  }

  @override
  String get reportTomanNone => 'نرخی ثبت نشده';

  @override
  String get reportBreakEven => 'کارمزد سر‌به‌سر';

  @override
  String get reportBreakEvenNone => 'هیچ کارمزدی آن را سودده نمی‌کند';

  @override
  String get reportEquity => 'منحنی ارزش حساب';

  @override
  String get reportCandidate => 'این راهبرد';

  @override
  String get benchBuyAndHold => 'خرید و نگهداری';

  @override
  String get benchHoldCash => 'نگهداری نقد';

  @override
  String get regionInSample => 'داده آموزش';

  @override
  String get regionOos => 'خارج از نمونه';

  @override
  String get regionHoldout => 'آزمون نهایی';

  @override
  String get reportFolds => 'گام‌های ارزیابی گام‌به‌گام';

  @override
  String get foldStep => 'گام';

  @override
  String get foldTrainUntil => 'آموزش تا';

  @override
  String get foldTest => 'آزمون';

  @override
  String get foldReturn => 'بازده خالص';

  @override
  String get foldDrawdown => 'افت';

  @override
  String get foldTrades => 'معاملات';

  @override
  String get reportStress => 'سناریوهای تنش';

  @override
  String get stress_fee_x2 => 'کارمزد × ۲';

  @override
  String get stress_slippage_x3 => 'لغزش × ۳';

  @override
  String get stress_latency_plus_1 => 'تأخیر +۱ کندل';

  @override
  String get reportSensitivity => 'حساسیت پارامتر';

  @override
  String reportSensitivityHelp(String x, String y) {
    return 'بازده خالص خارج از نمونه · افقی $x$y';
  }

  @override
  String reportSensitivityY(String y) {
    return '، عمودی $y';
  }

  @override
  String get reportSensitivityNone =>
      'این راهبرد پارامتر سیگنالی برای آزمون همسایگی ندارد.';

  @override
  String get reportHoldout => 'آزمون نهایی (holdout)';

  @override
  String get reportHoldoutHidden =>
      'نتیجه آزمون نهایی پنهان است تا تصمیم‌ها روی آن تنظیم نشوند. هر بار دیدن ثبت می‌شود.';

  @override
  String get reportHoldoutShow => 'نمایش آزمون نهایی';

  @override
  String get reportHoldoutConfirm =>
      'نمایش آزمون نهایی ثبت می‌شود و در گزارش به‌عنوان «دیده‌شده» نشان داده خواهد شد. پس از دیدن، تنظیم دوباره پارامترها روی این داده نتیجه را بی‌اعتبار می‌کند. ادامه می‌دهید؟';

  @override
  String reportHoldoutViews(int n) {
    return 'آزمون نهایی: $n بار مشاهده';
  }

  @override
  String get reportTrades => 'معاملات خارج از نمونه';

  @override
  String get tradeEntryExit => 'ورود → خروج';

  @override
  String get tradeGross => 'ناخالص';

  @override
  String get tradeCost => 'هزینه';

  @override
  String get tradeNet => 'خالص';

  @override
  String get tradeOpen => 'باز';

  @override
  String get cancel => 'انصراف';

  @override
  String get confirm => 'تأیید';

  @override
  String badgeEngine(String v) {
    return 'کد $v';
  }

  @override
  String badgeDatasets(String ids) {
    return 'داده $ids';
  }

  @override
  String get compareSubtitle =>
      'نتایج فقط وقتی کنار هم معنا دارند که فرض‌ها یکسان باشند؛ تفاوت‌ها پیش از معیارها نمایش داده می‌شوند.';

  @override
  String get compareAssumptions => 'هم‌ارزی فرض‌ها';

  @override
  String get compareAssumption => 'فرض';

  @override
  String get compareSame => 'یکسان';

  @override
  String get compareDiffers => 'متفاوت';

  @override
  String get compareNote => 'در تفسیر لحاظ شود';

  @override
  String compareMismatch(int n, String what) {
    return '$n تفاوت در فرض‌ها: $what';
  }

  @override
  String get compareEquity => 'منحنی ارزش خارج از نمونه (USDT)';

  @override
  String get compareEquityHelp => 'هر اجرا رنگ و سبک خط جداگانه دارد.';

  @override
  String get compareMetrics => 'معیارها';

  @override
  String get compareMetric => 'معیار';

  @override
  String get compareTotalCost => 'هزینه کل';

  @override
  String get compareEligible => 'واجد شرایط';

  @override
  String get compareYes => 'بله';

  @override
  String get compareNo => 'خیر';

  @override
  String get compareConclusion => 'جمع‌بندی';

  @override
  String get compareEmpty =>
      'دست‌کم دو گزارش را از فهرست گزارش‌ها برای مقایسه انتخاب کنید.';

  @override
  String get compareClear => 'پاک کردن فهرست';

  @override
  String get pnlSubtitle =>
      'ببینید یک الگوریتم یا یک معامله، پس از کارمزد و لغزش، دقیقاً چقدر سود یا زیان می‌سازد — و اگر شرایط عوض شود چه می‌شود.';

  @override
  String get pnlTabRun => 'نتیجه یک الگوریتم (از اجرای ثبت‌شده)';

  @override
  String get pnlTabTrade => 'یک معامله';

  @override
  String get pnlInputs => 'ورودی‌ها';

  @override
  String get pnlReport => 'اجرای ثبت‌شده';

  @override
  String get pnlNoReports => 'هنوز گزارشی نیست؛ ابتدا یک اجرای تازه بسازید.';

  @override
  String get pnlSize => 'اندازه موقعیت نسبت به اجرای اصلی';

  @override
  String get pnlSizeHelp => '۱۰۰٪ یعنی همان اندازه ثبت‌شده';

  @override
  String get pnlRate => 'نرخ تبدیل نمایشی';

  @override
  String get pnlRateNone => 'بدون تومان';

  @override
  String get pnlReset => 'بازگشت به تنظیمات اجرای اصلی';

  @override
  String get pnlOriginalNet => 'سود خالص اجرای اصلی';

  @override
  String get pnlNet => 'سود خالص';

  @override
  String get pnlFinal => 'ارزش نهایی';

  @override
  String get pnlBreakEvenFee => 'کارمزد سر‌به‌سر';

  @override
  String get pnlEquity => 'ارزش حساب';

  @override
  String get pnlTradeInputs => 'ورودی‌های معامله';

  @override
  String get pnlSpotNote =>
      'بازار اسپات: خرید و سپس فروش. فروش استقراضی ممکن نیست.';

  @override
  String get pnlEntry => 'قیمت ورود';

  @override
  String get pnlExit => 'قیمت خروج';

  @override
  String get pnlAmount => 'مبلغ خرید';

  @override
  String get pnlQty => 'مقدار';

  @override
  String get pnlCost => 'هزینه کل خرید';

  @override
  String get pnlReturn => 'بازده روی هزینه';

  @override
  String get pnlBreakEvenExit => 'قیمت فروش سر‌به‌سر';

  @override
  String get pnlTomanNet => 'سود خالص به تومان';

  @override
  String get st_running => 'در حال اجرا';

  @override
  String get st_paused => 'متوقف موقت';

  @override
  String get st_finalizing => 'در حال جمع‌بندی';

  @override
  String get st_done => 'کامل';

  @override
  String get st_cancelled => 'لغو شد';

  @override
  String get st_failed => 'شکست';

  @override
  String get st_queued => 'در صف';

  @override
  String get lc_research => 'پژوهش';

  @override
  String get lc_validation => 'اعتبارسنجی';

  @override
  String get lc_forward_test => 'آزمون پیشرو';

  @override
  String get lc_active => 'فعال';

  @override
  String get lc_stopped => 'متوقف';

  @override
  String get lc_retired => 'بازنشسته';

  @override
  String get fam_all => 'همه';

  @override
  String get fam_trend => 'روند';

  @override
  String get fam_mean_reversion => 'بازگشت به میانگین';

  @override
  String get fam_learning => 'یادگیرنده';

  @override
  String get fam_hybrid => 'ترکیبی';

  @override
  String get fam_benchmark => 'معیار مقایسه';

  @override
  String get bSubtitle =>
      'در چند قدم ساده. مقدارهای پیش‌فرض امن‌اند؛ فقط آنچه برایتان مهم است را تغییر دهید.';

  @override
  String get bStep0 => 'شروع';

  @override
  String get bStep1 => 'ایده';

  @override
  String get bStep2 => 'داده';

  @override
  String get bStep3 => 'الگوریتم';

  @override
  String get bStep4 => 'پول و هزینه';

  @override
  String get bStep5 => 'بررسی و اجرا';

  @override
  String get bWhat => 'چه کاری می‌خواهید انجام دهید؟';

  @override
  String get tplQuick => 'آزمون سریع یک الگوریتم';

  @override
  String get tplQuickDesc =>
      'یک الگوریتم را با تنظیمات فعلی‌اش روی داده تازه امتحان کنید.';

  @override
  String get tplQuickMeta => '۱ نامزد';

  @override
  String get tplSearch => 'یافتن بهترین تنظیمات';

  @override
  String get tplSearchDesc =>
      'چند ترکیب از تنظیمات را امتحان کنید و ببینید کدام پایدارتر است.';

  @override
  String get tplSearchMeta => 'ده‌ها اجرا · همه ثبت می‌شوند';

  @override
  String get tplIdea => 'سنجش یک ایده تازه';

  @override
  String get tplIdeaDesc => 'یک تنظیم را عوض کنید و دو نسخه را کنار هم بسنجید.';

  @override
  String get tplIdeaMeta => '۲ نامزد · مقایسه کنار هم';

  @override
  String get bIdeaTitle => 'چه چیزی را می‌خواهید بسنجید؟';

  @override
  String get bName => 'نام آزمایش';

  @override
  String get bHypothesis => 'ایده شما در یک جمله';

  @override
  String get bHypothesisHelp =>
      'مثال: «اگر فقط در بازار کم‌نوسان معامله کنیم، زیان‌های بزرگ کمتر می‌شود.»';

  @override
  String get bFalsifier => 'چه نتیجه‌ای یعنی ایده درست نبود؟';

  @override
  String get bFalsifierHelp =>
      'این را قبل از دیدن نتیجه بنویسید تا بعداً خودتان را قانع نکنید.';

  @override
  String get bGoal => 'مهم‌ترین هدف';

  @override
  String get goalNet => 'بیشترین بازده با سقف افت سرمایه';

  @override
  String get goalDd => 'کمترین افت با حداقل سود';

  @override
  String get goalStable => 'بهترین نسبت شارپ';

  @override
  String get bDataTitle => 'روی چه بازار و دوره‌ای؟';

  @override
  String get bTimeframe => 'بازه زمانی هر کندل';

  @override
  String get bDatasets => 'نسخه‌های داده (یکی برای هر جفت)';

  @override
  String get bDatasetsEmpty =>
      'برای این تایم‌فریم نسخه‌ای نیست؛ از صفحه داده وارد کنید.';

  @override
  String get bAlgoTitle => 'کدام الگوریتم؟';

  @override
  String get bParamsTitle => 'کدام تنظیمات امتحان شوند؟';

  @override
  String get bParam => 'تنظیم';

  @override
  String get bParamDefault => 'پیش‌فرض';

  @override
  String get bParamValues => 'مقدارها (با ویرگول)';

  @override
  String get bParamValuesHelp => 'خالی یعنی همان پیش‌فرض';

  @override
  String get bNoParams => 'این الگوریتم تنظیمی برای جست‌وجو ندارد.';

  @override
  String get bMoneyTitle => 'پول و هزینه‌ها';

  @override
  String bRoundTrip(String pct) {
    return 'هر معامله کامل (خرید و فروش) با این تنظیمات حدود $pct هزینه دارد؛ الگوریتم باید در هر معامله بیش از این سود ناخالص بسازد.';
  }

  @override
  String get bReviewTitle => 'بررسی نهایی';

  @override
  String get bAdvanced => 'تنظیمات پیشرفته';

  @override
  String get bAdvancedHelp =>
      'این‌ها پیش‌فرض‌های امن هستند و معمولاً نیازی به تغییر ندارند.';

  @override
  String get bMaxDd => 'سقف افت سرمایه';

  @override
  String get bMinTrades => 'حداقل معامله بسته';

  @override
  String get bMinReturn => 'حداقل بازده';

  @override
  String get bSearchMode => 'روش جست‌وجو';

  @override
  String get modeGrid => 'شبکه‌ای (همه ترکیب‌ها)';

  @override
  String get modeRandom => 'تصادفی با بذر';

  @override
  String get bSeed => 'بذر';

  @override
  String get bMaxAttempts => 'سقف تلاش‌ها';

  @override
  String get bMaxMinutes => 'سقف زمان';

  @override
  String get minutes => 'دقیقه';

  @override
  String get bBack => 'قبلی';

  @override
  String get bNext => 'بعدی';

  @override
  String get bRun => 'ثبت و اجرا';

  @override
  String get bSummary => 'آنچه تا الان انتخاب کرده‌اید';

  @override
  String bRuns(int n, int c) {
    return '$n اجرا · $c نامزد';
  }

  @override
  String bEta(String t) {
    return 'حدود $t';
  }

  @override
  String get bLockNote =>
      'پس از شروع، این تعریف قفل می‌شود. اگر بعداً چیزی را عوض کنید، آزمایش تازه‌ای با ارجاع به همین ساخته می‌شود.';

  @override
  String get bExisted =>
      'این آزمایش با همین تعریف قبلاً اجرا شده بود؛ همان را باز کردیم.';

  @override
  String get bDraftRestored => 'پیش‌نویس قبلی بازیابی شد.';

  @override
  String get bDraftClear => 'شروع از نو';

  @override
  String get errHypothesis => 'ایده و نتیجه ردکننده را بنویسید.';

  @override
  String get errDatasetsPerPair => 'برای هر جفت فقط یک نسخه داده انتخاب کنید.';

  @override
  String get errValues =>
      'عددهای مثبت با ویرگول؛ برای تنظیم‌های عدد صحیح فقط عدد صحیح.';

  @override
  String get qListEmpty => 'هنوز آزمایشی نیست. با «ساخت آزمایش» شروع کنید.';

  @override
  String get qNew => 'ساخت آزمایش';

  @override
  String get qColName => 'آزمایش';

  @override
  String get qColStatus => 'وضعیت';

  @override
  String get qColProgress => 'پیشرفت';

  @override
  String get qColCreated => 'شروع';

  @override
  String get qPause => 'توقف موقت';

  @override
  String get qResume => 'ادامه';

  @override
  String get qCancel => 'لغو آزمایش';

  @override
  String get qCancelConfirm =>
      'تلاش‌های در صف لغو می‌شوند و آزمایش پایان می‌یابد. همه تلاش‌های انجام‌شده ثبت می‌مانند. ادامه می‌دهید؟';

  @override
  String get qPauseConfirm =>
      'تلاش‌های در حال اجرا تمام می‌شوند ولی تلاش تازه‌ای شروع نمی‌شود تا ادامه دهید. ادامه می‌دهید؟';

  @override
  String get qProgress => 'پیشرفت';

  @override
  String get qAttempts => 'تلاش';

  @override
  String get qRemaining => 'زمان باقی‌مانده تخمینی';

  @override
  String get qAllRecorded =>
      'همه تلاش‌ها، حتی شکست‌خورده و لغوشده، ثبت و شمرده می‌شوند.';

  @override
  String get qBudgetAttempts => 'تلاش‌ها از بودجه';

  @override
  String get qBudgetTime => 'زمان مصرف‌شده';

  @override
  String get qBudgetCpu => 'سهم CPU پژوهش';

  @override
  String get qCacheRate => 'نرخ استفاده از کش';

  @override
  String get qBest => 'بهترین نتیجه واجد شرایط تا اینجا';

  @override
  String get qTabAll => 'همه';

  @override
  String get qColParams => 'پارامترها';

  @override
  String get qColPair => 'جفت';

  @override
  String get qColReturn => 'بازده خالص';

  @override
  String get qColDd => 'بیشینه افت';

  @override
  String get qColTrades => 'معاملات';

  @override
  String get qColConstraints => 'محدودیت‌ها';

  @override
  String get qColCache => 'کش';

  @override
  String get qEligible => 'واجد شرایط';

  @override
  String qRejected(String why) {
    return 'رد: $why';
  }

  @override
  String qRuns(int n) {
    return '$n بار اجرا';
  }

  @override
  String get qResult => 'نتیجه';

  @override
  String qChosen(int n) {
    return 'نامزد برگزیده #$n';
  }

  @override
  String qChosenNote(int eligible, int cands, int attempts) {
    return 'از $eligible نامزد واجد شرایط در میان $cands نامزد و $attempts تلاش انتخاب شد؛ بخشی از برتری آن ممکن است شانسی باشد.';
  }

  @override
  String get qOpenReport => 'گزارش کامل نامزد برگزیده';

  @override
  String get qNone => 'نامزد واجد شرایطی نبود';

  @override
  String get qEmpty => 'تلاشی در این دسته نیست.';

  @override
  String get qNotFound => 'این آزمایش پیدا نشد.';

  @override
  String get libExperiment => 'آزمایش با نسخه انتخابی';

  @override
  String get libLatest => 'آخرین ارزیابی';

  @override
  String get libNone => '—';

  @override
  String get libSelected => 'الگوریتم انتخاب‌شده';

  @override
  String get libRecipe => 'دستور ساخت (نسخه جاری)';

  @override
  String get libVersions => 'تاریخچه نسخه‌ها';

  @override
  String get libLockNote =>
      'قواعد و پارامترهای نسخه فعال قفل‌اند. هر تغییر در قواعد یا پارامترها نسخه تازه می‌سازد.';

  @override
  String libMoveTo(String state) {
    return 'انتقال به «$state»';
  }

  @override
  String libConfirm(String version, String from, String to) {
    return 'وضعیت $version از «$from» به «$to» تغییر می‌کند و این تصمیم ثبت می‌شود.';
  }

  @override
  String get libConfirmActive =>
      ' اگر نسخه فعال دیگری از همین الگوریتم باشد، متوقف می‌شود.';

  @override
  String get libNote => 'یادداشت (چرا؟)';

  @override
  String get libHistory => 'رویدادها';

  @override
  String get actorUser => 'کاربر';

  @override
  String get actorSystem => 'سیستم';

  @override
  String lSubtitle(String hour, int bars) {
    return 'بازآموزی روزانه $hour UTC · حداقل داده تازه $bars کندل · ارتقا فقط با تأیید شما';
  }

  @override
  String get lSubtitleOff =>
      'بازآموزی خودکار خاموش است؛ چرخه را دستی اجرا کنید · ارتقا فقط با تأیید شما';

  @override
  String get lConfig => 'تنظیم زمان‌بندی و بودجه';

  @override
  String get lRunNow => 'اجرای چرخه اکنون';

  @override
  String lStarted(int id) {
    return 'چرخه #$id شروع شد.';
  }

  @override
  String get lCurrent => 'چرخه جاری';

  @override
  String lStage(String stage) {
    return 'مرحله: $stage';
  }

  @override
  String lForwardDay(int d, int n) {
    return 'روز $d از $n';
  }

  @override
  String get ls_collect => 'گردآوری داده';

  @override
  String get ls_labels => 'برچسب‌های آماده';

  @override
  String get ls_generate => 'ساخت نامزد';

  @override
  String get ls_train => 'آموزش';

  @override
  String get ls_walk_forward => 'ارزیابی گام‌به‌گام';

  @override
  String get ls_forward_test => 'آزمون پیشرو';

  @override
  String get ls_decision => 'تصمیم ارتقا';

  @override
  String get lst_done => 'انجام شد';

  @override
  String get lst_running => 'در جریان';

  @override
  String get lst_waiting => 'در جریان';

  @override
  String get lst_waiting_you => 'منتظر شما';

  @override
  String get lst_pending => 'منتظر';

  @override
  String get lst_skipped => 'انجام نشد';

  @override
  String get lo_skipped => 'پرش';

  @override
  String get lo_failed => 'شکست';

  @override
  String get lo_not_better => 'نامزد بهتر نیست';

  @override
  String get lo_gate_failed => 'رد در دروازه';

  @override
  String get lo_recommended => 'پیشنهاد ارتقا · منتظر تأیید شما';

  @override
  String get lo_approved => 'ارتقا با تأیید شما';

  @override
  String get lo_rejected => 'رد با تصمیم شما';

  @override
  String get lo_running => 'در جریان';

  @override
  String get lChampion => 'قهرمان (نسخه فعال)';

  @override
  String get lChampionBaseline => 'قهرمان (نسخه پایه، بی‌مدل فعال)';

  @override
  String get lChallenger => 'رقیب';

  @override
  String lModelSince(String id, String date) {
    return 'مدل $id · آموزش تا $date';
  }

  @override
  String get lBaselineDesc =>
      'هنوز مدل فعالی نیست؛ دستور همین نسخه در لحظه انجماد آموزش دید.';

  @override
  String lChange(String change, int seq) {
    return 'تغییر: $change · نامزد #$seq';
  }

  @override
  String get lFwdReturn => 'بازده خالص پیشرو';

  @override
  String get lWalkReturn => 'بازده گام‌به‌گام';

  @override
  String get lMaxDd => 'بیشینه افت';

  @override
  String get lTrades => 'معاملات';

  @override
  String get lFees => 'هزینه';

  @override
  String get lNoChallenger => 'هنوز رقیبی انتخاب نشده.';

  @override
  String get lGate => 'دروازه ارتقا (ازپیش‌ثبت‌شده)';

  @override
  String get gPass => 'قبول';

  @override
  String get gFail => 'رد';

  @override
  String get gPending => 'در انتظار';

  @override
  String get lGateEmpty => 'دروازه پس از ارزیابی گام‌به‌گام سنجیده می‌شود.';

  @override
  String get lApprove => 'تأیید ارتقا (پس از دروازه)';

  @override
  String get lReject => 'رد نامزد';

  @override
  String lApproveConfirm(String from, String change, String model) {
    return 'نسخه فعال «$from» کنار می‌رود و دستور رقیب (تغییر «$change») با مدل $model نسخه فعال می‌شود. جفت فعلی برای بازگشت نگه داشته می‌شود.';
  }

  @override
  String get lRejectConfirm =>
      'رقیب کنار گذاشته می‌شود و نسخه و مدل فعال هیچ تغییری نمی‌کنند.';

  @override
  String get lNone => 'هیچ';

  @override
  String get lHistory => 'تاریخچه چرخه‌ها';

  @override
  String get hCycle => 'چرخه';

  @override
  String get hTrigger => 'محرک';

  @override
  String get hCands => 'نامزدها';

  @override
  String get hBest => 'بهترین رقیب (پیشرو)';

  @override
  String get hDecision => 'تصمیم';

  @override
  String get trig_schedule => 'زمان‌بندی';

  @override
  String get trig_manual => 'دستی';

  @override
  String get lHistoryNote =>
      'پایان چرخه با «نامزد بهتر نیست» خروجی عادی است. داده پیشرویی که در تصمیم استفاده شده، در چرخه بعد فقط داده آموزش است.';

  @override
  String get lHistoryEmpty =>
      'هنوز چرخه‌ای اجرا نشده. «اجرای چرخه اکنون» را بزنید.';

  @override
  String get lModels => 'ثبت مدل‌ها';

  @override
  String get ms_active => 'فعال';

  @override
  String get ms_challenger => 'رقیب';

  @override
  String get ms_baseline => 'پایه';

  @override
  String get ms_archived => 'بایگانی';

  @override
  String get lModelsEmpty => 'هنوز مدلی ذخیره نشده.';

  @override
  String get lRollback => 'بازگشت به مدل پیشین';

  @override
  String get lRollbackConfirm =>
      'نسخه و مدل فعال به جفت پیش از آخرین ارتقا برمی‌گردند. این تصمیم ثبت می‌شود.';

  @override
  String get lBudget => 'بودجه چرخه';

  @override
  String get bCpu => 'CPU';

  @override
  String get bBars => 'کندل‌ها (حافظه)';

  @override
  String get bCands => 'نامزدها';

  @override
  String lCandidates(int n) {
    return 'همه نامزدهای این چرخه ($n)';
  }

  @override
  String get cChange => 'تغییر';

  @override
  String get cWins => 'برد در گام‌ها';

  @override
  String get lcAlgorithm => 'الگوریتم';

  @override
  String get lcEnabled => 'اجرای خودکار روزانه';

  @override
  String get lcHour => 'ساعت شروع (UTC)';

  @override
  String get lcLookback => 'بازه داده (روز)';

  @override
  String get lcFresh => 'حداقل کندل تازه';

  @override
  String get lcFolds => 'گام‌های ارزیابی';

  @override
  String get lcCands => 'سقف نامزدها';

  @override
  String get lcCpu => 'بودجه CPU (دقیقه)';

  @override
  String get lcBars => 'سقف کندل‌ها';

  @override
  String get lcGate => 'دروازه — پیش از هر چرخه ثبت و قفل می‌شود';

  @override
  String get lcMaxDd => 'سقف افت سرمایه';

  @override
  String get lcTrades => 'حداقل معامله پیشرو';

  @override
  String get lcFwdDays => 'طول آزمون پیشرو (روز)';

  @override
  String get lcImprove => 'حداقل بهبود بازده';

  @override
  String get lcDdDeg => 'حداکثر بدتر شدن افت';

  @override
  String get lcWins => 'حداقل برد در گام‌ها';

  @override
  String get lcPoints => 'واحد درصد';

  @override
  String get lcSaved => 'تنظیمات ذخیره شد؛ از چرخه بعد اعمال می‌شود.';

  @override
  String get save => 'ذخیره';

  @override
  String get libLearningNote =>
      'الگوریتم یادگیرنده: در چرخه یادگیری آموزش و آزموده می‌شود، نه در آزمایش.';

  @override
  String get libActiveModel => 'مدل فعال';

  @override
  String chartSub(String title, String pair) {
    return 'اجرای «$title» روی $pair · اندیکاتورها از موتور Go';
  }

  @override
  String chartSubLive(String pair) {
    return '$pair · داده خام · اندیکاتورها از موتور Go';
  }

  @override
  String get chartSource => 'لایه اجرا';

  @override
  String get chartNoSource => 'بدون لایه (داده خام)';

  @override
  String get chartPair => 'جفت';

  @override
  String get chartTimeframe => 'بازه';

  @override
  String get chartIndicators => 'اندیکاتورها';

  @override
  String get chartStrategyLines => 'خطوط خود راهبرد';

  @override
  String chartBarsCut(int n, int total) {
    return '$n کندل آخر از $total';
  }

  @override
  String get chartEmpty =>
      'برای این جفت و بازه کندلی نیست؛ از صفحه داده وارد کنید.';

  @override
  String get chartDecision => 'تصمیم انتخاب‌شده';

  @override
  String get chartPick =>
      'روی یک نشانگر در نمودار بزنید یا با دکمه‌ها بین تصمیم‌ها جابه‌جا شوید.';

  @override
  String get chartNoMarks => 'این لایه روی این جفت تصمیمی ندارد.';

  @override
  String get chartPrev => 'تصمیم قبلی';

  @override
  String get chartNext => 'تصمیم بعدی';

  @override
  String chartMarkOf(int i, int n) {
    return '$i از $n';
  }

  @override
  String get chartReplay => 'بازپخش کندل‌به‌کندل (فاز بعد)';

  @override
  String get chartBack => 'بازگشت به گزارش';

  @override
  String get mk_entry => 'ورود خرید';

  @override
  String get mk_exit => 'خروج';

  @override
  String get mk_rejected => 'سیگنال ردشده';

  @override
  String get dTime => 'زمان تصمیم';

  @override
  String get dRef => 'قیمت مرجع';

  @override
  String get dOutcome => 'نتیجه';

  @override
  String get dTarget => 'هدف موقعیت';

  @override
  String get dModel => 'مدل';

  @override
  String get dRecipe => 'نسخه دستور';

  @override
  String get dDetail => 'جزئیات';

  @override
  String get oc_filled => 'اجرا شد';

  @override
  String get oc_rejected => 'رد شد';

  @override
  String get oc_expired => 'منقضی شد';

  @override
  String get reportOnChart => 'نمایش روی نمودار';
}
