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
}
