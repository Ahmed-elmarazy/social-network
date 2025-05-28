// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/shared/custom_botton.dart';
import '../../widgets/shared/custom_text_field.dart';
import '../home_page/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _loadRememberedEmail();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadRememberedEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rememberedEmail = prefs.getString('email');
      if (rememberedEmail != null && rememberedEmail.isNotEmpty) {
        setState(() {
          _emailController.text = rememberedEmail;
          _rememberMe = true;
        });
      }
    } catch (e) {
      debugPrint('Error loading remembered email: $e');
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final url = Uri.parse('http://127.0.0.1:8000/accounts/login/');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);
      print('Response body: ${response.body}');
      print("Response: $data");
      if (response.statusCode == 200 && data['message'] == 'login success') {
        print('Login Token: ${data['token']}');

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        await prefs.setString('token', data['token']);
        print('Saved Token: ${prefs.getString('token')}');

        final token = data['token'];
        if (token != null && token is String) {
          await prefs.setString('token', token);
          print('Stored token: $token'); // Debug print
        } else {
          print('Token is missing or invalid');
        }
        

        if (data.containsKey('user') && data['user'] != null) {
          final user = data['user'];
          if (user is int) {
            await prefs.setInt('user_id', user);
          } else if (user is Map && user.containsKey('id')) {
            await prefs.setInt('user_id', user['id']);
            print('Saved user_id: ${prefs.getInt('user_id')}');

          }
        }

        if (_rememberMe) {
          await prefs.setString('email', email);
        } else {
          await prefs.remove('email');
        }

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const HomeScreen(),
            transitionsBuilder:
                (_, a, __, c) => FadeTransition(opacity: a, child: c),
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'User does not exist'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connection error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // ignore: control_flow_in_finally
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Welcome ',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      ' Back!',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 80),
                    CustomTextField(
                      controller: _emailController,
                      hint: 'Username or Email',
                      hintColor: Colors.grey,
                      prefixIcon: const Icon(Icons.email, color: Color(0xff626262)),
                      textColor: const Color(0xff676767),
                      fillColor: Colors.grey.shade300,
                      borderColor: const Color(0xFFA8A8A9),
                      validator: _validateEmail,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _passwordController,
                      hint: 'Password',
                      hintColor: Colors.grey,
                      prefixIcon: const Icon(Icons.lock, color: Color(0xff626262)),
                      obscureText: !_isPasswordVisible,
                      textColor: const Color(0xff676767),
                      fillColor: Colors.grey.shade300,
                      borderColor: const Color(0xFFA8A8A9),
                      validator: _validatePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color(0xff626262),
                        ),
                        onPressed:
                            () => setState(
                              () => _isPasswordVisible = !_isPasswordVisible,
                            ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged:
                              (value) => setState(() => _rememberMe = value!),
                          fillColor: WidgetStateProperty.resolveWith<Color>(
                            (states) =>
                                states.contains(WidgetState.selected)
                                    ? Colors.blue
                                    : Colors.grey[400]!,
                          ),
                        ),
                        const Text('Remember me'),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      text: 'Login',
                      onPressed: _isLoading ? null : _login,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 25),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/register'),
                        child: RichText(
                          text: const TextSpan(
                            text: " Create An Account ",
                            style: TextStyle(color: Colors.black54),
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
