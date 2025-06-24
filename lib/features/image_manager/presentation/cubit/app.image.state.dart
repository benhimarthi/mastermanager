import 'package:equatable/equatable.dart';
import '../../domain/entities/app.image.dart';

abstract class AppImageState extends Equatable {
  const AppImageState();

  @override
  List<Object?> get props => [];
}

class AppImageManagerLoading extends AppImageState {}

class AppImageManagerLoaded extends AppImageState {
  final List<AppImage> images;

  const AppImageManagerLoaded(this.images);

  @override
  List<Object?> get props => [images];
}

class AppImageManagerError extends AppImageState {
  final String message;

  const AppImageManagerError(this.message);

  @override
  List<Object?> get props => [message];
}
