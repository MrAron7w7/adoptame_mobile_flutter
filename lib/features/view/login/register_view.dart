import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

import '/core/constants/app_assets.dart';
import '/features/view/views.dart';
import '/shared/components/components.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  static const name = 'register_view';

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

//limpiar recursos cuando no se ocupe
  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        //appBar: AppBar(),
        body: CustomPadding(
          padding: 20,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // AppBar
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomLabel(
                        text: 'Registrarse',
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                      CustomCircularAvatar(
                        image: AppAssets.logo,
                        size: 70,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const CustomTextFieldForm(
                    keyboardType: TextInputType.name,
                    prefixIcon: IconlyBold.profile,
                    hintText: 'Pepito',
                    label: 'Nombre',
                  ),

                  const SizedBox(height: 20),

                  const CustomTextFieldForm(
                    prefixIcon: IconlyBold.message,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Example@gmail.com',
                    label: 'Email',
                  ),

                  const SizedBox(height: 20),

                  const CustomTextFieldForm(
                    prefixIcon: IconlyBold.lock,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: '********',
                    label: 'Contraseña',
                    suffixIcon: Icon(IconlyBold.show),
                  ),

                  const SizedBox(height: 20),

                  const CustomTextFieldForm(
                    prefixIcon: IconlyBold.lock,
                    hintText: '********',
                    label: 'Confirmar Contraseña',
                    keyboardType: TextInputType.visiblePassword,
                    suffixIcon: Icon(IconlyBold.show),
                  ),

                  const SizedBox(height: 40),

                  CustomButton(
                    text: 'Registrarse',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    onPressed: () {},
                    sizeHeight: 60,
                  ),

                  const SizedBox(height: 20),

                  // Si no tienes una cuenta
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomLabel(
                        text: '¿Ya tienes una cuenta?',
                      ),
                      TextButton(
                        child: const CustomLabel(
                          text: 'Iniciar Sesion',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        onPressed: () => context.go('/${LoginView.name}'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
