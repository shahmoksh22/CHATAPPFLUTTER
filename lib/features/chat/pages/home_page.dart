import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/models/user_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/firestore_service.dart';
import '../../../core/theme/theme_provider.dart';

/// The home page of the application, displaying a list of available users to chat with.
///
/// This page allows users to log out and switch between light and dark themes.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access AuthService, FirestoreService, and ThemeProvider using Provider.
    final authService = Provider.of<AuthService>(context, listen: false);
    final firestoreService = Provider.of<FirestoreService>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        backgroundColor: Theme.of(context).colorScheme.primary, // Use primary color
        foregroundColor: Theme.of(context).colorScheme.onPrimary, // Use contrasting text color
        elevation: 0, // Remove shadow for a flatter look
        actions: [
          // Theme toggle button.
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () {
              themeProvider.setThemeMode(
                themeProvider.themeMode == ThemeMode.dark
                    ? ThemeMode.light
                    : ThemeMode.dark,
              );
            },
          ),
          // Logout button.
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              // Navigate to the authentication page after logout.
              if (context.mounted) {
                context.go('/auth');
              }
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.background, // Background color
      body: StreamBuilder<List<UserModel>>(
        stream: firestoreService.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          final users = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), //Adjust padding
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                    foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                    child: Text(user.email[0].toUpperCase()),
                  ),
                  title: Text(
                      user.email, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                  ),
                  trailing: StreamBuilder<int>(
                    stream: firestoreService.getUnreadMessagesCount(user.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data! > 0) {
                        return CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 12,
                          child: Text(
                            snapshot.data!.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  onTap: () {
                    // Navigate to the chat page for the selected user.
                    context.go('/chat/${user.id}');
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
