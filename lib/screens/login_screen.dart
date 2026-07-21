import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'dart:async'; //para poner timer

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  // control par amostrar y ocultar el password
  bool _obscureText = true;

  // 1. Declarar variable para el cerebro de la animación
  StateMachineController? _controller;
  // state machine input
  SMIBool? _isChecking;
  SMIBool? _isHandsUp;
  SMITrigger? _trigSuccess;
  SMITrigger? _trigFail;

  // variables para recorrer la mirada del oso
  SMINumber? _numLook;

  // timer para detener la mirada del oso despues de cierto tiempo
  Timer? _typingDebounce;

  // crear variables para focusNode
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(() {
      if (_emailFocus.hasFocus) {
        // verifica que no sea nulo
        if (_isHandsUp != null) {
        // Manos abajo al escribir el email
        _isHandsUp!.change(false);
        // mirada neutral
        _numLook?.value = 50;
        }
      }
    });
    _passwordFocus.addListener(() {
        // Manos arriba al escribir el password
        _isHandsUp!.change(_passwordFocus.hasFocus);
        
    });
  }

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
                child: RiveAnimation.asset(
                  stateMachines: ['Login Machine'],
                  // al iniciar la animacion
                  onInit: (artboard) {
                    _controller = StateMachineController.fromArtboard(
                      artboard, 'Login Machine'
                      );
                      // verifica que inició bien para evitar errores
                      if (_controller == null) return;
                      // agregar el controlador al tabler de animación
                      artboard.addController(_controller!);
                      // vincular variables de la animación con las variables de la clase
                      _isChecking = _controller!.findSMI('isChecking');
                      _isHandsUp = _controller!.findSMI('isHandsUp');
                      _trigSuccess = _controller!.findSMI('trigSuccess');
                      _trigFail = _controller!.findSMI('trigFail');
                      //vincular un numlook
                      _numLook = _controller!.findSMI('numLook');
                  },

                  'animated_login_bear.riv'),
              ),
            // Para separar elementos
            SizedBox(height: 10),
            // Campo de texto para EMAIL
            TextField(
              // foco en el campo de texto
              focusNode: _emailFocus,

                // vincular SMIs a inputs de UI
                onChanged:(value) {
                    // if (_isHandsUp != null){
                    //     // No tapes los ojos al ver el email
                    //     _isHandsUp!.change(false);
                    // }
                    // Si isCHecking es nulo
                    if (_isChecking == null) return;

                    //Activa el modo chismoso
                    _isChecking!.change(true);
                    // implementar numLook
                    // ajustar limites de 0 a 100
                    // 80 es la medida de calibración 
                    final look = (value.length / 80.0 * 100.0).clamp(
                      0.0,
                      100.0
                    ); // clamp es un rango de valores
                    _numLook?.value = look;

                    // debounce: si vuelve a teclear, reinicia el contador
                    // cancela el timer si ya existe
                    _typingDebounce?.cancel();
                    // crear timer 
                    _typingDebounce = Timer(const Duration(seconds: 3), () {
                      // si se cierra la pantalla
                      if (!mounted) return;
                      // mirada neutra
                      _isChecking!.change(false);
                    });
                },

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
              // foco en el campo de texto
              focusNode: _passwordFocus,
              
                // vincular SMIs a inputs de UI
                onChanged:(value) {
                    if (_isChecking != null){
                        // No tapes los ojos al ver el email
                        _isChecking!.change(false);
                    }
                    // // Si _isHandsUp es nulo
                    // if (_isHandsUp == null) return;

                    // //Activa el modo chismoso
                    // _isHandsUp!.change(true);
                },

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
  @override
  void dispose() {
    super.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _typingDebounce?.cancel();
  }
}