import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get_it/get_it.dart';
import 'features/synchronisation/cubit/authentication_synch_manager_cubit/sync.trigger.cubit.dart';

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();
  await service.startService();

  service.on('onStart').listen((event) async {
    final syncTriggerCubit = GetIt.instance<SyncTriggerCubit>();
    syncTriggerCubit.startSyncing(); // ✅ Runs in background
  });
}
