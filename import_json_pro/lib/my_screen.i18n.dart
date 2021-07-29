import 'package:i18n_extension/i18n_extension.dart';
import 'package:i18n_extension/io/import.dart';

// Developed by Marcelo Glasberg (Aug 2019).
// For more info, see: https://pub.dartlang.org/packages/i18n_extension

class MyI18n {
  static TranslationsByLocale _t = Translations.byLocale("zh_ch");

  // static _t = Translations("zh_ch") +
  //     {
  //       "zh_ch": "Increment",
  //       "en_us": "Incrementar",
  //     } +
  //     {
  //       "zh_ch": "Change Language",
  //       "en_us": "Mude Idioma",
  //     } +
  //     {
  //       "zh_ch": "You clicked the button %d times:"
  //           .zero("You haven't clicked the button:")
  //           .one("You clicked it once:")
  //           .two("You clicked a couple times:")
  //           .many("You clicked %d times:")
  //           .times(12, "You clicked a dozen times:"),
  //       "en_us": "Você clicou o botão %d vezes:"
  //           .zero("Você não clicou no botão:")
  //           .one("Você clicou uma única vez:")
  //           .two("Você clicou um par de vezes:")
  //           .many("Você clicou %d vezes:")
  //           .times(12, "Você clicou uma dúzia de vezes:"),
  //     };

  static Future<void> loadTranslations() async {
    _t += await JSONImporter().fromAssetDirectory("assets/locales");
  }
}


extension Localization on String {

  String get i18n => localize(this, MyI18n._t);
  String plural(int value) => localizePlural(value, this, MyI18n._t);
  String fill(List<Object> params) => localizeFill(this, params);
// String get i18n => localize(this, _t);
//
// String fill(List<Object> params) => localizeFill(this, params);
//
// String plural(int value) => localizePlural(value, this, _t);
//
// String version(Object modifier) => localizeVersion(modifier, this, _t);
//
// Map<String?, String> allVersions() => localizeAllVersions(this, _t);
//
// void loadTranslations() async {
//   _t +=
//       Translations.byLocale("zh_ch")
//           + await GettextImporter().fromAssetDirectory("assets/locales");
// }
}
