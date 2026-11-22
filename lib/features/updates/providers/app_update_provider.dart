import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/preferences_provider.dart';
import '../domain/app_update_info.dart';
import '../services/github_update_service.dart';

class AppUpdateState {
  final bool isChecking;
  final AppUpdateInfo? availableUpdate;
  final bool bannerDismissed;
  final String? errorMessage;

  const AppUpdateState({
    this.isChecking = false,
    this.availableUpdate,
    this.bannerDismissed = false,
    this.errorMessage,
  });

  bool get shouldShowBanner => availableUpdate != null && !bannerDismissed;

  AppUpdateState copyWith({
    bool? isChecking,
    AppUpdateInfo? availableUpdate,
    bool clearUpdate = false,
    bool? bannerDismissed,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AppUpdateState(
      isChecking: isChecking ?? this.isChecking,
      availableUpdate: clearUpdate
          ? null
          : (availableUpdate ?? this.availableUpdate),
      bannerDismissed: bannerDismissed ?? this.bannerDismissed,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class AppUpdateNotifier extends Notifier<AppUpdateState> {
  static const String _dismissedKey = 'dismissed_update_version';

  @override
  AppUpdateState build() => const AppUpdateState();

  Future<AppUpdateInfo?> check({bool silent = true}) async {
    if (state.isChecking) return state.availableUpdate;

    state = state.copyWith(isChecking: true, clearError: true);

    try {
      final update = await GithubUpdateService.instance.checkForUpdate();
      final prefs = ref.read(sharedPreferencesProvider);
      final dismissedVersion = prefs.getString(_dismissedKey);

      final isDismissed =
          silent && update != null && dismissedVersion == update.latestVersion;

      state = AppUpdateState(
        isChecking: false,
        availableUpdate: update,
        bannerDismissed: isDismissed,
      );
      return update;
    } catch (_) {
      state = state.copyWith(
        isChecking: false,
        errorMessage: silent ? null : 'انٹرنیٹ ءِ بندش ءَ چکّاس کن',
      );
      return null;
    }
  }

  Future<void> dismissBanner() async {
    final version = state.availableUpdate?.latestVersion;
    if (version != null) {
      await ref
          .read(sharedPreferencesProvider)
          .setString(_dismissedKey, version);
    }
    state = state.copyWith(bannerDismissed: true);
  }
}

final appUpdateProvider = NotifierProvider<AppUpdateNotifier, AppUpdateState>(
  AppUpdateNotifier.new,
);
