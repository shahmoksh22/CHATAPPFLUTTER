import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

import 'package:myapp/core/services/auth_service.dart';
import 'package:myapp/core/services/firebase_service.dart';
import 'package:myapp/core/services/firestore_service.dart';
import 'package:myapp/core/theme/app_theme.dart';
import 'package:myapp/core/theme/theme_provider.dart';
import 'package:myapp/features/auth/pages/auth_page.dart';
import 'package:myapp/features/splash/pages/splash_page.dart';
import 'package:myapp/features/chat/pages/home_page.dart';
import 'package:myapp/features/chat/pages/chat_page.dart';

/// Main entry point of the Flutter application.
void main() async {
  // Ensure that Flutter widgets are initialized before Firebase.
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase services.
  await FirebaseService.initialize();
  // Initialize Shared Preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Get saved credentials
  String? email = prefs.getString('email');
  String? password = prefs.getString('password');
  String initialRoute = '/';

  if (email != null && password != null) {
    // Attempt to auto-login
    try {
      await AuthService().signInWithEmailAndPassword(email, password);
      initialRoute = '/home';
    } catch (e) {
      // Auto-login failed, stay on auth screen
      initialRoute = '/';
    }
  }

  runApp(MyApp(initialRoute: initialRoute));
}

/// The root widget of the application.
///
/// This widget sets up the multi-provider for state management,
/// configures the app's routing, and applies the theme.
class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provides the authentication service throughout the app.
        Provider<AuthService>(create: (_) => AuthService()),
        // Provides the Firestore service for database operations.
        Provider<FirestoreService>(create: (_) => FirestoreService()),
        // Provides the theme management capabilities.
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        // Streams the authentication state changes from Firebase.
        StreamProvider<User?>.value(
          value: AuthService().authStateChanges,
          initialData: null,
        ),
      ],
      child: Builder(
        builder: (context) {
          final themeProvider = Provider.of<ThemeProvider>(context);

          return MaterialApp.router(
            title: 'Flutter Chat App',
            // Apply light theme with custom page transitions.
            theme: AppTheme.lightTheme.copyWith(
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
                  TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
                },
              ),
            ),
            // Apply dark theme with custom page transitions.
            darkTheme: AppTheme.darkTheme.copyWith(
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
                  TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
                },
              ),
            ),
            // Use the theme mode from the ThemeProvider (system, light, or dark).
            themeMode: themeProvider.themeMode,
            // Configure the router for navigation.
            routerConfig: GoRouter(
              initialLocation: initialRoute,
              routes: <RouteBase>[
                GoRoute(
                  path: '/',
                  builder: (context, state) => const SplashPage(),
                ),
                GoRoute(
                  path: '/auth',
                  builder: (context, state) => const AuthPage(),
                ),
                GoRoute(
                  path: '/home',
                  builder: (context, state) => const HomePage(),
                ),
                GoRoute(
                  path: '/chat/:userId',
                  builder: (context, state) => ChatPage(
                    userId: state.pathParameters['userId']!,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}