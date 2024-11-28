import 'dart:math';

import 'package:adoptme/core/constants/app_assets.dart';
import 'package:adoptme/features/view/views.dart';
import 'package:adoptme/shared/components/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

import '../../../../core/utils/utils.dart';
import '../../../../firebase/user_auth/firebase_auth_services.dart';

class LoginWebView extends StatefulWidget {
  const LoginWebView({super.key});

  static const name = '/login_web_view';

  @override
  State<LoginWebView> createState() => _LoginWebViewState();
}

class _LoginWebViewState extends State<LoginWebView> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSignig = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          Size size = MediaQuery.of(context).size;
          double currentDiagonal = sqrt(pow(size.width, 2) + pow(size.height, 2));
          // Modo web
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              body: Container(
                color: Theme.of(context).colorScheme.inversePrimary,
                child: Row(
                  children: [
                    // Imagen
                    Expanded(
                      child: Image.asset(AppAssets.logo),
                    ),

                    // Campos de inputs
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          border: const Border(
                            top: BorderSide(width: .5),
                            bottom: BorderSide(width: .5),
                            right: BorderSide(width: .5),
                          ),
                        ),
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Titulo del login
                                Stack(
                                  alignment: Alignment.center,
                                  clipBehavior: Clip.none,
                                  children: [
                                    const CustomLabel(
                                      textAlign: TextAlign.center,
                                      fontSize: 40,
                                      text: 'Iniciar Sesion',
                                      fontWeight: FontWeight.bold,
                                    ),
                                    Image.asset(AppAssets.patita)
                                  ],
                                ),

                                gapH(30),

                                // Los texto de los inputs
                                CustomTextFieldForm(
                                  controller: _emailController,
                                  fontSize: currentDiagonal * .012,
                                  prefixIcon: IconlyBold.message,
                                  hintText: 'Example@example.com',
                                  label: 'Email',
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, ingresa tu correo electrónico';
                                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                        .hasMatch(value)) {
                                      return 'Por favor, ingresa un correo electrónico válido';
                                    }
                                    return null;
                                  },
                                ),

                                gapH(20),

                                CustomTextFieldForm(
                                  controller: _passwordController,
                                  fontSize: currentDiagonal * .012,
                                  prefixIcon: IconlyBold.lock,
                                  suffixIcon: IconButton(
                                    icon: Icon(_isPasswordVisible
                                        ? IconlyBold.hide
                                        : IconlyBold.show),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible = !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                  obscureText: !_isPasswordVisible,
                                  hintText: 'Password',
                                  label: 'Contraseña',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, ingresa tu contraseña';
                                    } else if (value.length < 8) {
                                      return 'La contraseña debe tener al menos 8 caracteres';
                                    }
                                    return null;
                                  },
                                ),

                                gapH(30),

                                // Botton de login
                                CustomActionButton(
                                  child: _isSignig
                                      ? const CircularProgressIndicator(color: Colors.white)
                                      : CustomLabel(
                                    text: 'Iniciar Sesion',
                                    fontSize: currentDiagonal * .013,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  onPressed: _signIn,
                                  sizeHeight: currentDiagonal * .05,
                                ),

                                gapH(30),
                                // Botton de registrarse
                                FittedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomLabel(
                                        text: '¿No tienes cuenta? ',
                                        fontSize: currentDiagonal * .012,
                                      ),
                                      TextButton(
                                        onPressed: () => context.push('/${RegisterWebView.name}'),
                                        child: CustomLabel(
                                          text: 'Registrate',
                                          fontWeight: FontWeight.bold,
                                          fontSize: currentDiagonal * .012,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          // Modo mobile
          return const LoginView();
        }
      },
    );
  }

  void _signIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSignig = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    setState(() {
      _isSignig = false;
    });

    if (user != null) {
      print("User is successfully signed in");
      context.go('/${BottomNavbar.name}');
    } else {
      // Opcional: Mostrar un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al iniciar sesión. Verifica tus credenciales.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}