import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  // control par amostrar y ocultar el password
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {

    //para obtener el tamaño de la pantalla
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                width: size.width,
                height: 200,
                child: RiveAnimation.asset('animated_login_bear.riv'),
              ),
            // Para separar elementos
            SizedBox(height: 10),
            // Campo de texto para email
            TextField(
              //para mostrar un tipo de teclado
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  //para redondear los bordes del campo de texto
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),

            SizedBox(height: 10),
            // Campo de texto para password
            TextField(
              //para mostrar un tipo de teclado
              obscureText: _obscureText,
              decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  //para redondear los bordes del campo de texto
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
            ]
          ),
        )
      )
    );
  }
}