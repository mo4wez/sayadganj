import '../../../l10n/app_localizations.dart';

enum SearchScope {
  containsHeadword,
  startsWith,
  inDefinitions;

  String localizedLabel(AppLocalizations l10n) => switch (this) {
    SearchScope.containsHeadword => l10n.searchScopeContainsHeadword,
    SearchScope.startsWith => l10n.searchScopeStartsWith,
    SearchScope.inDefinitions => l10n.searchScopeInDefinitions,
  };
}
