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
