import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:authenticacion_firebase/service/firebase_auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_passwordController.text != _confirmPasswordController.text) {
        _showError('Las contraseñas no coinciden.');
        return;
      }

      try {
        await _authService.register(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Registro exitoso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } on FirebaseAuthException catch (e) {
        _handleFirebaseError(e.code);
      } catch (e) {
        _showError('Error inesperado. Por favor, inténtelo nuevamente.');
      }
    }
  }

  void _handleFirebaseError(String errorCode) {
    String message;
    switch (errorCode) {
      case 'email-already-in-use':
        message = 'Este correo ya está registrado.';
        break;
      case 'invalid-email':
        message = 'El correo electrónico no es válido.';
        break;
      case 'weak-password':
        message = 'La contraseña es demasiado débil.';
        break;
      default:
        message = 'Ocurrió un error inesperado. Intente nuevamente.';
    }
    _showError(message);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Cabecera con logo o ícono
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blue,
                child: const Icon(
                  Icons.person_add,
                  color: Colors.white,
                  size: 60,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Crear Cuenta',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Por favor, completa los campos para registrarte',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Campo de correo
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Correo Electrónico',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.email),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingrese su correo.';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return 'Por favor, ingrese un correo válido.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          // Campo de contraseña
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingrese su contraseña.';
                              }
                              if (value.length < 6) {
                                return 'La contraseña debe tener al menos 6 caracteres.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          // Campo de confirmar contraseña
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: !_isConfirmPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Confirmar Contraseña',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isConfirmPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isConfirmPasswordVisible =
                                        !_isConfirmPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, confirme su contraseña.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          // Botón de registro
                          ElevatedButton(
                            onPressed: _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 24),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Registrarse',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Enlace a iniciar sesión
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: const Text(
                              '¿Ya tienes cuenta? Inicia sesión',
                              style: TextStyle(color: Colors.blue),
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
  }
}
