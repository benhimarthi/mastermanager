import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user.dart';
import '../../cubit/authentication.cubit.dart';
import '../../cubit/authentication.state.dart';
import '../synchronisation/sync.banner.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _avatarController = TextEditingController();
  UserRole _selectedRole = UserRole.regular;

  void _onRegister() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final avatar = _avatarController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    context.read<AuthenticationCubit>().createUser(
          name: name,
          email: email,
          avatar: avatar.isNotEmpty ? avatar : "default_avatar.png",
          role: _selectedRole,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthenticationCubit, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is UserCreated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("User created successfully!")),
              );
              Navigator.pushReplacementNamed(context, "/home");
            } else if (state is AuthenticationOfflinePending) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text("You're offline. Registration pending sync.")),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                if (state is AuthenticationOfflinePending) const SyncBanner(),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Full Name"),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _avatarController,
                  decoration:
                      const InputDecoration(labelText: "Avatar URL (Optional)"),
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:
                      state is AuthenticationLoading ? null : _onRegister,
                  child: state is AuthenticationLoading
                      ? const CircularProgressIndicator()
                      : const Text("Register"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
