import 'package:adoptme/core/constants/app_assets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

import '../../../firebase/user_auth/firebase_auth_services.dart';
import '/features/view/views.dart';
import '/shared/components/components.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  static const name = '/login_view';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  bool _isSignig = false;
  final FirebaseAuthServices _auth = FirebaseAuthServices();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

//limpiar recursos cuando no se ocupe
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
        if (constraints.maxWidth < 600) {
          return GestureDetector(
            onTap: () {
              /*FirebaseAuth.instance.signOut();*/
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              //appBar: AppBar(),
              body: CustomPadding(
                padding: 20,
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          // AppBar
                          const CustomCircularAvatar(
                            image: AppAssets.logo,
                            size: 200,
                          ),

                          const SizedBox(height: 30),

                          const CustomLabel(
                            text: 'Iniciar Sesion',
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),

                          const SizedBox(height: 30),

                          CustomTextFieldForm(
                              controller: _emailController,
                              prefixIcon: IconlyBold.message,
                              keyboardType: TextInputType.emailAddress,
                              hintText: 'Example@gmail.com',
                              label: 'Email',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, ingresa tu correo electrónico';
                                } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value)) {
                                  return 'Por favor, ingresa un correo electrónico válido';
                                }
                                return null;
                              }
                              ),

                          const SizedBox(height: 40),

                          CustomTextFieldForm(
                            controller: _passwordController,
                            prefixIcon: IconlyBold.lock,
                            keyboardType: TextInputType.visiblePassword,
                            hintText: '********',
                            label: 'Contraseña',
                            suffixIcon: Icon(IconlyBold.show),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingresa tu contraseña';
                              } else if (value.length < 8) {
                                return 'La contraseña debe tener al menos 8 caracteres';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 40),

                          CustomActionButton(
                            child: _isSignig
                                ? CircularProgressIndicator(color: Colors.white)
                                : CustomLabel(
                                    text: 'Iniciar Sesión',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                            onPressed: () => _signIn(),
                            sizeHeight: 60,
                          ),

                          // Button de session de usuario

                          const SizedBox(height: 20),

                          // Si no tienes una cuenta
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CustomLabel(
                                text: '¿No tienes una cuenta?',
                              ),
                              TextButton(
                                child: const CustomLabel(
                                  text: 'Registrate',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                onPressed: () =>
                                    context.push('/${RegisterView.name}'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return const LoginWebView();
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
      context.go(
          '/${BottomNavbar.name}'); // O simplemente '/login' si la ruta está definida así
    } else {
      print("Some error occurred");
    }
  }
}
