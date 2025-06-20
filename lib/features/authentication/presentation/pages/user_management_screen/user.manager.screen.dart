import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mastermanager/core/session/session.manager.dart';
import 'package:mastermanager/features/product_category/domain/entities/product.category.dart';
import 'package:mastermanager/features/product_category/presentation/cubit/local.category.manager.cubit.dart';
import 'package:mastermanager/features/synchronisation/cubit/product_category_sync_manager_cubit/product.category.sync.trigger.cubit.dart';

import '../../../../product_category/presentation/cubit/local.category.manager.state.dart';
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
  late ProductCategory myCategoris;
  @override
  void initState() {
    super.initState();
    currentUser = SessionManager.getUserSession()!;
    context.read<AuthenticationCubit>().fetchUsers();
    context.read<LocalCategoryManagerCubit>().loadCategories();
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
      floatingActionButton: GestureDetector(
        onTap: () {
          setState(() {
            context.read<LocalCategoryManagerCubit>().addCategory(
                  ProductCategory(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: "Electrinics",
                    isActive: true,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  ),
                );
          });
        },
        child: CircleAvatar(),
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
                    : SizedBox(
                        child: Column(
                          children: [
                            IconButton(
                                onPressed: () {
                                  /*Navigator.pushReplacementNamed(
                                      context, "/categories");*/
                                  GoRouter.of(context).go("/categories");
                                },
                                icon: const Icon(Icons.category))
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
