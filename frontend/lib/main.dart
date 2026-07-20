import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/app.dart';
import 'package:frontend/core/logging/app_log.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';

Future<void> main() async {
  // Required before any plugin call (path_provider) runs.
  WidgetsFlutterBinding.ensureInitialized();

  // console/file sinks: flip here, or toggle at runtime with
  // AppLog.setConsole(...) / AppLog.enableFile() / AppLog.disableFile().
  await AppLog.init(console: true, file: true);
  AppLog.talker.info('[APP] Starting (log file: ${AppLog.logFilePath})');

  // Log every bloc event/transition/error. Full data OFF so state (which may
  // hold user info later) is never dumped into the logs.
  Bloc.observer = TalkerBlocObserver(
    talker: AppLog.talker,
    settings: const TalkerBlocLoggerSettings(
      printEventFullData: true,
      printStateFullData: true,
    ),
  );

  // Route uncaught framework + platform errors into Talker (and the file).
  final previousOnError = FlutterError.onError;
  FlutterError.onError = (details) {
    AppLog.talker.handle(details.exception, details.stack, 'FlutterError');
    previousOnError?.call(details);
  };
  WidgetsBinding.instance.platformDispatcher.onError = (error, stack) {
    AppLog.talker.handle(error, stack, 'Uncaught');
    return true; // handled — don't crash the isolate
  };

  runApp(InventoryPlaygroundApp());
}
