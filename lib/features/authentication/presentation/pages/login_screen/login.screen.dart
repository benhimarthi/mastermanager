import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/authentication.cubit.dart';
import '../../cubit/authentication.state.dart';
import '../synchronisation/sync.banner.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  void _onLogin() {
    final email = _emailController.text.trim();
    if (email.isNotEmpty) {
      context.read<AuthenticationCubit>().loginWithEmail(email, '');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid email")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthenticationCubit, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is UserAuthenticated) {
              Navigator.pushReplacementNamed(context, "/home");
            } else if (state is AuthenticationOfflinePending) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("You're offline. Login pending sync.")),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                if (state is AuthenticationOfflinePending) const SyncBanner(),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: state is AuthenticationLoading ? null : _onLogin,
                  child: state is AuthenticationLoading
                      ? const CircularProgressIndicator()
                      : const Text("Login"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
