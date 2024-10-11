import 'package:adoptme/firebase/user_auth/firebase_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
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


  bool _isSignigUp = false;

  final _formKey = GlobalKey<FormState>();
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

//limpiar recursos cuando no se ocupe
  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
              child:Form(
                key: _formKey,
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

                  CustomTextFieldForm(
                    controller: _usernameController,
                    keyboardType: TextInputType.name,
                    prefixIcon: IconlyBold.profile,
                    hintText: 'Pepito',
                    label: 'Nombre',
                    validator: (value){
                      if (value==null || value.isEmpty) {
                        return 'Debe ingresar un nombre';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  CustomTextFieldForm(
                    controller: _emailController,
                    prefixIcon: IconlyBold.message,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Example@gmail.com',
                    label: 'Email',
                    validator: (value){
                      if(value==null || value.isEmpty){
                        return 'El correo electronico es obligatorio';
                      }
                      RegExp regExp = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                      return regExp.hasMatch(value) ? null : 'Correo electrónico no válido';

                    },
                  ),

                  const SizedBox(height: 20),

                  CustomTextFieldForm(
                    controller: _passwordController,
                    prefixIcon: IconlyBold.lock,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: '********',
                    label: 'Contraseña',
                    obscureText: true,
                    validator: (value){
                      if(value==null || value.isEmpty){
                        return 'La contraseña es obligatoria';
                      }
                      if(value.length < 8){
                        return 'La contraseña debe tener al menos 8 caracteres';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  CustomTextFieldForm(
                    controller: _confirmPasswordController,
                    prefixIcon: IconlyBold.lock,
                    hintText: '********',
                    label: 'Confirmar Contraseña',
                    obscureText: true,
                    validator: (value){
                      if(value==null || value.isEmpty){
                        return 'Debe confirmar la contraseña';
                      }
                      if(_passwordController.text!= value){
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    }
                  ),

                  const SizedBox(height: 40),

                  CustomActionButton(child: _isSignigUp
                      ? CircularProgressIndicator(color: Colors.white)
                      : CustomLabel(
                      text: 'Registrarse',
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                  ),
                    onPressed: _signUp,
                    sizeHeight: 60,),



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
      ),
    );
  }



  void _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isSignigUp=true;
    });

    /*String username = _usernameController.text;*/
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      _isSignigUp=false;
    });

    if (user != null) {
      print("User is successfully created");
      context.go(
          '/${LoginView.name}'); // O simplemente '/login' si la ruta está definida así
    } else {
      print("Failed to create user");
    }
  }

}




