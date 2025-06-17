import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/user.dart';
import '../../cubit/authentication.cubit.dart';
import '../../cubit/authentication.state.dart';
import '../synchronisation/pending.sync.badge.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthenticationCubit>().fetchUsers();
  }

  void _onDeleteUser(String userId) {
    context.read<AuthenticationCubit>().deleteUser(userId);
  }

  void _onEditUser(User user) {
    showDialog(
      context: context,
      builder: (context) => _EditUserDialog(user: user),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Management")),
      body: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UsersLoaded) {
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return ListTile(
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
                );
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

class _EditUserDialog extends StatefulWidget {
  const _EditUserDialog({required this.user, super.key});

  final User user;

  @override
  State<_EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<_EditUserDialog> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _avatarController;
  UserRole _selectedRole = UserRole.regular;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _avatarController = TextEditingController(text: widget.user.avatar);
    _selectedRole = widget.user.role;
  }

  void _onUpdateUser() {
    final updatedUser = User(
      id: widget.user.id,
      createdAt: widget.user.createdAt,
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: "",
      avatar: _avatarController.text.trim(),
      role: _selectedRole,
    );

    context.read<AuthenticationCubit>().updateUser(updatedUser);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit User"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Name")),
          TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email")),
          TextField(
              controller: _avatarController,
              decoration: const InputDecoration(labelText: "Avatar URL")),
          DropdownButton<UserRole>(
            value: _selectedRole,
            items: const [
              DropdownMenuItem(
                  value: UserRole.admin, child: Text("Administrator")),
              DropdownMenuItem(
                  value: UserRole.regular, child: Text("Regular User")),
            ],
            onChanged: (role) {
              setState(() => _selectedRole = role!);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")),
        ElevatedButton(onPressed: _onUpdateUser, child: const Text("Update")),
      ],
    );
  }
}
