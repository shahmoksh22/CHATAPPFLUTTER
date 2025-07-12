import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A splash screen widget that navigates to the authentication page after a delay.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Navigate to the authentication page after a 2-second delay.
    Future.delayed(const Duration(seconds: 2), () {
      if(mounted){
        context.go('/auth');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
