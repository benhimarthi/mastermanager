import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mastermanager/core/session/session.manager.dart';
import 'package:mastermanager/core/util/change.screen.manager.dart';
import 'package:mastermanager/features/Inventory/presentation/pages/inventory.list.screen.dart';
import 'package:mastermanager/features/authentication/presentation/pages/user_management_screen/user.profile.dart';
import 'package:mastermanager/features/product/presentation/pages/product.page.dart';
import 'package:mastermanager/features/product_category/domain/entities/product.category.dart';
import 'package:mastermanager/features/product_category/presentation/cubit/local.category.manager.cubit.dart';
import 'package:mastermanager/features/product_pricing/presentation/pages/product.pricing.page.dart';
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
  bool _isMoved = false;
  final double initialSelectorPosition = 0;
  late double targetPosition = 0;

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

  selectedOption() {
    return Container(
      color: const Color.fromARGB(255, 27, 29, 31),
      height: 120,
      width: 45,
      child: Align(
        alignment: Alignment.center,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 30,
                height: 118,
                color: Colors.black,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 60,
                height: 100,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: const RotatedBox(
                  quarterTurns: -1, // Rotates 90° counter-clockwise
                  child: Text(
                    'Home',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 60,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 27, 29, 31),
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(60)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 60,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 27, 29, 31),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: const Color.fromARGB(255, 27, 29, 31),
                  height: double.infinity,
                  width: MediaQuery.of(context).size.width * .2,
                ),
                Container(
                  color: const Color.fromARGB(255, 27, 29, 31),
                  height: double.infinity,
                  width: MediaQuery.of(context).size.width * .2,
                )
              ],
            ),
            Align(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.black,
                    width: MediaQuery.of(context).size.width * .88,
                    height: double.infinity,
                  ),
                  SizedBox(
                    width: 49,
                    height: double.infinity,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 100,
                          width: 35,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.person,
                                color: Theme.of(context).primaryColor,
                              ),
                              Icon(
                                Icons.notifications,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        RotatedBox(
                            quarterTurns: -1, // Rotates 90° counter-clockwise
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  //_isMoved = !_isMoved;
                                  targetPosition = 0;
                                });
                              },
                              child: const Text(
                                'Home',
                                style: TextStyle(fontSize: 20),
                              ),
                            )),
                        const SizedBox(
                          height: 50,
                        ),
                        RotatedBox(
                            quarterTurns: -1, // Rotates 90° counter-clockwise
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  setState(() {
                                    targetPosition = 118;
                                    //_isMoved = !_isMoved;
                                  });
                                });
                              },
                              child: const Text(
                                'My finances',
                                style: TextStyle(fontSize: 20),
                              ),
                            )),
                        const SizedBox(
                          height: 50,
                        ),
                        RotatedBox(
                            quarterTurns: -1, // Rotates 90° counter-clockwise
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  targetPosition = 118 * 2;
                                  _isMoved = false; //_isMoved;
                                });
                              },
                              child: const Text(
                                'My Stats',
                                style: TextStyle(fontSize: 20),
                              ),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Align(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    //color: const Color.fromARGB(255, 188, 114, 114),
                    width: MediaQuery.of(context).size.width * .88,
                    height: double.infinity,
                  ),
                  SizedBox(
                    width: 49,
                    height: double.infinity,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 100,
                          width: 35,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          //color: Color.fromARGB(68, 255, 193, 7),
                          height: 500,
                          width: 55,
                          child: Stack(
                            children: [
                              AnimatedPositioned(
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeInOut,
                                top: _isMoved
                                    ? initialSelectorPosition
                                    : targetPosition,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      //_isMoved = !_isMoved;
                                    });
                                  },
                                  child: selectedOption(),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                color: const Color.fromARGB(255, 0, 0, 0),
                width: MediaQuery.of(context).size.width * .89,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
