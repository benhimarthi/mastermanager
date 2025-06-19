import 'package:equatable/equatable.dart';

abstract class SyncTriggerState extends Equatable {
  const SyncTriggerState();

  @override
  List<Object?> get props => [];
}

class SyncInitial extends SyncTriggerState {}

class SyncInProgress extends SyncTriggerState {}

class SyncSuccess extends SyncTriggerState {}

class SyncFailure extends SyncTriggerState {
  final String message;

  const SyncFailure(this.message);

  @override
  List<Object?> get props => [message];
}
