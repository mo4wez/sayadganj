import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:material_ui/material_ui.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../features/dictionary/domain/quiz_question.dart';
import '../../features/dictionary/domain/word_entry.dart';
import '../../features/dictionary/presentation/word_detail_screen.dart';
import '../database/dictionary_db_service.dart';

class WordNotificationService {
  WordNotificationService._();

  static final WordNotificationService instance = WordNotificationService._();

  static const String _channelId = 'sayadganj_word_of_day';
  static const String _channelName = 'روچ ءِ لبز (Word of the Day)';
  static const String _channelDesc =
      'هر روچ یک نوکیں بلوچی لبزے گوں آئی ءِ مانا ءَ';
  static const int _baseNotificationId = 4100;
  static const int _queueDays = 7;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  GlobalKey<NavigatorState>? _navigatorKey;
  bool _initialized = false;
  int? _pendingWordId;

  Future<void> initialize({
    required GlobalKey<NavigatorState> navigatorKey,
  }) async {
    _navigatorKey = navigatorKey;
    if (_initialized) return;

    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
      ),
      onDidReceiveNotificationResponse: _handleNotificationResponse,
    );

    // Check if the app was cold-launched by tapping a Word of the Day notification
    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    final payload = launchDetails?.notificationResponse?.payload;
    if ((launchDetails?.didNotificationLaunchApp ?? false) && payload != null) {
      _pendingWordId = _parseWordId(payload);
    }

    _initialized = true;
  }

  /// Call once after MainShellScreen mounts to open any cold-start notification word.
  void consumePendingNavigation() {
    final wordId = _pendingWordId;
    if (wordId == null) return;
    _pendingWordId = null;
    _navigateToWord(wordId);
  }

  void _handleNotificationResponse(NotificationResponse response) {
    final wordId = _parseWordId(response.payload);
    if (wordId != null) {
      _navigateToWord(wordId);
    }
  }

  int? _parseWordId(String? payload) {
    if (payload == null || !payload.startsWith('word:')) return null;
    return int.tryParse(payload.substring(5));
  }

  void _navigateToWord(int wordId) {
    final nav = _navigatorKey?.currentState;
    if (nav == null) {
      _pendingWordId = wordId;
      return;
    }

    nav.push(
      MaterialPageRoute(builder: (_) => WordDetailScreen(wordId: wordId)),
    );
  }

  /// Requests OS notification permission when the user enables notifications.
  Future<bool> requestPermission() async {
    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidImpl != null) {
      final granted = await androidImpl.requestNotificationsPermission();
      return granted ?? true;
    }

    final iosImpl = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (iosImpl != null) {
      final granted = await iosImpl.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true;
  }

  /// Cancels existing reminders and schedules a fresh 7-day Word of the Day queue.
  Future<void> scheduleRollingWordOfTheDay({
    required int hour,
    required int minute,
  }) async {
    await cancelAll();

    final words = await _pickDailyWords(_queueDays);
    if (words.isEmpty) return;

    final now = DateTime.now();
    var firstSlot = DateTime(now.year, now.month, now.day, hour, minute);
    if (!firstSlot.isAfter(now.add(const Duration(minutes: 1)))) {
      firstSlot = firstSlot.add(const Duration(days: 1));
    }

    for (int i = 0; i < words.length; i++) {
      final entry = words[i];
      final slotLocal = firstSlot.add(Duration(days: i));
      final scheduledTz = tz.TZDateTime.from(slotLocal.toUtc(), tz.UTC);

      final headword = entry.fullWordWithSymbols.isNotEmpty
          ? entry.fullWordWithSymbols
          : entry.fullWord;
      final cleanMeaning = QuizQuestion.formatOptionDefinition(entry);

      final androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDesc,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        styleInformation: BigTextStyleInformation(
          cleanMeaning,
          contentTitle: 'روچ ءِ لبز: $headword',
          summaryText: 'سیدگنج',
        ),
      );

      const darwinDetails = DarwinNotificationDetails();

      await _plugin.zonedSchedule(
        id: _baseNotificationId + i,
        title: 'روچ ءِ لبز: $headword',
        body: cleanMeaning,
        scheduledDate: scheduledTz,
        notificationDetails: NotificationDetails(
          android: androidDetails,
          iOS: darwinDetails,
        ),
        payload: 'word:${entry.id}',
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  Future<void> cancelAll() async {
    for (int i = 0; i < _queueDays; i++) {
      await _plugin.cancel(id: _baseNotificationId + i);
    }
  }

  Future<List<WordEntry>> _pickDailyWords(int count) async {
    try {
      final db = await DictionaryDbService.instance.database;
      final rows = await db.query(
        'sayadganj',
        where:
            "TRIM(full_word) != '' "
            'AND LENGTH(TRIM(definition)) >= 14 '
            "AND full_word_with_symbols NOT LIKE '%✪%'",
        orderBy: 'RANDOM()',
        limit: count * 6,
      );

      final eligible =
          rows
              .map(WordEntry.fromMap)
              .where(QuizQuestion.isQuizEligible)
              .toList()
            ..shuffle(Random());

      return eligible.take(count).toList();
    } catch (_) {
      return const [];
    }
  }
}
