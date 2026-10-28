import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
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
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n)!;
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

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
  static const List<Locale> supportedLocales = <Locale>[Locale('fa')];

  /// No description provided for @appTitle.
  ///
  /// In fa, this message translates to:
  /// **'آزمایشگاه الگوریتم'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'Trading Research Lab'**
  String get appSubtitle;

  /// No description provided for @navHome.
  ///
  /// In fa, this message translates to:
  /// **'خانه'**
  String get navHome;

  /// No description provided for @navGroupResearch.
  ///
  /// In fa, this message translates to:
  /// **'پژوهش'**
  String get navGroupResearch;

  /// No description provided for @navLibrary.
  ///
  /// In fa, this message translates to:
  /// **'کتابخانه الگوریتم'**
  String get navLibrary;

  /// No description provided for @navBuilder.
  ///
  /// In fa, this message translates to:
  /// **'ساخت آزمایش'**
  String get navBuilder;

  /// No description provided for @navQueue.
  ///
  /// In fa, this message translates to:
  /// **'صف اجرا و جست‌وجو'**
  String get navQueue;

  /// No description provided for @navReports.
  ///
  /// In fa, this message translates to:
  /// **'گزارش‌ها'**
  String get navReports;

  /// No description provided for @navCompare.
  ///
  /// In fa, this message translates to:
  /// **'مقایسه'**
  String get navCompare;

  /// No description provided for @navPnl.
  ///
  /// In fa, this message translates to:
  /// **'ماشین‌حساب سود و زیان'**
  String get navPnl;

  /// No description provided for @navGroupLearning.
  ///
  /// In fa, this message translates to:
  /// **'یادگیری و تحلیل'**
  String get navGroupLearning;

  /// No description provided for @navLearning.
  ///
  /// In fa, this message translates to:
  /// **'چرخه یادگیری'**
  String get navLearning;

  /// No description provided for @navChart.
  ///
  /// In fa, this message translates to:
  /// **'نمودار'**
  String get navChart;

  /// No description provided for @navData.
  ///
  /// In fa, this message translates to:
  /// **'داده'**
  String get navData;

  /// No description provided for @navGroupLater.
  ///
  /// In fa, this message translates to:
  /// **'بعداً'**
  String get navGroupLater;

  /// No description provided for @navPaper.
  ///
  /// In fa, this message translates to:
  /// **'حساب مجازی و سفارش'**
  String get navPaper;

  /// No description provided for @navRisk.
  ///
  /// In fa, this message translates to:
  /// **'ریسک و انضباط'**
  String get navRisk;

  /// No description provided for @navJournal.
  ///
  /// In fa, this message translates to:
  /// **'ژورنال'**
  String get navJournal;

  /// No description provided for @navMarket.
  ///
  /// In fa, this message translates to:
  /// **'بازار و رویداد'**
  String get navMarket;

  /// No description provided for @navGroupSystem.
  ///
  /// In fa, this message translates to:
  /// **'سیستم'**
  String get navGroupSystem;

  /// No description provided for @navSettings.
  ///
  /// In fa, this message translates to:
  /// **'تنظیمات'**
  String get navSettings;

  /// No description provided for @phase2.
  ///
  /// In fa, this message translates to:
  /// **'فاز ۲'**
  String get phase2;

  /// No description provided for @openMenu.
  ///
  /// In fa, this message translates to:
  /// **'باز کردن منو'**
  String get openMenu;

  /// No description provided for @statusMode.
  ///
  /// In fa, this message translates to:
  /// **'حالت اجرا'**
  String get statusMode;

  /// No description provided for @statusModeResearch.
  ///
  /// In fa, this message translates to:
  /// **'پژوهش · بدون سفارش واقعی'**
  String get statusModeResearch;

  /// No description provided for @statusAccounting.
  ///
  /// In fa, this message translates to:
  /// **'ارز مبنا'**
  String get statusAccounting;

  /// No description provided for @statusLive.
  ///
  /// In fa, this message translates to:
  /// **'داده زنده'**
  String get statusLive;

  /// No description provided for @statusLiveOff.
  ///
  /// In fa, this message translates to:
  /// **'خاموش'**
  String get statusLiveOff;

  /// No description provided for @statusLiveFresh.
  ///
  /// In fa, this message translates to:
  /// **'تازه'**
  String get statusLiveFresh;

  /// No description provided for @statusLiveStale.
  ///
  /// In fa, this message translates to:
  /// **'کهنه'**
  String get statusLiveStale;

  /// No description provided for @statusLiveReconnecting.
  ///
  /// In fa, this message translates to:
  /// **'در حال اتصال دوباره'**
  String get statusLiveReconnecting;

  /// No description provided for @statusEngine.
  ///
  /// In fa, this message translates to:
  /// **'موتور Go'**
  String get statusEngine;

  /// No description provided for @statusEngineRunning.
  ///
  /// In fa, this message translates to:
  /// **'فعال'**
  String get statusEngineRunning;

  /// No description provided for @statusEnginePaused.
  ///
  /// In fa, this message translates to:
  /// **'متوقف'**
  String get statusEnginePaused;

  /// No description provided for @statusEngineDown.
  ///
  /// In fa, this message translates to:
  /// **'قطع'**
  String get statusEngineDown;

  /// No description provided for @statusWorkers.
  ///
  /// In fa, this message translates to:
  /// **'{count} کارگر'**
  String statusWorkers(int count);

  /// No description provided for @statusFx.
  ///
  /// In fa, this message translates to:
  /// **'نرخ تبدیل نمایشی'**
  String get statusFx;

  /// No description provided for @statusFxNone.
  ///
  /// In fa, this message translates to:
  /// **'هنوز نرخی ثبت نشده'**
  String get statusFxNone;

  /// No description provided for @statusFxManual.
  ///
  /// In fa, this message translates to:
  /// **'دستی'**
  String get statusFxManual;

  /// No description provided for @engineUnreachable.
  ///
  /// In fa, this message translates to:
  /// **'موتور در دسترس نیست. آخرین وضعیت نمایش داده می‌شود؛ دوباره تلاش می‌کنیم…'**
  String get engineUnreachable;

  /// No description provided for @screenHomeSub.
  ///
  /// In fa, this message translates to:
  /// **'وضعیت موتور، آخرین چرخه یادگیری و آزمایش‌های اخیر'**
  String get screenHomeSub;

  /// No description provided for @screenLibrarySub.
  ///
  /// In fa, this message translates to:
  /// **'الگوریتم‌ها، نسخه‌ها و دستورالعمل‌ها'**
  String get screenLibrarySub;

  /// No description provided for @screenBuilderSub.
  ///
  /// In fa, this message translates to:
  /// **'فرضیه، داده، الگوریتم، هزینه‌ها و برنامه اعتبارسنجی در شش گام'**
  String get screenBuilderSub;

  /// No description provided for @screenQueueSub.
  ///
  /// In fa, this message translates to:
  /// **'پیشرفت اجراها، بودجه و همه تلاش‌ها'**
  String get screenQueueSub;

  /// No description provided for @screenReportsSub.
  ///
  /// In fa, this message translates to:
  /// **'نتیجه هر اجرا به زبان ساده، با همه فرض‌ها'**
  String get screenReportsSub;

  /// No description provided for @screenCompareSub.
  ///
  /// In fa, this message translates to:
  /// **'اول تفاوت فرض‌ها، بعد معیارها'**
  String get screenCompareSub;

  /// No description provided for @screenPnlSub.
  ///
  /// In fa, this message translates to:
  /// **'محاسبه دوباره سود و زیان با سرمایه، اندازه و هزینه‌های دیگر'**
  String get screenPnlSub;

  /// No description provided for @screenLearningSub.
  ///
  /// In fa, this message translates to:
  /// **'قهرمان، چالشگر و دروازه ارتقا'**
  String get screenLearningSub;

  /// No description provided for @screenChartSub.
  ///
  /// In fa, this message translates to:
  /// **'شمع‌ها، شاخص‌های موتور و نشانگر تصمیم‌ها'**
  String get screenChartSub;

  /// No description provided for @screenDataSub.
  ///
  /// In fa, this message translates to:
  /// **'مجموعه‌داده‌ها، پوشش، مشکلات کیفیت و داده زنده'**
  String get screenDataSub;

  /// No description provided for @screenSettingsSub.
  ///
  /// In fa, this message translates to:
  /// **'نرخ تبدیل نمایشی و تنظیمات موتور'**
  String get screenSettingsSub;

  /// No description provided for @chartCrosshair.
  ///
  /// In fa, this message translates to:
  /// **'زیر اشاره‌گر'**
  String get chartCrosshair;

  /// No description provided for @chartCrosshairNone.
  ///
  /// In fa, this message translates to:
  /// **'اشاره‌گر روی نمودار نیست'**
  String get chartCrosshairNone;

  /// No description provided for @retry.
  ///
  /// In fa, this message translates to:
  /// **'تلاش دوباره'**
  String get retry;

  /// No description provided for @loadFailed.
  ///
  /// In fa, this message translates to:
  /// **'بارگیری ناموفق بود: {error}'**
  String loadFailed(String error);

  /// No description provided for @pagePrev.
  ///
  /// In fa, this message translates to:
  /// **'قبلی'**
  String get pagePrev;

  /// No description provided for @pageNext.
  ///
  /// In fa, this message translates to:
  /// **'بعدی'**
  String get pageNext;

  /// No description provided for @pageOf.
  ///
  /// In fa, this message translates to:
  /// **'{from}–{to} از {total}'**
  String pageOf(int from, int to, int total);

  /// No description provided for @dataSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'مجموعه‌های نسخه‌بندی‌شده، کیفیت، پوشش زمانی و دریافت زنده. اصلاح منبع همیشه نسخه تازه می‌سازد.'**
  String get dataSubtitle;

  /// No description provided for @dataLiveStream.
  ///
  /// In fa, this message translates to:
  /// **'جریان زنده'**
  String get dataLiveStream;

  /// No description provided for @dataLiveStreamValue.
  ///
  /// In fa, this message translates to:
  /// **'{count} جفت · {source}'**
  String dataLiveStreamValue(int count, String source);

  /// No description provided for @dataLiveOff.
  ///
  /// In fa, this message translates to:
  /// **'خاموش'**
  String get dataLiveOff;

  /// No description provided for @dataLastBarAge.
  ///
  /// In fa, this message translates to:
  /// **'سن آخرین کندل'**
  String get dataLastBarAge;

  /// No description provided for @dataSeconds.
  ///
  /// In fa, this message translates to:
  /// **'{n} ثانیه'**
  String dataSeconds(int n);

  /// No description provided for @dataOutagesToday.
  ///
  /// In fa, this message translates to:
  /// **'قطعی‌های امروز'**
  String get dataOutagesToday;

  /// No description provided for @dataOutagesValue.
  ///
  /// In fa, this message translates to:
  /// **'{count} · مجموع {minutes} دقیقه'**
  String dataOutagesValue(int count, int minutes);

  /// No description provided for @dataStorage.
  ///
  /// In fa, this message translates to:
  /// **'فضای ذخیره'**
  String get dataStorage;

  /// No description provided for @dataDatasets.
  ///
  /// In fa, this message translates to:
  /// **'مجموعه‌های داده'**
  String get dataDatasets;

  /// No description provided for @dataColVersion.
  ///
  /// In fa, this message translates to:
  /// **'نسخه'**
  String get dataColVersion;

  /// No description provided for @dataColPair.
  ///
  /// In fa, this message translates to:
  /// **'جفت'**
  String get dataColPair;

  /// No description provided for @dataColTimeframe.
  ///
  /// In fa, this message translates to:
  /// **'تایم‌فریم'**
  String get dataColTimeframe;

  /// No description provided for @dataColRange.
  ///
  /// In fa, this message translates to:
  /// **'بازه'**
  String get dataColRange;

  /// No description provided for @dataColQuality.
  ///
  /// In fa, this message translates to:
  /// **'کیفیت'**
  String get dataColQuality;

  /// No description provided for @dataColExperiments.
  ///
  /// In fa, this message translates to:
  /// **'آزمایش‌های وابسته'**
  String get dataColExperiments;

  /// No description provided for @dataQualityOk.
  ///
  /// In fa, this message translates to:
  /// **'سالم'**
  String get dataQualityOk;

  /// No description provided for @dataQualityGaps.
  ///
  /// In fa, this message translates to:
  /// **'{n} شکاف'**
  String dataQualityGaps(int n);

  /// No description provided for @dataQualityFilled.
  ///
  /// In fa, this message translates to:
  /// **'{n} پرشده'**
  String dataQualityFilled(int n);

  /// No description provided for @dataDatasetsEmpty.
  ///
  /// In fa, this message translates to:
  /// **'هنوز نسخه‌ای از داده ساخته نشده است. از فرم واردسازی، اولین بازه را وارد کنید.'**
  String get dataDatasetsEmpty;

  /// No description provided for @dataCoverage.
  ///
  /// In fa, this message translates to:
  /// **'پوشش زمانی'**
  String get dataCoverage;

  /// No description provided for @dataCoverageLegend.
  ///
  /// In fa, this message translates to:
  /// **'نوار نارنجی = شکاف یا داده نامعتبر'**
  String get dataCoverageLegend;

  /// No description provided for @dataCoverageEmpty.
  ///
  /// In fa, this message translates to:
  /// **'هنوز کندلی ذخیره نشده است.'**
  String get dataCoverageEmpty;

  /// No description provided for @dataIssues.
  ///
  /// In fa, this message translates to:
  /// **'مشکلات کیفیت'**
  String get dataIssues;

  /// No description provided for @dataIssuesEmpty.
  ///
  /// In fa, this message translates to:
  /// **'مشکلی ثبت نشده است.'**
  String get dataIssuesEmpty;

  /// No description provided for @issueGap.
  ///
  /// In fa, this message translates to:
  /// **'شکاف'**
  String get issueGap;

  /// No description provided for @issueOutOfOrder.
  ///
  /// In fa, this message translates to:
  /// **'ترتیب نادرست'**
  String get issueOutOfOrder;

  /// No description provided for @issueDuplicate.
  ///
  /// In fa, this message translates to:
  /// **'تکراری'**
  String get issueDuplicate;

  /// No description provided for @issueBadPrice.
  ///
  /// In fa, this message translates to:
  /// **'قیمت نامعتبر'**
  String get issueBadPrice;

  /// No description provided for @issueZeroVolume.
  ///
  /// In fa, this message translates to:
  /// **'حجم صفر'**
  String get issueZeroVolume;

  /// No description provided for @issueCorrection.
  ///
  /// In fa, this message translates to:
  /// **'اصلاح منبع'**
  String get issueCorrection;

  /// No description provided for @issueOutage.
  ///
  /// In fa, this message translates to:
  /// **'قطعی'**
  String get issueOutage;

  /// No description provided for @dataImport.
  ///
  /// In fa, this message translates to:
  /// **'واردسازی تاریخچه'**
  String get dataImport;

  /// No description provided for @dataSource.
  ///
  /// In fa, this message translates to:
  /// **'منبع'**
  String get dataSource;

  /// No description provided for @dataSourceArchive.
  ///
  /// In fa, this message translates to:
  /// **'Binance public archive (klines)'**
  String get dataSourceArchive;

  /// No description provided for @dataPairs.
  ///
  /// In fa, this message translates to:
  /// **'جفت‌ها'**
  String get dataPairs;

  /// No description provided for @dataFrom.
  ///
  /// In fa, this message translates to:
  /// **'از'**
  String get dataFrom;

  /// No description provided for @dataTo.
  ///
  /// In fa, this message translates to:
  /// **'تا'**
  String get dataTo;

  /// No description provided for @dataDateHelp.
  ///
  /// In fa, this message translates to:
  /// **'تاریخ میلادی، UTC، به شکل 2024-01-31'**
  String get dataDateHelp;

  /// No description provided for @dataTimeframe.
  ///
  /// In fa, this message translates to:
  /// **'تایم‌فریم نسخه'**
  String get dataTimeframe;

  /// No description provided for @dataGapPolicy.
  ///
  /// In fa, this message translates to:
  /// **'سیاست شکاف'**
  String get dataGapPolicy;

  /// No description provided for @gapFlag.
  ///
  /// In fa, this message translates to:
  /// **'علامت‌گذاری، بدون پرکردن'**
  String get gapFlag;

  /// No description provided for @gapStop.
  ///
  /// In fa, this message translates to:
  /// **'توقف آزمایش'**
  String get gapStop;

  /// No description provided for @gapFfill.
  ///
  /// In fa, this message translates to:
  /// **'پرکردن با آخرین قیمت معلوم (بدون داده آینده)'**
  String get gapFfill;

  /// No description provided for @dataImportButton.
  ///
  /// In fa, this message translates to:
  /// **'واردسازی و ساخت نسخه'**
  String get dataImportButton;

  /// No description provided for @dataImportNote.
  ///
  /// In fa, this message translates to:
  /// **'واردسازی مجدد همان بازه رکورد تکراری نمی‌سازد. هر نسخه شناسه محتوا دارد و آزمایش‌های قبلی تغییر نمی‌کنند.'**
  String get dataImportNote;

  /// No description provided for @dataImportRunning.
  ///
  /// In fa, this message translates to:
  /// **'در حال واردسازی…'**
  String get dataImportRunning;

  /// No description provided for @dataImportProgress.
  ///
  /// In fa, this message translates to:
  /// **'{symbol}: {done} از {total} فایل · {inserted} کندل تازه'**
  String dataImportProgress(String symbol, int done, int total, int inserted);

  /// No description provided for @dataImportDone.
  ///
  /// In fa, this message translates to:
  /// **'نسخه ساخته شد'**
  String get dataImportDone;

  /// No description provided for @dataImportFailed.
  ///
  /// In fa, this message translates to:
  /// **'واردسازی ناموفق بود'**
  String get dataImportFailed;

  /// No description provided for @errPickPair.
  ///
  /// In fa, this message translates to:
  /// **'دست‌کم یک جفت انتخاب کنید.'**
  String get errPickPair;

  /// No description provided for @errDate.
  ///
  /// In fa, this message translates to:
  /// **'تاریخ را به شکل 2024-01-31 وارد کنید.'**
  String get errDate;

  /// No description provided for @errRange.
  ///
  /// In fa, this message translates to:
  /// **'«از» باید پیش از «تا» باشد و «تا» از امروز نگذرد.'**
  String get errRange;

  /// No description provided for @settingsCurrency.
  ///
  /// In fa, this message translates to:
  /// **'ارز مبنا و تبدیل به تومان'**
  String get settingsCurrency;

  /// No description provided for @settingsAccounting.
  ///
  /// In fa, this message translates to:
  /// **'ارز مبنای محاسبات'**
  String get settingsAccounting;

  /// No description provided for @settingsAccountingNote.
  ///
  /// In fa, this message translates to:
  /// **'ثابت؛ همه سود و زیان، ریسک و مقایسه‌ها'**
  String get settingsAccountingNote;

  /// No description provided for @settingsDisplayRate.
  ///
  /// In fa, this message translates to:
  /// **'نرخ نمایشی'**
  String get settingsDisplayRate;

  /// No description provided for @settingsDisplayRateNote.
  ///
  /// In fa, this message translates to:
  /// **'فقط در نمایش و خروجی؛ وارد محاسبه نمی‌شود'**
  String get settingsDisplayRateNote;

  /// No description provided for @settingsRateField.
  ///
  /// In fa, this message translates to:
  /// **'نرخ امروز (تومان به ازای ۱ USDT)'**
  String get settingsRateField;

  /// No description provided for @settingsRateHelp.
  ///
  /// In fa, this message translates to:
  /// **'عدد مثبت، حداکثر دو رقم اعشار'**
  String get settingsRateHelp;

  /// No description provided for @settingsDateField.
  ///
  /// In fa, this message translates to:
  /// **'تاریخ اعمال'**
  String get settingsDateField;

  /// No description provided for @settingsSourceField.
  ///
  /// In fa, this message translates to:
  /// **'منبع / یادداشت'**
  String get settingsSourceField;

  /// No description provided for @settingsSourceHelp.
  ///
  /// In fa, this message translates to:
  /// **'اختیاری؛ خالی یعنی «دستی»'**
  String get settingsSourceHelp;

  /// No description provided for @settingsSaveRate.
  ///
  /// In fa, this message translates to:
  /// **'ثبت نرخ'**
  String get settingsSaveRate;

  /// No description provided for @settingsRateSaved.
  ///
  /// In fa, this message translates to:
  /// **'نرخ ثبت شد'**
  String get settingsRateSaved;

  /// No description provided for @settingsRateNote.
  ///
  /// In fa, this message translates to:
  /// **'واحد نمایش «تومان» است (۱ تومان = ۱۰ ریال). هر گزارش نرخی را که با آن تبدیل شده نگه می‌دارد؛ ثبت نرخ تازه، گزارش‌های قبلی را تغییر نمی‌دهد.'**
  String get settingsRateNote;

  /// No description provided for @settingsHistory.
  ///
  /// In fa, this message translates to:
  /// **'تاریخچه نرخ‌ها'**
  String get settingsHistory;

  /// No description provided for @settingsColDate.
  ///
  /// In fa, this message translates to:
  /// **'تاریخ'**
  String get settingsColDate;

  /// No description provided for @settingsColRate.
  ///
  /// In fa, this message translates to:
  /// **'نرخ'**
  String get settingsColRate;

  /// No description provided for @settingsColSource.
  ///
  /// In fa, this message translates to:
  /// **'منبع'**
  String get settingsColSource;

  /// No description provided for @settingsColEntered.
  ///
  /// In fa, this message translates to:
  /// **'ثبت'**
  String get settingsColEntered;

  /// No description provided for @settingsColReports.
  ///
  /// In fa, this message translates to:
  /// **'گزارش‌های وابسته'**
  String get settingsColReports;

  /// No description provided for @settingsHistoryEmpty.
  ///
  /// In fa, this message translates to:
  /// **'هنوز نرخی ثبت نشده است. نرخ امروز را در فرم بالا وارد کنید.'**
  String get settingsHistoryEmpty;

  /// No description provided for @settingsOther.
  ///
  /// In fa, this message translates to:
  /// **'منابع موتور، پیش‌فرض‌های یادگیری و نگهداری'**
  String get settingsOther;

  /// No description provided for @settingsOtherNote.
  ///
  /// In fa, this message translates to:
  /// **'این بخش‌ها همراه صف اجرا (M4) و چرخه یادگیری (M5) فعال می‌شوند.'**
  String get settingsOtherNote;

  /// No description provided for @errRate.
  ///
  /// In fa, this message translates to:
  /// **'نرخ باید عددی مثبت با حداکثر دو رقم اعشار باشد.'**
  String get errRate;

  /// No description provided for @errFutureDate.
  ///
  /// In fa, this message translates to:
  /// **'تاریخ نمی‌تواند در آینده باشد.'**
  String get errFutureDate;

  /// No description provided for @invalid.
  ///
  /// In fa, this message translates to:
  /// **'نامعتبر'**
  String get invalid;

  /// No description provided for @unitUsdt.
  ///
  /// In fa, this message translates to:
  /// **'USDT'**
  String get unitUsdt;

  /// No description provided for @durationDays.
  ///
  /// In fa, this message translates to:
  /// **'{d} روز'**
  String durationDays(int d);

  /// No description provided for @durationHours.
  ///
  /// In fa, this message translates to:
  /// **'{h} ساعت'**
  String durationHours(int h);

  /// No description provided for @durationMinutes.
  ///
  /// In fa, this message translates to:
  /// **'{m} دقیقه'**
  String durationMinutes(int m);

  /// No description provided for @reportsNew.
  ///
  /// In fa, this message translates to:
  /// **'اجرای تازه'**
  String get reportsNew;

  /// No description provided for @reportsEmpty.
  ///
  /// In fa, this message translates to:
  /// **'هنوز گزارشی ساخته نشده است. با «اجرای تازه» اولین آزمون را بسازید.'**
  String get reportsEmpty;

  /// No description provided for @reportsCompareSelected.
  ///
  /// In fa, this message translates to:
  /// **'مقایسه {n} گزارش'**
  String reportsCompareSelected(int n);

  /// No description provided for @reportsColTitle.
  ///
  /// In fa, this message translates to:
  /// **'گزارش'**
  String get reportsColTitle;

  /// No description provided for @reportsColCreated.
  ///
  /// In fa, this message translates to:
  /// **'ساخته‌شده'**
  String get reportsColCreated;

  /// No description provided for @reportsColNet.
  ///
  /// In fa, this message translates to:
  /// **'سود خالص (OOS)'**
  String get reportsColNet;

  /// No description provided for @reportsColReturn.
  ///
  /// In fa, this message translates to:
  /// **'بازده'**
  String get reportsColReturn;

  /// No description provided for @reportsColTrades.
  ///
  /// In fa, this message translates to:
  /// **'معاملات'**
  String get reportsColTrades;

  /// No description provided for @reportsColVerdict.
  ///
  /// In fa, this message translates to:
  /// **'نتیجه'**
  String get reportsColVerdict;

  /// No description provided for @reportsColHoldout.
  ///
  /// In fa, this message translates to:
  /// **'آزمون نهایی'**
  String get reportsColHoldout;

  /// No description provided for @reportsSelect.
  ///
  /// In fa, this message translates to:
  /// **'انتخاب برای مقایسه'**
  String get reportsSelect;

  /// No description provided for @newDatasets.
  ///
  /// In fa, this message translates to:
  /// **'نسخه‌های داده'**
  String get newDatasets;

  /// No description provided for @newDatasetsHelp.
  ///
  /// In fa, this message translates to:
  /// **'یک نسخه برای هر جفت؛ همه با یک تایم‌فریم'**
  String get newDatasetsHelp;

  /// No description provided for @newDatasetsEmpty.
  ///
  /// In fa, this message translates to:
  /// **'نسخه‌ای نیست. ابتدا در صفحه داده یک بازه وارد کنید.'**
  String get newDatasetsEmpty;

  /// No description provided for @newStrategy.
  ///
  /// In fa, this message translates to:
  /// **'راهبرد'**
  String get newStrategy;

  /// No description provided for @newParams.
  ///
  /// In fa, this message translates to:
  /// **'پارامترها'**
  String get newParams;

  /// No description provided for @newCapital.
  ///
  /// In fa, this message translates to:
  /// **'سرمایه اولیه'**
  String get newCapital;

  /// No description provided for @newFeeBps.
  ///
  /// In fa, this message translates to:
  /// **'کارمزد هر سمت'**
  String get newFeeBps;

  /// No description provided for @newSlipBps.
  ///
  /// In fa, this message translates to:
  /// **'لغزش هر سمت'**
  String get newSlipBps;

  /// No description provided for @bps.
  ///
  /// In fa, this message translates to:
  /// **'bps'**
  String get bps;

  /// No description provided for @bpsHelp.
  ///
  /// In fa, this message translates to:
  /// **'۱ bps = ۰٫۰۱٪؛ مثلاً ۱۰ یعنی ۰٫۱٪'**
  String get bpsHelp;

  /// No description provided for @newFolds.
  ///
  /// In fa, this message translates to:
  /// **'تعداد گام‌های آزمون'**
  String get newFolds;

  /// No description provided for @newHoldout.
  ///
  /// In fa, this message translates to:
  /// **'سهم آزمون نهایی'**
  String get newHoldout;

  /// No description provided for @newHoldoutHelp.
  ///
  /// In fa, this message translates to:
  /// **'درصد پایانی داده که پنهان می‌ماند'**
  String get newHoldoutHelp;

  /// No description provided for @newRolling.
  ///
  /// In fa, this message translates to:
  /// **'پنجره آموزش غلتان'**
  String get newRolling;

  /// No description provided for @newRun.
  ///
  /// In fa, this message translates to:
  /// **'اجرا و ساخت گزارش'**
  String get newRun;

  /// No description provided for @newRunning.
  ///
  /// In fa, this message translates to:
  /// **'در حال ارزیابی گام‌به‌گام…'**
  String get newRunning;

  /// No description provided for @errRequired.
  ///
  /// In fa, this message translates to:
  /// **'این مقدار لازم است.'**
  String get errRequired;

  /// No description provided for @errPositive.
  ///
  /// In fa, this message translates to:
  /// **'عددی مثبت وارد کنید.'**
  String get errPositive;

  /// No description provided for @errNumber.
  ///
  /// In fa, this message translates to:
  /// **'عدد معتبر وارد کنید.'**
  String get errNumber;

  /// No description provided for @errBps.
  ///
  /// In fa, this message translates to:
  /// **'عددی بین ۰ و ۱۰۰۰ با حداکثر دو رقم اعشار.'**
  String get errBps;

  /// No description provided for @errPickDataset.
  ///
  /// In fa, this message translates to:
  /// **'دست‌کم یک نسخه داده انتخاب کنید.'**
  String get errPickDataset;

  /// No description provided for @reportTitle.
  ///
  /// In fa, this message translates to:
  /// **'گزارش'**
  String get reportTitle;

  /// No description provided for @reportExportCsv.
  ///
  /// In fa, this message translates to:
  /// **'خروجی CSV'**
  String get reportExportCsv;

  /// No description provided for @reportExportMetrics.
  ///
  /// In fa, this message translates to:
  /// **'معیارها CSV'**
  String get reportExportMetrics;

  /// No description provided for @reportExportJson.
  ///
  /// In fa, this message translates to:
  /// **'تعریف JSON'**
  String get reportExportJson;

  /// No description provided for @reportReproduce.
  ///
  /// In fa, this message translates to:
  /// **'اجرای مجدد (بازتولید)'**
  String get reportReproduce;

  /// No description provided for @reportReproduceOk.
  ///
  /// In fa, this message translates to:
  /// **'بازتولید شد: همه اعداد دقیقاً یکسان‌اند.'**
  String get reportReproduceOk;

  /// No description provided for @reportReproduceFail.
  ///
  /// In fa, this message translates to:
  /// **'بازتولید متفاوت بود؛ گزارش را بررسی کنید.'**
  String get reportReproduceFail;

  /// No description provided for @reportAddCompare.
  ///
  /// In fa, this message translates to:
  /// **'افزودن به مقایسه'**
  String get reportAddCompare;

  /// No description provided for @reportInCompare.
  ///
  /// In fa, this message translates to:
  /// **'در فهرست مقایسه'**
  String get reportInCompare;

  /// No description provided for @reportOpenPnl.
  ///
  /// In fa, this message translates to:
  /// **'آزمودن سرمایه و کارمزد دیگر در ماشین‌حساب'**
  String get reportOpenPnl;

  /// No description provided for @reportSummary.
  ///
  /// In fa, this message translates to:
  /// **'خلاصه به زبان ساده'**
  String get reportSummary;

  /// No description provided for @reportWaterfall.
  ///
  /// In fa, this message translates to:
  /// **'از سود ناخالص تا سود خالص'**
  String get reportWaterfall;

  /// No description provided for @reportFinalEquity.
  ///
  /// In fa, this message translates to:
  /// **'ارزش نهایی حساب'**
  String get reportFinalEquity;

  /// No description provided for @reportToman.
  ///
  /// In fa, this message translates to:
  /// **'معادل تومانی'**
  String get reportToman;

  /// No description provided for @reportTomanRate.
  ///
  /// In fa, this message translates to:
  /// **'نرخ #{id} · {date}'**
  String reportTomanRate(String id, String date);

  /// No description provided for @reportTomanNone.
  ///
  /// In fa, this message translates to:
  /// **'نرخی ثبت نشده'**
  String get reportTomanNone;

  /// No description provided for @reportBreakEven.
  ///
  /// In fa, this message translates to:
  /// **'کارمزد سر‌به‌سر'**
  String get reportBreakEven;

  /// No description provided for @reportBreakEvenNone.
  ///
  /// In fa, this message translates to:
  /// **'هیچ کارمزدی آن را سودده نمی‌کند'**
  String get reportBreakEvenNone;

  /// No description provided for @reportEquity.
  ///
  /// In fa, this message translates to:
  /// **'منحنی ارزش حساب'**
  String get reportEquity;

  /// No description provided for @reportCandidate.
  ///
  /// In fa, this message translates to:
  /// **'این راهبرد'**
  String get reportCandidate;

  /// No description provided for @benchBuyAndHold.
  ///
  /// In fa, this message translates to:
  /// **'خرید و نگهداری'**
  String get benchBuyAndHold;

  /// No description provided for @benchHoldCash.
  ///
  /// In fa, this message translates to:
  /// **'نگهداری نقد'**
  String get benchHoldCash;

  /// No description provided for @regionInSample.
  ///
  /// In fa, this message translates to:
  /// **'داده آموزش'**
  String get regionInSample;

  /// No description provided for @regionOos.
  ///
  /// In fa, this message translates to:
  /// **'خارج از نمونه'**
  String get regionOos;

  /// No description provided for @regionHoldout.
  ///
  /// In fa, this message translates to:
  /// **'آزمون نهایی'**
  String get regionHoldout;

  /// No description provided for @reportFolds.
  ///
  /// In fa, this message translates to:
  /// **'گام‌های ارزیابی گام‌به‌گام'**
  String get reportFolds;

  /// No description provided for @foldStep.
  ///
  /// In fa, this message translates to:
  /// **'گام'**
  String get foldStep;

  /// No description provided for @foldTrainUntil.
  ///
  /// In fa, this message translates to:
  /// **'آموزش تا'**
  String get foldTrainUntil;

  /// No description provided for @foldTest.
  ///
  /// In fa, this message translates to:
  /// **'آزمون'**
  String get foldTest;

  /// No description provided for @foldReturn.
  ///
  /// In fa, this message translates to:
  /// **'بازده خالص'**
  String get foldReturn;

  /// No description provided for @foldDrawdown.
  ///
  /// In fa, this message translates to:
  /// **'افت'**
  String get foldDrawdown;

  /// No description provided for @foldTrades.
  ///
  /// In fa, this message translates to:
  /// **'معاملات'**
  String get foldTrades;

  /// No description provided for @reportStress.
  ///
  /// In fa, this message translates to:
  /// **'سناریوهای تنش'**
  String get reportStress;

  /// No description provided for @stress_fee_x2.
  ///
  /// In fa, this message translates to:
  /// **'کارمزد × ۲'**
  String get stress_fee_x2;

  /// No description provided for @stress_slippage_x3.
  ///
  /// In fa, this message translates to:
  /// **'لغزش × ۳'**
  String get stress_slippage_x3;

  /// No description provided for @stress_latency_plus_1.
  ///
  /// In fa, this message translates to:
  /// **'تأخیر +۱ کندل'**
  String get stress_latency_plus_1;

  /// No description provided for @reportSensitivity.
  ///
  /// In fa, this message translates to:
  /// **'حساسیت پارامتر'**
  String get reportSensitivity;

  /// No description provided for @reportSensitivityHelp.
  ///
  /// In fa, this message translates to:
  /// **'بازده خالص خارج از نمونه · افقی {x}{y}'**
  String reportSensitivityHelp(String x, String y);

  /// No description provided for @reportSensitivityY.
  ///
  /// In fa, this message translates to:
  /// **'، عمودی {y}'**
  String reportSensitivityY(String y);

  /// No description provided for @reportSensitivityNone.
  ///
  /// In fa, this message translates to:
  /// **'این راهبرد پارامتر سیگنالی برای آزمون همسایگی ندارد.'**
  String get reportSensitivityNone;

  /// No description provided for @reportHoldout.
  ///
  /// In fa, this message translates to:
  /// **'آزمون نهایی (holdout)'**
  String get reportHoldout;

  /// No description provided for @reportHoldoutHidden.
  ///
  /// In fa, this message translates to:
  /// **'نتیجه آزمون نهایی پنهان است تا تصمیم‌ها روی آن تنظیم نشوند. هر بار دیدن ثبت می‌شود.'**
  String get reportHoldoutHidden;

  /// No description provided for @reportHoldoutShow.
  ///
  /// In fa, this message translates to:
  /// **'نمایش آزمون نهایی'**
  String get reportHoldoutShow;

  /// No description provided for @reportHoldoutConfirm.
  ///
  /// In fa, this message translates to:
  /// **'نمایش آزمون نهایی ثبت می‌شود و در گزارش به‌عنوان «دیده‌شده» نشان داده خواهد شد. پس از دیدن، تنظیم دوباره پارامترها روی این داده نتیجه را بی‌اعتبار می‌کند. ادامه می‌دهید؟'**
  String get reportHoldoutConfirm;

  /// No description provided for @reportHoldoutViews.
  ///
  /// In fa, this message translates to:
  /// **'آزمون نهایی: {n} بار مشاهده'**
  String reportHoldoutViews(int n);

  /// No description provided for @reportTrades.
  ///
  /// In fa, this message translates to:
  /// **'معاملات خارج از نمونه'**
  String get reportTrades;

  /// No description provided for @tradeEntryExit.
  ///
  /// In fa, this message translates to:
  /// **'ورود → خروج'**
  String get tradeEntryExit;

  /// No description provided for @tradeGross.
  ///
  /// In fa, this message translates to:
  /// **'ناخالص'**
  String get tradeGross;

  /// No description provided for @tradeCost.
  ///
  /// In fa, this message translates to:
  /// **'هزینه'**
  String get tradeCost;

  /// No description provided for @tradeNet.
  ///
  /// In fa, this message translates to:
  /// **'خالص'**
  String get tradeNet;

  /// No description provided for @tradeOpen.
  ///
  /// In fa, this message translates to:
  /// **'باز'**
  String get tradeOpen;

  /// No description provided for @cancel.
  ///
  /// In fa, this message translates to:
  /// **'انصراف'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In fa, this message translates to:
  /// **'تأیید'**
  String get confirm;

  /// No description provided for @badgeEngine.
  ///
  /// In fa, this message translates to:
  /// **'کد {v}'**
  String badgeEngine(String v);

  /// No description provided for @badgeDatasets.
  ///
  /// In fa, this message translates to:
  /// **'داده {ids}'**
  String badgeDatasets(String ids);

  /// No description provided for @compareSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'نتایج فقط وقتی کنار هم معنا دارند که فرض‌ها یکسان باشند؛ تفاوت‌ها پیش از معیارها نمایش داده می‌شوند.'**
  String get compareSubtitle;

  /// No description provided for @compareAssumptions.
  ///
  /// In fa, this message translates to:
  /// **'هم‌ارزی فرض‌ها'**
  String get compareAssumptions;

  /// No description provided for @compareAssumption.
  ///
  /// In fa, this message translates to:
  /// **'فرض'**
  String get compareAssumption;

  /// No description provided for @compareSame.
  ///
  /// In fa, this message translates to:
  /// **'یکسان'**
  String get compareSame;

  /// No description provided for @compareDiffers.
  ///
  /// In fa, this message translates to:
  /// **'متفاوت'**
  String get compareDiffers;

  /// No description provided for @compareNote.
  ///
  /// In fa, this message translates to:
  /// **'در تفسیر لحاظ شود'**
  String get compareNote;

  /// No description provided for @compareMismatch.
  ///
  /// In fa, this message translates to:
  /// **'{n} تفاوت در فرض‌ها: {what}'**
  String compareMismatch(int n, String what);

  /// No description provided for @compareEquity.
  ///
  /// In fa, this message translates to:
  /// **'منحنی ارزش خارج از نمونه (USDT)'**
  String get compareEquity;

  /// No description provided for @compareEquityHelp.
  ///
  /// In fa, this message translates to:
  /// **'هر اجرا رنگ و سبک خط جداگانه دارد.'**
  String get compareEquityHelp;

  /// No description provided for @compareMetrics.
  ///
  /// In fa, this message translates to:
  /// **'معیارها'**
  String get compareMetrics;

  /// No description provided for @compareMetric.
  ///
  /// In fa, this message translates to:
  /// **'معیار'**
  String get compareMetric;

  /// No description provided for @compareTotalCost.
  ///
  /// In fa, this message translates to:
  /// **'هزینه کل'**
  String get compareTotalCost;

  /// No description provided for @compareEligible.
  ///
  /// In fa, this message translates to:
  /// **'واجد شرایط'**
  String get compareEligible;

  /// No description provided for @compareYes.
  ///
  /// In fa, this message translates to:
  /// **'بله'**
  String get compareYes;

  /// No description provided for @compareNo.
  ///
  /// In fa, this message translates to:
  /// **'خیر'**
  String get compareNo;

  /// No description provided for @compareConclusion.
  ///
  /// In fa, this message translates to:
  /// **'جمع‌بندی'**
  String get compareConclusion;

  /// No description provided for @compareEmpty.
  ///
  /// In fa, this message translates to:
  /// **'دست‌کم دو گزارش را از فهرست گزارش‌ها برای مقایسه انتخاب کنید.'**
  String get compareEmpty;

  /// No description provided for @compareClear.
  ///
  /// In fa, this message translates to:
  /// **'پاک کردن فهرست'**
  String get compareClear;

  /// No description provided for @pnlSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'ببینید یک الگوریتم یا یک معامله، پس از کارمزد و لغزش، دقیقاً چقدر سود یا زیان می‌سازد — و اگر شرایط عوض شود چه می‌شود.'**
  String get pnlSubtitle;

  /// No description provided for @pnlTabRun.
  ///
  /// In fa, this message translates to:
  /// **'نتیجه یک الگوریتم (از اجرای ثبت‌شده)'**
  String get pnlTabRun;

  /// No description provided for @pnlTabTrade.
  ///
  /// In fa, this message translates to:
  /// **'یک معامله'**
  String get pnlTabTrade;

  /// No description provided for @pnlInputs.
  ///
  /// In fa, this message translates to:
  /// **'ورودی‌ها'**
  String get pnlInputs;

  /// No description provided for @pnlReport.
  ///
  /// In fa, this message translates to:
  /// **'اجرای ثبت‌شده'**
  String get pnlReport;

  /// No description provided for @pnlNoReports.
  ///
  /// In fa, this message translates to:
  /// **'هنوز گزارشی نیست؛ ابتدا یک اجرای تازه بسازید.'**
  String get pnlNoReports;

  /// No description provided for @pnlSize.
  ///
  /// In fa, this message translates to:
  /// **'اندازه موقعیت نسبت به اجرای اصلی'**
  String get pnlSize;

  /// No description provided for @pnlSizeHelp.
  ///
  /// In fa, this message translates to:
  /// **'۱۰۰٪ یعنی همان اندازه ثبت‌شده'**
  String get pnlSizeHelp;

  /// No description provided for @pnlRate.
  ///
  /// In fa, this message translates to:
  /// **'نرخ تبدیل نمایشی'**
  String get pnlRate;

  /// No description provided for @pnlRateNone.
  ///
  /// In fa, this message translates to:
  /// **'بدون تومان'**
  String get pnlRateNone;

  /// No description provided for @pnlReset.
  ///
  /// In fa, this message translates to:
  /// **'بازگشت به تنظیمات اجرای اصلی'**
  String get pnlReset;

  /// No description provided for @pnlOriginalNet.
  ///
  /// In fa, this message translates to:
  /// **'سود خالص اجرای اصلی'**
  String get pnlOriginalNet;

  /// No description provided for @pnlNet.
  ///
  /// In fa, this message translates to:
  /// **'سود خالص'**
  String get pnlNet;

  /// No description provided for @pnlFinal.
  ///
  /// In fa, this message translates to:
  /// **'ارزش نهایی'**
  String get pnlFinal;

  /// No description provided for @pnlBreakEvenFee.
  ///
  /// In fa, this message translates to:
  /// **'کارمزد سر‌به‌سر'**
  String get pnlBreakEvenFee;

  /// No description provided for @pnlEquity.
  ///
  /// In fa, this message translates to:
  /// **'ارزش حساب'**
  String get pnlEquity;

  /// No description provided for @pnlTradeInputs.
  ///
  /// In fa, this message translates to:
  /// **'ورودی‌های معامله'**
  String get pnlTradeInputs;

  /// No description provided for @pnlSpotNote.
  ///
  /// In fa, this message translates to:
  /// **'بازار اسپات: خرید و سپس فروش. فروش استقراضی ممکن نیست.'**
  String get pnlSpotNote;

  /// No description provided for @pnlEntry.
  ///
  /// In fa, this message translates to:
  /// **'قیمت ورود'**
  String get pnlEntry;

  /// No description provided for @pnlExit.
  ///
  /// In fa, this message translates to:
  /// **'قیمت خروج'**
  String get pnlExit;

  /// No description provided for @pnlAmount.
  ///
  /// In fa, this message translates to:
  /// **'مبلغ خرید'**
  String get pnlAmount;

  /// No description provided for @pnlQty.
  ///
  /// In fa, this message translates to:
  /// **'مقدار'**
  String get pnlQty;

  /// No description provided for @pnlCost.
  ///
  /// In fa, this message translates to:
  /// **'هزینه کل خرید'**
  String get pnlCost;

  /// No description provided for @pnlReturn.
  ///
  /// In fa, this message translates to:
  /// **'بازده روی هزینه'**
  String get pnlReturn;

  /// No description provided for @pnlBreakEvenExit.
  ///
  /// In fa, this message translates to:
  /// **'قیمت فروش سر‌به‌سر'**
  String get pnlBreakEvenExit;

  /// No description provided for @pnlTomanNet.
  ///
  /// In fa, this message translates to:
  /// **'سود خالص به تومان'**
  String get pnlTomanNet;

  /// No description provided for @st_running.
  ///
  /// In fa, this message translates to:
  /// **'در حال اجرا'**
  String get st_running;

  /// No description provided for @st_paused.
  ///
  /// In fa, this message translates to:
  /// **'متوقف موقت'**
  String get st_paused;

  /// No description provided for @st_finalizing.
  ///
  /// In fa, this message translates to:
  /// **'در حال جمع‌بندی'**
  String get st_finalizing;

  /// No description provided for @st_done.
  ///
  /// In fa, this message translates to:
  /// **'کامل'**
  String get st_done;

  /// No description provided for @st_cancelled.
  ///
  /// In fa, this message translates to:
  /// **'لغو شد'**
  String get st_cancelled;

  /// No description provided for @st_failed.
  ///
  /// In fa, this message translates to:
  /// **'شکست'**
  String get st_failed;

  /// No description provided for @st_queued.
  ///
  /// In fa, this message translates to:
  /// **'در صف'**
  String get st_queued;

  /// No description provided for @lc_research.
  ///
  /// In fa, this message translates to:
  /// **'پژوهش'**
  String get lc_research;

  /// No description provided for @lc_validation.
  ///
  /// In fa, this message translates to:
  /// **'اعتبارسنجی'**
  String get lc_validation;

  /// No description provided for @lc_forward_test.
  ///
  /// In fa, this message translates to:
  /// **'آزمون پیشرو'**
  String get lc_forward_test;

  /// No description provided for @lc_active.
  ///
  /// In fa, this message translates to:
  /// **'فعال'**
  String get lc_active;

  /// No description provided for @lc_stopped.
  ///
  /// In fa, this message translates to:
  /// **'متوقف'**
  String get lc_stopped;

  /// No description provided for @lc_retired.
  ///
  /// In fa, this message translates to:
  /// **'بازنشسته'**
  String get lc_retired;

  /// No description provided for @fam_all.
  ///
  /// In fa, this message translates to:
  /// **'همه'**
  String get fam_all;

  /// No description provided for @fam_trend.
  ///
  /// In fa, this message translates to:
  /// **'روند'**
  String get fam_trend;

  /// No description provided for @fam_mean_reversion.
  ///
  /// In fa, this message translates to:
  /// **'بازگشت به میانگین'**
  String get fam_mean_reversion;

  /// No description provided for @fam_learning.
  ///
  /// In fa, this message translates to:
  /// **'یادگیرنده'**
  String get fam_learning;

  /// No description provided for @fam_hybrid.
  ///
  /// In fa, this message translates to:
  /// **'ترکیبی'**
  String get fam_hybrid;

  /// No description provided for @fam_benchmark.
  ///
  /// In fa, this message translates to:
  /// **'معیار مقایسه'**
  String get fam_benchmark;

  /// No description provided for @bSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'در چند قدم ساده. مقدارهای پیش‌فرض امن‌اند؛ فقط آنچه برایتان مهم است را تغییر دهید.'**
  String get bSubtitle;

  /// No description provided for @bStep0.
  ///
  /// In fa, this message translates to:
  /// **'شروع'**
  String get bStep0;

  /// No description provided for @bStep1.
  ///
  /// In fa, this message translates to:
  /// **'ایده'**
  String get bStep1;

  /// No description provided for @bStep2.
  ///
  /// In fa, this message translates to:
  /// **'داده'**
  String get bStep2;

  /// No description provided for @bStep3.
  ///
  /// In fa, this message translates to:
  /// **'الگوریتم'**
  String get bStep3;

  /// No description provided for @bStep4.
  ///
  /// In fa, this message translates to:
  /// **'پول و هزینه'**
  String get bStep4;

  /// No description provided for @bStep5.
  ///
  /// In fa, this message translates to:
  /// **'بررسی و اجرا'**
  String get bStep5;

  /// No description provided for @bWhat.
  ///
  /// In fa, this message translates to:
  /// **'چه کاری می‌خواهید انجام دهید؟'**
  String get bWhat;

  /// No description provided for @tplQuick.
  ///
  /// In fa, this message translates to:
  /// **'آزمون سریع یک الگوریتم'**
  String get tplQuick;

  /// No description provided for @tplQuickDesc.
  ///
  /// In fa, this message translates to:
  /// **'یک الگوریتم را با تنظیمات فعلی‌اش روی داده تازه امتحان کنید.'**
  String get tplQuickDesc;

  /// No description provided for @tplQuickMeta.
  ///
  /// In fa, this message translates to:
  /// **'۱ نامزد'**
  String get tplQuickMeta;

  /// No description provided for @tplSearch.
  ///
  /// In fa, this message translates to:
  /// **'یافتن بهترین تنظیمات'**
  String get tplSearch;

  /// No description provided for @tplSearchDesc.
  ///
  /// In fa, this message translates to:
  /// **'چند ترکیب از تنظیمات را امتحان کنید و ببینید کدام پایدارتر است.'**
  String get tplSearchDesc;

  /// No description provided for @tplSearchMeta.
  ///
  /// In fa, this message translates to:
  /// **'ده‌ها اجرا · همه ثبت می‌شوند'**
  String get tplSearchMeta;

  /// No description provided for @tplIdea.
  ///
  /// In fa, this message translates to:
  /// **'سنجش یک ایده تازه'**
  String get tplIdea;

  /// No description provided for @tplIdeaDesc.
  ///
  /// In fa, this message translates to:
  /// **'یک تنظیم را عوض کنید و دو نسخه را کنار هم بسنجید.'**
  String get tplIdeaDesc;

  /// No description provided for @tplIdeaMeta.
  ///
  /// In fa, this message translates to:
  /// **'۲ نامزد · مقایسه کنار هم'**
  String get tplIdeaMeta;

  /// No description provided for @bIdeaTitle.
  ///
  /// In fa, this message translates to:
  /// **'چه چیزی را می‌خواهید بسنجید؟'**
  String get bIdeaTitle;

  /// No description provided for @bName.
  ///
  /// In fa, this message translates to:
  /// **'نام آزمایش'**
  String get bName;

  /// No description provided for @bHypothesis.
  ///
  /// In fa, this message translates to:
  /// **'ایده شما در یک جمله'**
  String get bHypothesis;

  /// No description provided for @bHypothesisHelp.
  ///
  /// In fa, this message translates to:
  /// **'مثال: «اگر فقط در بازار کم‌نوسان معامله کنیم، زیان‌های بزرگ کمتر می‌شود.»'**
  String get bHypothesisHelp;

  /// No description provided for @bFalsifier.
  ///
  /// In fa, this message translates to:
  /// **'چه نتیجه‌ای یعنی ایده درست نبود؟'**
  String get bFalsifier;

  /// No description provided for @bFalsifierHelp.
  ///
  /// In fa, this message translates to:
  /// **'این را قبل از دیدن نتیجه بنویسید تا بعداً خودتان را قانع نکنید.'**
  String get bFalsifierHelp;

  /// No description provided for @bGoal.
  ///
  /// In fa, this message translates to:
  /// **'مهم‌ترین هدف'**
  String get bGoal;

  /// No description provided for @goalNet.
  ///
  /// In fa, this message translates to:
  /// **'بیشترین بازده با سقف افت سرمایه'**
  String get goalNet;

  /// No description provided for @goalDd.
  ///
  /// In fa, this message translates to:
  /// **'کمترین افت با حداقل سود'**
  String get goalDd;

  /// No description provided for @goalStable.
  ///
  /// In fa, this message translates to:
  /// **'بهترین نسبت شارپ'**
  String get goalStable;

  /// No description provided for @bDataTitle.
  ///
  /// In fa, this message translates to:
  /// **'روی چه بازار و دوره‌ای؟'**
  String get bDataTitle;

  /// No description provided for @bTimeframe.
  ///
  /// In fa, this message translates to:
  /// **'بازه زمانی هر کندل'**
  String get bTimeframe;

  /// No description provided for @bDatasets.
  ///
  /// In fa, this message translates to:
  /// **'نسخه‌های داده (یکی برای هر جفت)'**
  String get bDatasets;

  /// No description provided for @bDatasetsEmpty.
  ///
  /// In fa, this message translates to:
  /// **'برای این تایم‌فریم نسخه‌ای نیست؛ از صفحه داده وارد کنید.'**
  String get bDatasetsEmpty;

  /// No description provided for @bAlgoTitle.
  ///
  /// In fa, this message translates to:
  /// **'کدام الگوریتم؟'**
  String get bAlgoTitle;

  /// No description provided for @bParamsTitle.
  ///
  /// In fa, this message translates to:
  /// **'کدام تنظیمات امتحان شوند؟'**
  String get bParamsTitle;

  /// No description provided for @bParam.
  ///
  /// In fa, this message translates to:
  /// **'تنظیم'**
  String get bParam;

  /// No description provided for @bParamDefault.
  ///
  /// In fa, this message translates to:
  /// **'پیش‌فرض'**
  String get bParamDefault;

  /// No description provided for @bParamValues.
  ///
  /// In fa, this message translates to:
  /// **'مقدارها (با ویرگول)'**
  String get bParamValues;

  /// No description provided for @bParamValuesHelp.
  ///
  /// In fa, this message translates to:
  /// **'خالی یعنی همان پیش‌فرض'**
  String get bParamValuesHelp;

  /// No description provided for @bNoParams.
  ///
  /// In fa, this message translates to:
  /// **'این الگوریتم تنظیمی برای جست‌وجو ندارد.'**
  String get bNoParams;

  /// No description provided for @bMoneyTitle.
  ///
  /// In fa, this message translates to:
  /// **'پول و هزینه‌ها'**
  String get bMoneyTitle;

  /// No description provided for @bRoundTrip.
  ///
  /// In fa, this message translates to:
  /// **'هر معامله کامل (خرید و فروش) با این تنظیمات حدود {pct} هزینه دارد؛ الگوریتم باید در هر معامله بیش از این سود ناخالص بسازد.'**
  String bRoundTrip(String pct);

  /// No description provided for @bReviewTitle.
  ///
  /// In fa, this message translates to:
  /// **'بررسی نهایی'**
  String get bReviewTitle;

  /// No description provided for @bAdvanced.
  ///
  /// In fa, this message translates to:
  /// **'تنظیمات پیشرفته'**
  String get bAdvanced;

  /// No description provided for @bAdvancedHelp.
  ///
  /// In fa, this message translates to:
  /// **'این‌ها پیش‌فرض‌های امن هستند و معمولاً نیازی به تغییر ندارند.'**
  String get bAdvancedHelp;

  /// No description provided for @bMaxDd.
  ///
  /// In fa, this message translates to:
  /// **'سقف افت سرمایه'**
  String get bMaxDd;

  /// No description provided for @bMinTrades.
  ///
  /// In fa, this message translates to:
  /// **'حداقل معامله بسته'**
  String get bMinTrades;

  /// No description provided for @bMinReturn.
  ///
  /// In fa, this message translates to:
  /// **'حداقل بازده'**
  String get bMinReturn;

  /// No description provided for @bSearchMode.
  ///
  /// In fa, this message translates to:
  /// **'روش جست‌وجو'**
  String get bSearchMode;

  /// No description provided for @modeGrid.
  ///
  /// In fa, this message translates to:
  /// **'شبکه‌ای (همه ترکیب‌ها)'**
  String get modeGrid;

  /// No description provided for @modeRandom.
  ///
  /// In fa, this message translates to:
  /// **'تصادفی با بذر'**
  String get modeRandom;

  /// No description provided for @bSeed.
  ///
  /// In fa, this message translates to:
  /// **'بذر'**
  String get bSeed;

  /// No description provided for @bMaxAttempts.
  ///
  /// In fa, this message translates to:
  /// **'سقف تلاش‌ها'**
  String get bMaxAttempts;

  /// No description provided for @bMaxMinutes.
  ///
  /// In fa, this message translates to:
  /// **'سقف زمان'**
  String get bMaxMinutes;

  /// No description provided for @minutes.
  ///
  /// In fa, this message translates to:
  /// **'دقیقه'**
  String get minutes;

  /// No description provided for @bBack.
  ///
  /// In fa, this message translates to:
  /// **'قبلی'**
  String get bBack;

  /// No description provided for @bNext.
  ///
  /// In fa, this message translates to:
  /// **'بعدی'**
  String get bNext;

  /// No description provided for @bRun.
  ///
  /// In fa, this message translates to:
  /// **'ثبت و اجرا'**
  String get bRun;

  /// No description provided for @bSummary.
  ///
  /// In fa, this message translates to:
  /// **'آنچه تا الان انتخاب کرده‌اید'**
  String get bSummary;

  /// No description provided for @bRuns.
  ///
  /// In fa, this message translates to:
  /// **'{n} اجرا · {c} نامزد'**
  String bRuns(int n, int c);

  /// No description provided for @bEta.
  ///
  /// In fa, this message translates to:
  /// **'حدود {t}'**
  String bEta(String t);

  /// No description provided for @bLockNote.
  ///
  /// In fa, this message translates to:
  /// **'پس از شروع، این تعریف قفل می‌شود. اگر بعداً چیزی را عوض کنید، آزمایش تازه‌ای با ارجاع به همین ساخته می‌شود.'**
  String get bLockNote;

  /// No description provided for @bExisted.
  ///
  /// In fa, this message translates to:
  /// **'این آزمایش با همین تعریف قبلاً اجرا شده بود؛ همان را باز کردیم.'**
  String get bExisted;

  /// No description provided for @bDraftRestored.
  ///
  /// In fa, this message translates to:
  /// **'پیش‌نویس قبلی بازیابی شد.'**
  String get bDraftRestored;

  /// No description provided for @bDraftClear.
  ///
  /// In fa, this message translates to:
  /// **'شروع از نو'**
  String get bDraftClear;

  /// No description provided for @errHypothesis.
  ///
  /// In fa, this message translates to:
  /// **'ایده و نتیجه ردکننده را بنویسید.'**
  String get errHypothesis;

  /// No description provided for @errDatasetsPerPair.
  ///
  /// In fa, this message translates to:
  /// **'برای هر جفت فقط یک نسخه داده انتخاب کنید.'**
  String get errDatasetsPerPair;

  /// No description provided for @errValues.
  ///
  /// In fa, this message translates to:
  /// **'عددهای مثبت با ویرگول؛ برای تنظیم‌های عدد صحیح فقط عدد صحیح.'**
  String get errValues;

  /// No description provided for @qListEmpty.
  ///
  /// In fa, this message translates to:
  /// **'هنوز آزمایشی نیست. با «ساخت آزمایش» شروع کنید.'**
  String get qListEmpty;

  /// No description provided for @qNew.
  ///
  /// In fa, this message translates to:
  /// **'ساخت آزمایش'**
  String get qNew;

  /// No description provided for @qColName.
  ///
  /// In fa, this message translates to:
  /// **'آزمایش'**
  String get qColName;

  /// No description provided for @qColStatus.
  ///
  /// In fa, this message translates to:
  /// **'وضعیت'**
  String get qColStatus;

  /// No description provided for @qColProgress.
  ///
  /// In fa, this message translates to:
  /// **'پیشرفت'**
  String get qColProgress;

  /// No description provided for @qColCreated.
  ///
  /// In fa, this message translates to:
  /// **'شروع'**
  String get qColCreated;

  /// No description provided for @qPause.
  ///
  /// In fa, this message translates to:
  /// **'توقف موقت'**
  String get qPause;

  /// No description provided for @qResume.
  ///
  /// In fa, this message translates to:
  /// **'ادامه'**
  String get qResume;

  /// No description provided for @qCancel.
  ///
  /// In fa, this message translates to:
  /// **'لغو آزمایش'**
  String get qCancel;

  /// No description provided for @qCancelConfirm.
  ///
  /// In fa, this message translates to:
  /// **'تلاش‌های در صف لغو می‌شوند و آزمایش پایان می‌یابد. همه تلاش‌های انجام‌شده ثبت می‌مانند. ادامه می‌دهید؟'**
  String get qCancelConfirm;

  /// No description provided for @qPauseConfirm.
  ///
  /// In fa, this message translates to:
  /// **'تلاش‌های در حال اجرا تمام می‌شوند ولی تلاش تازه‌ای شروع نمی‌شود تا ادامه دهید. ادامه می‌دهید؟'**
  String get qPauseConfirm;

  /// No description provided for @qProgress.
  ///
  /// In fa, this message translates to:
  /// **'پیشرفت'**
  String get qProgress;

  /// No description provided for @qAttempts.
  ///
  /// In fa, this message translates to:
  /// **'تلاش'**
  String get qAttempts;

  /// No description provided for @qRemaining.
  ///
  /// In fa, this message translates to:
  /// **'زمان باقی‌مانده تخمینی'**
  String get qRemaining;

  /// No description provided for @qAllRecorded.
  ///
  /// In fa, this message translates to:
  /// **'همه تلاش‌ها، حتی شکست‌خورده و لغوشده، ثبت و شمرده می‌شوند.'**
  String get qAllRecorded;

  /// No description provided for @qBudgetAttempts.
  ///
  /// In fa, this message translates to:
  /// **'تلاش‌ها از بودجه'**
  String get qBudgetAttempts;

  /// No description provided for @qBudgetTime.
  ///
  /// In fa, this message translates to:
  /// **'زمان مصرف‌شده'**
  String get qBudgetTime;

  /// No description provided for @qBudgetCpu.
  ///
  /// In fa, this message translates to:
  /// **'سهم CPU پژوهش'**
  String get qBudgetCpu;

  /// No description provided for @qCacheRate.
  ///
  /// In fa, this message translates to:
  /// **'نرخ استفاده از کش'**
  String get qCacheRate;

  /// No description provided for @qBest.
  ///
  /// In fa, this message translates to:
  /// **'بهترین نتیجه واجد شرایط تا اینجا'**
  String get qBest;

  /// No description provided for @qTabAll.
  ///
  /// In fa, this message translates to:
  /// **'همه'**
  String get qTabAll;

  /// No description provided for @qColParams.
  ///
  /// In fa, this message translates to:
  /// **'پارامترها'**
  String get qColParams;

  /// No description provided for @qColPair.
  ///
  /// In fa, this message translates to:
  /// **'جفت'**
  String get qColPair;

  /// No description provided for @qColReturn.
  ///
  /// In fa, this message translates to:
  /// **'بازده خالص'**
  String get qColReturn;

  /// No description provided for @qColDd.
  ///
  /// In fa, this message translates to:
  /// **'بیشینه افت'**
  String get qColDd;

  /// No description provided for @qColTrades.
  ///
  /// In fa, this message translates to:
  /// **'معاملات'**
  String get qColTrades;

  /// No description provided for @qColConstraints.
  ///
  /// In fa, this message translates to:
  /// **'محدودیت‌ها'**
  String get qColConstraints;

  /// No description provided for @qColCache.
  ///
  /// In fa, this message translates to:
  /// **'کش'**
  String get qColCache;

  /// No description provided for @qEligible.
  ///
  /// In fa, this message translates to:
  /// **'واجد شرایط'**
  String get qEligible;

  /// No description provided for @qRejected.
  ///
  /// In fa, this message translates to:
  /// **'رد: {why}'**
  String qRejected(String why);

  /// No description provided for @qRuns.
  ///
  /// In fa, this message translates to:
  /// **'{n} بار اجرا'**
  String qRuns(int n);

  /// No description provided for @qResult.
  ///
  /// In fa, this message translates to:
  /// **'نتیجه'**
  String get qResult;

  /// No description provided for @qChosen.
  ///
  /// In fa, this message translates to:
  /// **'نامزد برگزیده #{n}'**
  String qChosen(int n);

  /// No description provided for @qChosenNote.
  ///
  /// In fa, this message translates to:
  /// **'از {eligible} نامزد واجد شرایط در میان {cands} نامزد و {attempts} تلاش انتخاب شد؛ بخشی از برتری آن ممکن است شانسی باشد.'**
  String qChosenNote(int eligible, int cands, int attempts);

  /// No description provided for @qOpenReport.
  ///
  /// In fa, this message translates to:
  /// **'گزارش کامل نامزد برگزیده'**
  String get qOpenReport;

  /// No description provided for @qNone.
  ///
  /// In fa, this message translates to:
  /// **'نامزد واجد شرایطی نبود'**
  String get qNone;

  /// No description provided for @qEmpty.
  ///
  /// In fa, this message translates to:
  /// **'تلاشی در این دسته نیست.'**
  String get qEmpty;

  /// No description provided for @qNotFound.
  ///
  /// In fa, this message translates to:
  /// **'این آزمایش پیدا نشد.'**
  String get qNotFound;

  /// No description provided for @libExperiment.
  ///
  /// In fa, this message translates to:
  /// **'آزمایش با نسخه انتخابی'**
  String get libExperiment;

  /// No description provided for @libLatest.
  ///
  /// In fa, this message translates to:
  /// **'آخرین ارزیابی'**
  String get libLatest;

  /// No description provided for @libNone.
  ///
  /// In fa, this message translates to:
  /// **'—'**
  String get libNone;

  /// No description provided for @libSelected.
  ///
  /// In fa, this message translates to:
  /// **'الگوریتم انتخاب‌شده'**
  String get libSelected;

  /// No description provided for @libRecipe.
  ///
  /// In fa, this message translates to:
  /// **'دستور ساخت (نسخه جاری)'**
  String get libRecipe;

  /// No description provided for @libVersions.
  ///
  /// In fa, this message translates to:
  /// **'تاریخچه نسخه‌ها'**
  String get libVersions;

  /// No description provided for @libLockNote.
  ///
  /// In fa, this message translates to:
  /// **'قواعد و پارامترهای نسخه فعال قفل‌اند. هر تغییر در قواعد یا پارامترها نسخه تازه می‌سازد.'**
  String get libLockNote;

  /// No description provided for @libMoveTo.
  ///
  /// In fa, this message translates to:
  /// **'انتقال به «{state}»'**
  String libMoveTo(String state);

  /// No description provided for @libConfirm.
  ///
  /// In fa, this message translates to:
  /// **'وضعیت {version} از «{from}» به «{to}» تغییر می‌کند و این تصمیم ثبت می‌شود.'**
  String libConfirm(String version, String from, String to);

  /// No description provided for @libConfirmActive.
  ///
  /// In fa, this message translates to:
  /// **' اگر نسخه فعال دیگری از همین الگوریتم باشد، متوقف می‌شود.'**
  String get libConfirmActive;

  /// No description provided for @libNote.
  ///
  /// In fa, this message translates to:
  /// **'یادداشت (چرا؟)'**
  String get libNote;

  /// No description provided for @libHistory.
  ///
  /// In fa, this message translates to:
  /// **'رویدادها'**
  String get libHistory;

  /// No description provided for @actorUser.
  ///
  /// In fa, this message translates to:
  /// **'کاربر'**
  String get actorUser;

  /// No description provided for @actorSystem.
  ///
  /// In fa, this message translates to:
  /// **'سیستم'**
  String get actorSystem;

  /// No description provided for @lSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'بازآموزی روزانه {hour} UTC · حداقل داده تازه {bars} کندل · ارتقا فقط با تأیید شما'**
  String lSubtitle(String hour, int bars);

  /// No description provided for @lSubtitleOff.
  ///
  /// In fa, this message translates to:
  /// **'بازآموزی خودکار خاموش است؛ چرخه را دستی اجرا کنید · ارتقا فقط با تأیید شما'**
  String get lSubtitleOff;

  /// No description provided for @lConfig.
  ///
  /// In fa, this message translates to:
  /// **'تنظیم زمان‌بندی و بودجه'**
  String get lConfig;

  /// No description provided for @lRunNow.
  ///
  /// In fa, this message translates to:
  /// **'اجرای چرخه اکنون'**
  String get lRunNow;

  /// No description provided for @lStarted.
  ///
  /// In fa, this message translates to:
  /// **'چرخه #{id} شروع شد.'**
  String lStarted(int id);

  /// No description provided for @lCurrent.
  ///
  /// In fa, this message translates to:
  /// **'چرخه جاری'**
  String get lCurrent;

  /// No description provided for @lStage.
  ///
  /// In fa, this message translates to:
  /// **'مرحله: {stage}'**
  String lStage(String stage);

  /// No description provided for @lForwardDay.
  ///
  /// In fa, this message translates to:
  /// **'روز {d} از {n}'**
  String lForwardDay(int d, int n);

  /// No description provided for @ls_collect.
  ///
  /// In fa, this message translates to:
  /// **'گردآوری داده'**
  String get ls_collect;

  /// No description provided for @ls_labels.
  ///
  /// In fa, this message translates to:
  /// **'برچسب‌های آماده'**
  String get ls_labels;

  /// No description provided for @ls_generate.
  ///
  /// In fa, this message translates to:
  /// **'ساخت نامزد'**
  String get ls_generate;

  /// No description provided for @ls_train.
  ///
  /// In fa, this message translates to:
  /// **'آموزش'**
  String get ls_train;

  /// No description provided for @ls_walk_forward.
  ///
  /// In fa, this message translates to:
  /// **'ارزیابی گام‌به‌گام'**
  String get ls_walk_forward;

  /// No description provided for @ls_forward_test.
  ///
  /// In fa, this message translates to:
  /// **'آزمون پیشرو'**
  String get ls_forward_test;

  /// No description provided for @ls_decision.
  ///
  /// In fa, this message translates to:
  /// **'تصمیم ارتقا'**
  String get ls_decision;

  /// No description provided for @lst_done.
  ///
  /// In fa, this message translates to:
  /// **'انجام شد'**
  String get lst_done;

  /// No description provided for @lst_running.
  ///
  /// In fa, this message translates to:
  /// **'در جریان'**
  String get lst_running;

  /// No description provided for @lst_waiting.
  ///
  /// In fa, this message translates to:
  /// **'در جریان'**
  String get lst_waiting;

  /// No description provided for @lst_waiting_you.
  ///
  /// In fa, this message translates to:
  /// **'منتظر شما'**
  String get lst_waiting_you;

  /// No description provided for @lst_pending.
  ///
  /// In fa, this message translates to:
  /// **'منتظر'**
  String get lst_pending;

  /// No description provided for @lst_skipped.
  ///
  /// In fa, this message translates to:
  /// **'انجام نشد'**
  String get lst_skipped;

  /// No description provided for @lo_skipped.
  ///
  /// In fa, this message translates to:
  /// **'پرش'**
  String get lo_skipped;

  /// No description provided for @lo_failed.
  ///
  /// In fa, this message translates to:
  /// **'شکست'**
  String get lo_failed;

  /// No description provided for @lo_not_better.
  ///
  /// In fa, this message translates to:
  /// **'نامزد بهتر نیست'**
  String get lo_not_better;

  /// No description provided for @lo_gate_failed.
  ///
  /// In fa, this message translates to:
  /// **'رد در دروازه'**
  String get lo_gate_failed;

  /// No description provided for @lo_recommended.
  ///
  /// In fa, this message translates to:
  /// **'پیشنهاد ارتقا · منتظر تأیید شما'**
  String get lo_recommended;

  /// No description provided for @lo_approved.
  ///
  /// In fa, this message translates to:
  /// **'ارتقا با تأیید شما'**
  String get lo_approved;

  /// No description provided for @lo_rejected.
  ///
  /// In fa, this message translates to:
  /// **'رد با تصمیم شما'**
  String get lo_rejected;

  /// No description provided for @lo_running.
  ///
  /// In fa, this message translates to:
  /// **'در جریان'**
  String get lo_running;

  /// No description provided for @lChampion.
  ///
  /// In fa, this message translates to:
  /// **'قهرمان (نسخه فعال)'**
  String get lChampion;

  /// No description provided for @lChampionBaseline.
  ///
  /// In fa, this message translates to:
  /// **'قهرمان (نسخه پایه، بی‌مدل فعال)'**
  String get lChampionBaseline;

  /// No description provided for @lChallenger.
  ///
  /// In fa, this message translates to:
  /// **'رقیب'**
  String get lChallenger;

  /// No description provided for @lModelSince.
  ///
  /// In fa, this message translates to:
  /// **'مدل {id} · آموزش تا {date}'**
  String lModelSince(String id, String date);

  /// No description provided for @lBaselineDesc.
  ///
  /// In fa, this message translates to:
  /// **'هنوز مدل فعالی نیست؛ دستور همین نسخه در لحظه انجماد آموزش دید.'**
  String get lBaselineDesc;

  /// No description provided for @lChange.
  ///
  /// In fa, this message translates to:
  /// **'تغییر: {change} · نامزد #{seq}'**
  String lChange(String change, int seq);

  /// No description provided for @lFwdReturn.
  ///
  /// In fa, this message translates to:
  /// **'بازده خالص پیشرو'**
  String get lFwdReturn;

  /// No description provided for @lWalkReturn.
  ///
  /// In fa, this message translates to:
  /// **'بازده گام‌به‌گام'**
  String get lWalkReturn;

  /// No description provided for @lMaxDd.
  ///
  /// In fa, this message translates to:
  /// **'بیشینه افت'**
  String get lMaxDd;

  /// No description provided for @lTrades.
  ///
  /// In fa, this message translates to:
  /// **'معاملات'**
  String get lTrades;

  /// No description provided for @lFees.
  ///
  /// In fa, this message translates to:
  /// **'هزینه'**
  String get lFees;

  /// No description provided for @lNoChallenger.
  ///
  /// In fa, this message translates to:
  /// **'هنوز رقیبی انتخاب نشده.'**
  String get lNoChallenger;

  /// No description provided for @lGate.
  ///
  /// In fa, this message translates to:
  /// **'دروازه ارتقا (ازپیش‌ثبت‌شده)'**
  String get lGate;

  /// No description provided for @gPass.
  ///
  /// In fa, this message translates to:
  /// **'قبول'**
  String get gPass;

  /// No description provided for @gFail.
  ///
  /// In fa, this message translates to:
  /// **'رد'**
  String get gFail;

  /// No description provided for @gPending.
  ///
  /// In fa, this message translates to:
  /// **'در انتظار'**
  String get gPending;

  /// No description provided for @lGateEmpty.
  ///
  /// In fa, this message translates to:
  /// **'دروازه پس از ارزیابی گام‌به‌گام سنجیده می‌شود.'**
  String get lGateEmpty;

  /// No description provided for @lApprove.
  ///
  /// In fa, this message translates to:
  /// **'تأیید ارتقا (پس از دروازه)'**
  String get lApprove;

  /// No description provided for @lReject.
  ///
  /// In fa, this message translates to:
  /// **'رد نامزد'**
  String get lReject;

  /// No description provided for @lApproveConfirm.
  ///
  /// In fa, this message translates to:
  /// **'نسخه فعال «{from}» کنار می‌رود و دستور رقیب (تغییر «{change}») با مدل {model} نسخه فعال می‌شود. جفت فعلی برای بازگشت نگه داشته می‌شود.'**
  String lApproveConfirm(String from, String change, String model);

  /// No description provided for @lRejectConfirm.
  ///
  /// In fa, this message translates to:
  /// **'رقیب کنار گذاشته می‌شود و نسخه و مدل فعال هیچ تغییری نمی‌کنند.'**
  String get lRejectConfirm;

  /// No description provided for @lNone.
  ///
  /// In fa, this message translates to:
  /// **'هیچ'**
  String get lNone;

  /// No description provided for @lHistory.
  ///
  /// In fa, this message translates to:
  /// **'تاریخچه چرخه‌ها'**
  String get lHistory;

  /// No description provided for @hCycle.
  ///
  /// In fa, this message translates to:
  /// **'چرخه'**
  String get hCycle;

  /// No description provided for @hTrigger.
  ///
  /// In fa, this message translates to:
  /// **'محرک'**
  String get hTrigger;

  /// No description provided for @hCands.
  ///
  /// In fa, this message translates to:
  /// **'نامزدها'**
  String get hCands;

  /// No description provided for @hBest.
  ///
  /// In fa, this message translates to:
  /// **'بهترین رقیب (پیشرو)'**
  String get hBest;

  /// No description provided for @hDecision.
  ///
  /// In fa, this message translates to:
  /// **'تصمیم'**
  String get hDecision;

  /// No description provided for @trig_schedule.
  ///
  /// In fa, this message translates to:
  /// **'زمان‌بندی'**
  String get trig_schedule;

  /// No description provided for @trig_manual.
  ///
  /// In fa, this message translates to:
  /// **'دستی'**
  String get trig_manual;

  /// No description provided for @lHistoryNote.
  ///
  /// In fa, this message translates to:
  /// **'پایان چرخه با «نامزد بهتر نیست» خروجی عادی است. داده پیشرویی که در تصمیم استفاده شده، در چرخه بعد فقط داده آموزش است.'**
  String get lHistoryNote;

  /// No description provided for @lHistoryEmpty.
  ///
  /// In fa, this message translates to:
  /// **'هنوز چرخه‌ای اجرا نشده. «اجرای چرخه اکنون» را بزنید.'**
  String get lHistoryEmpty;

  /// No description provided for @lModels.
  ///
  /// In fa, this message translates to:
  /// **'ثبت مدل‌ها'**
  String get lModels;

  /// No description provided for @ms_active.
  ///
  /// In fa, this message translates to:
  /// **'فعال'**
  String get ms_active;

  /// No description provided for @ms_challenger.
  ///
  /// In fa, this message translates to:
  /// **'رقیب'**
  String get ms_challenger;

  /// No description provided for @ms_baseline.
  ///
  /// In fa, this message translates to:
  /// **'پایه'**
  String get ms_baseline;

  /// No description provided for @ms_archived.
  ///
  /// In fa, this message translates to:
  /// **'بایگانی'**
  String get ms_archived;

  /// No description provided for @lModelsEmpty.
  ///
  /// In fa, this message translates to:
  /// **'هنوز مدلی ذخیره نشده.'**
  String get lModelsEmpty;

  /// No description provided for @lRollback.
  ///
  /// In fa, this message translates to:
  /// **'بازگشت به مدل پیشین'**
  String get lRollback;

  /// No description provided for @lRollbackConfirm.
  ///
  /// In fa, this message translates to:
  /// **'نسخه و مدل فعال به جفت پیش از آخرین ارتقا برمی‌گردند. این تصمیم ثبت می‌شود.'**
  String get lRollbackConfirm;

  /// No description provided for @lBudget.
  ///
  /// In fa, this message translates to:
  /// **'بودجه چرخه'**
  String get lBudget;

  /// No description provided for @bCpu.
  ///
  /// In fa, this message translates to:
  /// **'CPU'**
  String get bCpu;

  /// No description provided for @bBars.
  ///
  /// In fa, this message translates to:
  /// **'کندل‌ها (حافظه)'**
  String get bBars;

  /// No description provided for @bCands.
  ///
  /// In fa, this message translates to:
  /// **'نامزدها'**
  String get bCands;

  /// No description provided for @lCandidates.
  ///
  /// In fa, this message translates to:
  /// **'همه نامزدهای این چرخه ({n})'**
  String lCandidates(int n);

  /// No description provided for @cChange.
  ///
  /// In fa, this message translates to:
  /// **'تغییر'**
  String get cChange;

  /// No description provided for @cWins.
  ///
  /// In fa, this message translates to:
  /// **'برد در گام‌ها'**
  String get cWins;

  /// No description provided for @lcAlgorithm.
  ///
  /// In fa, this message translates to:
  /// **'الگوریتم'**
  String get lcAlgorithm;

  /// No description provided for @lcEnabled.
  ///
  /// In fa, this message translates to:
  /// **'اجرای خودکار روزانه'**
  String get lcEnabled;

  /// No description provided for @lcHour.
  ///
  /// In fa, this message translates to:
  /// **'ساعت شروع (UTC)'**
  String get lcHour;

  /// No description provided for @lcLookback.
  ///
  /// In fa, this message translates to:
  /// **'بازه داده (روز)'**
  String get lcLookback;

  /// No description provided for @lcFresh.
  ///
  /// In fa, this message translates to:
  /// **'حداقل کندل تازه'**
  String get lcFresh;

  /// No description provided for @lcFolds.
  ///
  /// In fa, this message translates to:
  /// **'گام‌های ارزیابی'**
  String get lcFolds;

  /// No description provided for @lcCands.
  ///
  /// In fa, this message translates to:
  /// **'سقف نامزدها'**
  String get lcCands;

  /// No description provided for @lcCpu.
  ///
  /// In fa, this message translates to:
  /// **'بودجه CPU (دقیقه)'**
  String get lcCpu;

  /// No description provided for @lcBars.
  ///
  /// In fa, this message translates to:
  /// **'سقف کندل‌ها'**
  String get lcBars;

  /// No description provided for @lcGate.
  ///
  /// In fa, this message translates to:
  /// **'دروازه — پیش از هر چرخه ثبت و قفل می‌شود'**
  String get lcGate;

  /// No description provided for @lcMaxDd.
  ///
  /// In fa, this message translates to:
  /// **'سقف افت سرمایه'**
  String get lcMaxDd;

  /// No description provided for @lcTrades.
  ///
  /// In fa, this message translates to:
  /// **'حداقل معامله پیشرو'**
  String get lcTrades;

  /// No description provided for @lcFwdDays.
  ///
  /// In fa, this message translates to:
  /// **'طول آزمون پیشرو (روز)'**
  String get lcFwdDays;

  /// No description provided for @lcImprove.
  ///
  /// In fa, this message translates to:
  /// **'حداقل بهبود بازده'**
  String get lcImprove;

  /// No description provided for @lcDdDeg.
  ///
  /// In fa, this message translates to:
  /// **'حداکثر بدتر شدن افت'**
  String get lcDdDeg;

  /// No description provided for @lcWins.
  ///
  /// In fa, this message translates to:
  /// **'حداقل برد در گام‌ها'**
  String get lcWins;

  /// No description provided for @lcPoints.
  ///
  /// In fa, this message translates to:
  /// **'واحد درصد'**
  String get lcPoints;

  /// No description provided for @lcSaved.
  ///
  /// In fa, this message translates to:
  /// **'تنظیمات ذخیره شد؛ از چرخه بعد اعمال می‌شود.'**
  String get lcSaved;

  /// No description provided for @save.
  ///
  /// In fa, this message translates to:
  /// **'ذخیره'**
  String get save;

  /// No description provided for @libLearningNote.
  ///
  /// In fa, this message translates to:
  /// **'الگوریتم یادگیرنده: در چرخه یادگیری آموزش و آزموده می‌شود، نه در آزمایش.'**
  String get libLearningNote;

  /// No description provided for @libActiveModel.
  ///
  /// In fa, this message translates to:
  /// **'مدل فعال'**
  String get libActiveModel;

  /// No description provided for @chartSub.
  ///
  /// In fa, this message translates to:
  /// **'اجرای «{title}» روی {pair} · اندیکاتورها از موتور Go'**
  String chartSub(String title, String pair);

  /// No description provided for @chartSubLive.
  ///
  /// In fa, this message translates to:
  /// **'{pair} · داده خام · اندیکاتورها از موتور Go'**
  String chartSubLive(String pair);

  /// No description provided for @chartSource.
  ///
  /// In fa, this message translates to:
  /// **'لایه اجرا'**
  String get chartSource;

  /// No description provided for @chartNoSource.
  ///
  /// In fa, this message translates to:
  /// **'بدون لایه (داده خام)'**
  String get chartNoSource;

  /// No description provided for @chartPair.
  ///
  /// In fa, this message translates to:
  /// **'جفت'**
  String get chartPair;

  /// No description provided for @chartTimeframe.
  ///
  /// In fa, this message translates to:
  /// **'بازه'**
  String get chartTimeframe;

  /// No description provided for @chartIndicators.
  ///
  /// In fa, this message translates to:
  /// **'اندیکاتورها'**
  String get chartIndicators;

  /// No description provided for @chartStrategyLines.
  ///
  /// In fa, this message translates to:
  /// **'خطوط خود راهبرد'**
  String get chartStrategyLines;

  /// No description provided for @chartBarsCut.
  ///
  /// In fa, this message translates to:
  /// **'{n} کندل آخر از {total}'**
  String chartBarsCut(int n, int total);

  /// No description provided for @chartEmpty.
  ///
  /// In fa, this message translates to:
  /// **'برای این جفت و بازه کندلی نیست؛ از صفحه داده وارد کنید.'**
  String get chartEmpty;

  /// No description provided for @chartDecision.
  ///
  /// In fa, this message translates to:
  /// **'تصمیم انتخاب‌شده'**
  String get chartDecision;

  /// No description provided for @chartPick.
  ///
  /// In fa, this message translates to:
  /// **'روی یک نشانگر در نمودار بزنید یا با دکمه‌ها بین تصمیم‌ها جابه‌جا شوید.'**
  String get chartPick;

  /// No description provided for @chartNoMarks.
  ///
  /// In fa, this message translates to:
  /// **'این لایه روی این جفت تصمیمی ندارد.'**
  String get chartNoMarks;

  /// No description provided for @chartPrev.
  ///
  /// In fa, this message translates to:
  /// **'تصمیم قبلی'**
  String get chartPrev;

  /// No description provided for @chartNext.
  ///
  /// In fa, this message translates to:
  /// **'تصمیم بعدی'**
  String get chartNext;

  /// No description provided for @chartMarkOf.
  ///
  /// In fa, this message translates to:
  /// **'{i} از {n}'**
  String chartMarkOf(int i, int n);

  /// No description provided for @chartReplay.
  ///
  /// In fa, this message translates to:
  /// **'بازپخش کندل‌به‌کندل (فاز بعد)'**
  String get chartReplay;

  /// No description provided for @chartBack.
  ///
  /// In fa, this message translates to:
  /// **'بازگشت به گزارش'**
  String get chartBack;

  /// No description provided for @mk_entry.
  ///
  /// In fa, this message translates to:
  /// **'ورود خرید'**
  String get mk_entry;

  /// No description provided for @mk_exit.
  ///
  /// In fa, this message translates to:
  /// **'خروج'**
  String get mk_exit;

  /// No description provided for @mk_rejected.
  ///
  /// In fa, this message translates to:
  /// **'سیگنال ردشده'**
  String get mk_rejected;

  /// No description provided for @dTime.
  ///
  /// In fa, this message translates to:
  /// **'زمان تصمیم'**
  String get dTime;

  /// No description provided for @dRef.
  ///
  /// In fa, this message translates to:
  /// **'قیمت مرجع'**
  String get dRef;

  /// No description provided for @dOutcome.
  ///
  /// In fa, this message translates to:
  /// **'نتیجه'**
  String get dOutcome;

  /// No description provided for @dTarget.
  ///
  /// In fa, this message translates to:
  /// **'هدف موقعیت'**
  String get dTarget;

  /// No description provided for @dModel.
  ///
  /// In fa, this message translates to:
  /// **'مدل'**
  String get dModel;

  /// No description provided for @dRecipe.
  ///
  /// In fa, this message translates to:
  /// **'نسخه دستور'**
  String get dRecipe;

  /// No description provided for @dDetail.
  ///
  /// In fa, this message translates to:
  /// **'جزئیات'**
  String get dDetail;

  /// No description provided for @oc_filled.
  ///
  /// In fa, this message translates to:
  /// **'اجرا شد'**
  String get oc_filled;

  /// No description provided for @oc_rejected.
  ///
  /// In fa, this message translates to:
  /// **'رد شد'**
  String get oc_rejected;

  /// No description provided for @oc_expired.
  ///
  /// In fa, this message translates to:
  /// **'منقضی شد'**
  String get oc_expired;

  /// No description provided for @reportOnChart.
  ///
  /// In fa, this message translates to:
  /// **'نمایش روی نمودار'**
  String get reportOnChart;

  /// No description provided for @homeImport.
  ///
  /// In fa, this message translates to:
  /// **'واردسازی داده'**
  String get homeImport;

  /// No description provided for @homeNewExperiment.
  ///
  /// In fa, this message translates to:
  /// **'آزمایش تازه'**
  String get homeNewExperiment;

  /// No description provided for @homeChampion.
  ///
  /// In fa, this message translates to:
  /// **'نسخه فعال (قهرمان)'**
  String get homeChampion;

  /// No description provided for @homeChampionNone.
  ///
  /// In fa, this message translates to:
  /// **'هنوز نسخه فعالی نیست'**
  String get homeChampionNone;

  /// No description provided for @homeChampionModel.
  ///
  /// In fa, this message translates to:
  /// **'مدل {id} · آموزش تا {date}'**
  String homeChampionModel(String id, String date);

  /// No description provided for @homeChampionNoModel.
  ///
  /// In fa, this message translates to:
  /// **'مدل فعالی ثبت نشده'**
  String get homeChampionNoModel;

  /// No description provided for @homeNextCycle.
  ///
  /// In fa, this message translates to:
  /// **'چرخه بعدی بازآموزی'**
  String get homeNextCycle;

  /// No description provided for @homeScheduleOff.
  ///
  /// In fa, this message translates to:
  /// **'خاموش'**
  String get homeScheduleOff;

  /// No description provided for @homeFresh.
  ///
  /// In fa, this message translates to:
  /// **'حداقل داده تازه: {n} کندل'**
  String homeFresh(int n);

  /// No description provided for @homeQueue.
  ///
  /// In fa, this message translates to:
  /// **'صف اجرا'**
  String get homeQueue;

  /// No description provided for @homeQueueValue.
  ///
  /// In fa, this message translates to:
  /// **'{running} در حال اجرا · {queued} در صف'**
  String homeQueueValue(int running, int queued);

  /// No description provided for @homeQueueSub.
  ///
  /// In fa, this message translates to:
  /// **'{n} آزمایش باز'**
  String homeQueueSub(int n);

  /// No description provided for @homeData.
  ///
  /// In fa, this message translates to:
  /// **'سلامت داده'**
  String get homeData;

  /// No description provided for @homeDataValue.
  ///
  /// In fa, this message translates to:
  /// **'{pairs} جفت · {issues} هشدار'**
  String homeDataValue(int pairs, int issues);

  /// No description provided for @homeDataLive.
  ///
  /// In fa, this message translates to:
  /// **'آخرین کندل زنده: {s} ثانیه پیش'**
  String homeDataLive(int s);

  /// No description provided for @homeDataOff.
  ///
  /// In fa, this message translates to:
  /// **'داده زنده خاموش است'**
  String get homeDataOff;

  /// No description provided for @homeLastCycle.
  ///
  /// In fa, this message translates to:
  /// **'آخرین چرخه یادگیری'**
  String get homeLastCycle;

  /// No description provided for @homeCycleMeta.
  ///
  /// In fa, this message translates to:
  /// **'چرخه #{id} · محرک: {trigger} · {date}'**
  String homeCycleMeta(int id, String trigger, String date);

  /// No description provided for @homeCycleDetails.
  ///
  /// In fa, this message translates to:
  /// **'جزئیات چرخه'**
  String get homeCycleDetails;

  /// No description provided for @homeCycleCands.
  ///
  /// In fa, this message translates to:
  /// **'{n} نامزد'**
  String homeCycleCands(int n);

  /// No description provided for @homeNoCycle.
  ///
  /// In fa, this message translates to:
  /// **'هنوز چرخه یادگیری اجرا نشده.'**
  String get homeNoCycle;

  /// No description provided for @homeRecent.
  ///
  /// In fa, this message translates to:
  /// **'آزمایش‌های اخیر'**
  String get homeRecent;

  /// No description provided for @homeAllExperiments.
  ///
  /// In fa, this message translates to:
  /// **'همه آزمایش‌ها'**
  String get homeAllExperiments;

  /// No description provided for @homeNoExperiments.
  ///
  /// In fa, this message translates to:
  /// **'هنوز آزمایشی ندارید.'**
  String get homeNoExperiments;

  /// No description provided for @homeAlerts.
  ///
  /// In fa, this message translates to:
  /// **'هشدارها'**
  String get homeAlerts;

  /// No description provided for @homeNoAlerts.
  ///
  /// In fa, this message translates to:
  /// **'هشداری نیست.'**
  String get homeNoAlerts;

  /// No description provided for @alertData.
  ///
  /// In fa, this message translates to:
  /// **'کیفیت داده'**
  String get alertData;

  /// No description provided for @alertHoldout.
  ///
  /// In fa, this message translates to:
  /// **'اعتبار آزمایش'**
  String get alertHoldout;

  /// No description provided for @alertHoldoutText.
  ///
  /// In fa, this message translates to:
  /// **'آزمون نهایی «{title}» {n} بار دیده شده است؛ دیگر دست‌نخورده نیست.'**
  String alertHoldoutText(String title, int n);

  /// No description provided for @alertEngine.
  ///
  /// In fa, this message translates to:
  /// **'موتور'**
  String get alertEngine;

  /// No description provided for @lcHelpHour.
  ///
  /// In fa, this message translates to:
  /// **'چرخه روزانه پس از این ساعت (به وقت UTC) شروع می‌شود.'**
  String get lcHelpHour;

  /// No description provided for @lcHelpLookback.
  ///
  /// In fa, this message translates to:
  /// **'بازه داده‌ای که هر چرخه برای آموزش و ارزیابی می‌خواند.'**
  String get lcHelpLookback;

  /// No description provided for @lcHelpFresh.
  ///
  /// In fa, this message translates to:
  /// **'اگر پس از آخرین تصمیم این تعداد کندل تازه نیامده باشد، چرخه با دلیلِ ثبت‌شده رد می‌شود.'**
  String get lcHelpFresh;

  /// No description provided for @lcHelpFolds.
  ///
  /// In fa, this message translates to:
  /// **'تعداد گام‌های ارزیابی گام‌به‌گام؛ هر گام با گذشته خودش آموزش می‌بیند.'**
  String get lcHelpFolds;

  /// No description provided for @lcHelpCands.
  ///
  /// In fa, this message translates to:
  /// **'بیشینه نامزدهایی که هر چرخه می‌سازد؛ همه ثبت می‌شوند.'**
  String get lcHelpCands;

  /// No description provided for @lcHelpCpu.
  ///
  /// In fa, this message translates to:
  /// **'زمان پژوهش مجاز هر چرخه؛ نامزدهای بیرون از بودجه «لغو» ثبت می‌شوند.'**
  String get lcHelpCpu;

  /// No description provided for @lcHelpBars.
  ///
  /// In fa, this message translates to:
  /// **'سقف حافظه: بیشینه کندل‌هایی که یک چرخه بار می‌کند.'**
  String get lcHelpBars;

  /// No description provided for @lcHelpMaxDd.
  ///
  /// In fa, this message translates to:
  /// **'رقیبی که در ارزیابی یا آزمون پیشرو بیش از این افت کند، رد می‌شود.'**
  String get lcHelpMaxDd;

  /// No description provided for @lcHelpTrades.
  ///
  /// In fa, this message translates to:
  /// **'با معاملات کمتر، نتیجه پیشرو قابل اتکا نیست.'**
  String get lcHelpTrades;

  /// No description provided for @lcHelpFwd.
  ///
  /// In fa, this message translates to:
  /// **'مدت آزمون رقیب روی داده تازه، کنار قهرمان، پیش از هر تصمیم.'**
  String get lcHelpFwd;

  /// No description provided for @lcHelpImprove.
  ///
  /// In fa, this message translates to:
  /// **'رقیب باید در دوره پیشرو دست‌کم این مقدار بازده بیشتری از قهرمان بسازد.'**
  String get lcHelpImprove;

  /// No description provided for @lcHelpDdDeg.
  ///
  /// In fa, this message translates to:
  /// **'افت سرمایه رقیب حداکثر این مقدار بیشتر از قهرمان.'**
  String get lcHelpDdDeg;

  /// No description provided for @lcHelpWins.
  ///
  /// In fa, this message translates to:
  /// **'در دست‌کم این تعداد گام ارزیابی، سود رقیب از قهرمان بیشتر باشد.'**
  String get lcHelpWins;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'fa':
      return L10nFa();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
