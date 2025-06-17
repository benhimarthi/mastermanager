import '../../../../core/usecase/usecase.dart';
import '../../../../core/util/typedef.dart';
import '../entities/user.dart';
import '../repositories/authentication.repository.dart';

class CreateUser extends UsecaseWithParams<void, CreateUserParams> {
  const CreateUser(this._repository);

  final AuthenticationRepository _repository;

  @override
  ResultFuture<void> call(CreateUserParams params) async =>
      _repository.createUser(
        name: params.name,
        email: params.email,
        avatar: params.avatar,
        role: params.role,
      );
}

class CreateUserParams {
  final String name;
  final String email;
  final String avatar;
  final UserRole role;

  const CreateUserParams({
    required this.name,
    required this.email,
    required this.avatar,
    required this.role,
  });
}
