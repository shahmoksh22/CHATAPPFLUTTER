import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/auth_service.dart';
import '../../../shared/widgets/custom_text_field.dart';

/// A page for user authentication, handling both login and registration.
///
/// Users can switch between login and registration forms and authenticate
/// using Firebase Authentication.
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLogin = true;

  /// Displays a [SnackBar] with an error [message].
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _saveCredentials(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  /// Authenticates the user based on the [_isLogin] flag.
  ///
  /// If [_isLogin] is true, attempts to sign in. Otherwise, attempts to register.
  /// New registered users' data is stored in Firestore.
  /// Navigates to the home page on successful authentication.
  Future<void> _authenticate() async {
    try {
      if (_isLogin) {
        await _authService.signInWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );
        await _saveCredentials(_emailController.text, _passwordController.text);
      } else {
        UserCredential? userCredential = await _authService.registerWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );
        if (userCredential != null && userCredential.user != null) {
          await _firestore.collection('users').doc(userCredential.user!.uid).set({
            'email': userCredential.user!.email,
            'uid': userCredential.user!.uid,
          });
          await _saveCredentials(_emailController.text, _passwordController.text);
        }
      }
      // Navigate to the home page if the widget is still mounted.
      if (mounted) {
        context.go('/home');
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase specific errors.
      if (mounted) {
        _showErrorSnackBar(e.message ?? 'An unknown error occurred.');
      }
    } catch (e) {
      // Handle any other unexpected errors.
      if (mounted) {
        _showErrorSnackBar('An unexpected error occurred.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Register'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email input field.
              CustomTextField(
                controller: _emailController,
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              // Password input field.
              CustomTextField(
                controller: _passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 20),
              // Login/Register button.
              ElevatedButton(
                onPressed: _authenticate,
                child: Text(_isLogin ? 'Login' : 'Register'),
              ),
              // Button to toggle between login and register forms.
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
                child: _isLogin
                    ? const Text("Don't have an account? Register")
                    : const Text("Already have an account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
