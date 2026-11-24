import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sayadganj/features/settings/providers/locale_provider.dart';

import '../../../core/notifications/word_notification_service.dart';
import '../../../core/services/preferences_provider.dart';

class NotificationSettingsState {
  final bool enabled;
  final int hour;
  final int minute;

  const NotificationSettingsState({
    required this.enabled,
    required this.hour,
    required this.minute,
  });

  TimeOfDay get timeOfDay => TimeOfDay(hour: hour, minute: minute);

  NotificationSettingsState copyWith({bool? enabled, int? hour, int? minute}) {
    return NotificationSettingsState(
      enabled: enabled ?? this.enabled,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }
}

class NotificationSettingsNotifier extends Notifier<NotificationSettingsState> {
  static const _enabledKey = 'notif_wod_enabled';
  static const _hourKey = 'notif_wod_hour';
  static const _minuteKey = 'notif_wod_minute';

  @override
  NotificationSettingsState build() {
    final prefs = ref.read(sharedPreferencesProvider);

    ref.listen<Locale>(localeProvider, (previous, next) {
      if (previous != null && previous != next && state.enabled) {
        WordNotificationService.instance.scheduleRollingWordOfTheDay(
          hour: state.hour,
          minute: state.minute,
          locale: next,
        );
      }
    });

    return NotificationSettingsState(
      enabled: prefs.getBool(_enabledKey) ?? false,
      hour: prefs.getInt(_hourKey) ?? 9,
      minute: prefs.getInt(_minuteKey) ?? 0,
    );
  }

  /// Returns false if the OS denied notification permissions.
  Future<bool> setEnabled(bool value) async {
    final prefs = ref.read(sharedPreferencesProvider);

    if (value) {
      final granted = await WordNotificationService.instance
          .requestPermission();
      if (!granted) {
        await prefs.setBool(_enabledKey, false);
        state = state.copyWith(enabled: false);
        return false;
      }

      final locale = ref.read(localeProvider);
      await prefs.setBool(_enabledKey, true);
      state = state.copyWith(enabled: true);
      await WordNotificationService.instance.scheduleRollingWordOfTheDay(
        hour: state.hour,
        minute: state.minute,
        locale: locale,
      );
      return true;
    } else {
      await prefs.setBool(_enabledKey, false);
      state = state.copyWith(enabled: false);
      await WordNotificationService.instance.cancelAll();
      return true;
    }
  }

  Future<void> setReminderTime(TimeOfDay time) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final locale = ref.read(localeProvider);
    await prefs.setInt(_hourKey, time.hour);
    await prefs.setInt(_minuteKey, time.minute);

    state = state.copyWith(hour: time.hour, minute: time.minute);

    if (state.enabled) {
      await WordNotificationService.instance.scheduleRollingWordOfTheDay(
        hour: state.hour,
        minute: state.minute,
        locale: locale,
      );
    }
  }
}

final notificationSettingsProvider =
    NotifierProvider<NotificationSettingsNotifier, NotificationSettingsState>(
      NotificationSettingsNotifier.new,
    );
