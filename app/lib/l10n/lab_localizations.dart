import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart' as flutter;
import 'package:material_ui/material_ui.dart' as material;

import 'app_localizations.dart';

// The extracted UI libraries and Flutter-based dependencies use distinct locale types.
const labLocalizationDelegates = <LocalizationsDelegate<dynamic>>[
  L10n.delegate,
  ...material.GlobalMaterialLocalizations.delegates,
  flutter.GlobalMaterialLocalizations.delegate,
  flutter.GlobalCupertinoLocalizations.delegate,
];
