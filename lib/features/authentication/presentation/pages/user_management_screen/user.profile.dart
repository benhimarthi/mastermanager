import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mastermanager/core/session/session.manager.dart';
import 'package:mastermanager/features/authentication/domain/entities/user.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  late final User currentUser;
  @override
  void initState() {
    super.initState();
    currentUser = SessionManager.getUserSession()!;
  }

  @override
  Widget build(BuildContext context) {
    // Colors based on the screenshot

    return Scaffold(
      backgroundColor: Colors.black,
      /*appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Account Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),*/
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: ListView(
          children: [
            const SizedBox(height: 50),
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 54,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage(
                        'assets/avatar_placeholder.png'), // Replace with your asset or NetworkImage
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(width: 3),
                      ),
                      padding: const EdgeInsets.all(8),
                      child:
                          const Icon(Icons.edit, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ListTile(
              title: Text(
                "NAME",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
              subtitle: Text(
                currentUser.name,
                style: const TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_sharp,
                size: 16,
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              title: Text(
                "EMAIL",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
              subtitle: Text(
                currentUser.email,
                style: const TextStyle(color: Colors.white),
              ),
              leading: Icon(
                Icons.email,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_sharp,
                size: 16,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
