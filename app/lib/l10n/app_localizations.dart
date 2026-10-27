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

  /// No description provided for @comingIn.
  ///
  /// In fa, this message translates to:
  /// **'این صفحه در مرحله {milestone} ساخته می‌شود.'**
  String comingIn(String milestone);

  /// No description provided for @comingInHint.
  ///
  /// In fa, this message translates to:
  /// **'تا آن زمان، ساختار و مسیر آن آماده است.'**
  String get comingInHint;

  /// No description provided for @chartSpikeTitle.
  ///
  /// In fa, this message translates to:
  /// **'آزمون نمودار (M0)'**
  String get chartSpikeTitle;

  /// No description provided for @chartSpikeHint.
  ///
  /// In fa, this message translates to:
  /// **'شمع‌های نمونه و ثابت. اشاره‌گر را روی نمودار حرکت دهید و اندازه پنجره را تغییر دهید.'**
  String get chartSpikeHint;

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
