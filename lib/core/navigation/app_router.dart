import 'package:go_router/go_router.dart';
import '../../features/auth/pages/auth_page.dart';
import '../../features/chat/pages/chat_page.dart';
import '../../features/chat/pages/home_page.dart';
import '../../features/splash/pages/splash_page.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
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
  );
}
