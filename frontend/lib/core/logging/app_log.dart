import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:talker/talker.dart';

/// Single logging entry point for the whole app, built on Talker.
///
/// Talker handles console output and an in-memory history itself. For file
/// logging we subscribe to [Talker.stream] (every log/error/exception passes
/// through it exactly once) and append the plain-text form to a rotating file.
///
/// Usage:
///   await AppLog.init(console: true, file: true);   // once, in main()
///   AppLog.talker.info('something happened');
///   AppLog.talker.handle(error, stackTrace, 'context');
///   AppLog.setConsole(false);   // runtime toggle
///   await AppLog.disableFile();  // runtime toggle
class AppLog {
  AppLog._();

  static late final Talker talker;

  static StreamSubscription<TalkerData>? _fileSub;
  static _RotatingFileSink? _sink;
  static bool _fileEnabled = false;
  static String? logFilePath;

  static bool get fileEnabled => _fileEnabled;

  /// Call once early in main().
  static Future<void> init({bool console = true, bool file = true}) async {
    talker = Talker(
      settings: TalkerSettings(
        useConsoleLogs: console,
        maxHistoryItems: 500,
      ),
    );
    if (file) {
      await enableFile();
    }
  }

  /// Turn the terminal sink on/off at runtime.
  static void setConsole(bool on) {
    talker.configure(
      settings: TalkerSettings(useConsoleLogs: on, maxHistoryItems: 500),
    );
  }

  /// Turn the file sink on at runtime (also called by [init]).
  static Future<void> enableFile() async {
    if (_fileEnabled) return;
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/app_log.txt');
    logFilePath = file.path;
    _sink = _RotatingFileSink(file);
    _fileSub = talker.stream.listen(
      // Full date+time and Talker's complete message (title, level, message,
      // exception and stack trace) — the readable, color-free file equivalent
      // of the console output.
      (data) => _sink?.write(
        data.generateTextMessage(timeFormat: TimeFormat.yearMonthDayAndTime),
      ),
    );
    _fileEnabled = true;
  }

  /// Turn the file sink off at runtime.
  static Future<void> disableFile() async {
    await _fileSub?.cancel();
    _fileSub = null;
    _sink = null;
    _fileEnabled = false;
  }
}

/// Size-capped log file with N rotating backups (app_log.txt.1, .2, .3).
/// Writes are best-effort: logging must never crash the app.
class _RotatingFileSink {
  _RotatingFileSink(
    this._file, {
    this.maxBytes = 5 * 1024 * 1024,
    this.maxBackups = 3,
  });

  final File _file;
  final int maxBytes;
  final int maxBackups;

  Future<void> write(String line) async {
    try {
      await _rotateIfNeeded();
      await _file.writeAsString('$line\n', mode: FileMode.append, flush: false);
    } catch (_) {
      // Swallow — a failed log write must not take down the app.
    }
  }

  Future<void> _rotateIfNeeded() async {
    if (!await _file.exists() || await _file.length() < maxBytes) return;

    final oldest = File('${_file.path}.$maxBackups');
    if (await oldest.exists()) await oldest.delete();

    for (var i = maxBackups - 1; i >= 1; i--) {
      final f = File('${_file.path}.$i');
      if (await f.exists()) await f.rename('${_file.path}.${i + 1}');
    }

    // Move current -> .1; the next append recreates the base file.
    await _file.rename('${_file.path}.1');
  }
}
