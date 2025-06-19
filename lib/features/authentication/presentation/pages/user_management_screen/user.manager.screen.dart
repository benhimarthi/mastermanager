import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mastermanager/core/session/session.manager.dart';

import '../../../domain/entities/user.dart';
import '../../cubit/authentication.cubit.dart';
import '../../cubit/authentication.state.dart';
import '../../widgets/edit.user.dialog.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  late User currentUser;
  @override
  void initState() {
    super.initState();
    currentUser = SessionManager.getUserSession()!;
    context.read<AuthenticationCubit>().fetchUsers();
  }

  void _onDeleteUser(String userId) {
    context.read<AuthenticationCubit>().deleteUser(userId);
  }

  void _onEditUser(User user) {
    showDialog(
      context: context,
      builder: (context) => EditUserDialog(user: user),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.home),
            ),
            const Text("User Management"),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              _onEditUser(currentUser);
            },
            icon: const Icon(Icons.person),
          )
        ],
      ),
      body: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UsersLoaded) {
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return user.id != currentUser.id
                    ? ListTile(
                        title: Text(user.name),
                        subtitle: Text(user.email),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _onEditUser(user)),
                            IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _onDeleteUser(user.id)),
                          ],
                        ),
                      )
                    : const SizedBox();
              },
            );
          } else if (state is AuthenticationError) {
            return Center(child: Text("Error: ${state.message}"));
          } else {
            return const Center(child: Text("No users found"));
          }
        },
      ),
    );
  }
}
