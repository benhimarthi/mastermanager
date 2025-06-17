import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SyncBanner extends StatelessWidget {
  const SyncBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == ConnectivityResult.none) {
          return Container(
            color: Colors.redAccent,
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: const Text(
              "You're offline. Changes will sync when you reconnect.",
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
