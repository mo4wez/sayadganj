// ignore_for_file: depend_on_referenced_packages
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart';

class BalochiMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const BalochiMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'bal';

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    return GlobalMaterialLocalizations.delegate.load(const Locale('fa'));
  }

  @override
  bool shouldReload(BalochiMaterialLocalizationsDelegate old) => false;
}

class BalochiCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const BalochiCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'bal';

  @override
  Future<CupertinoLocalizations> load(Locale locale) {
    return GlobalCupertinoLocalizations.delegate.load(const Locale('fa'));
  }

  @override
  bool shouldReload(BalochiCupertinoLocalizationsDelegate old) => false;
}

class BalochiWidgetsLocalizationsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const BalochiWidgetsLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'bal';

  @override
  Future<WidgetsLocalizations> load(Locale locale) {
    return SynchronousFuture<WidgetsLocalizations>(
      _BalochiWidgetsLocalizations(),
    );
  }

  @override
  bool shouldReload(BalochiWidgetsLocalizationsDelegate old) => false;
}

class _BalochiWidgetsLocalizations extends DefaultWidgetsLocalizations {
  @override
  TextDirection get textDirection => TextDirection.rtl;
}
