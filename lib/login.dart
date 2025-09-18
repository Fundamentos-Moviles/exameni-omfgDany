import 'package:flutter/material.dart';
import 'package:examenp1_353968/constantes.dart' as cons;
import 'principal.dart'; // Para el botón de "Ingresar"
import 'listas.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool mostrarOcultar = true;
  final usuario = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(size.height * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'INICIAR SESIÓN',
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: size.height * 0.05),
            buildTextFormField('Usuario', false, Icons.person),
            SizedBox(height: size.height * 0.03),
            buildTextFormField('Contraseña', true, Icons.lock),
            SizedBox(height: size.height * 0.05),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: cons.azul2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                fixedSize: Size(size.width * 0.75, 50),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                if (usuario.text.isNotEmpty && password.text.isNotEmpty) {
                  // Validación de usuario y contraseña (puedes usar cons.usuario y cons.pass)
                  if (usuario.text == cons.usuario && password.text == cons.pass) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Principal()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Usuario o contraseña incorrectos.'),
                        backgroundColor: Colors.orangeAccent,
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, ingresa usuario y contraseña.'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              child: const Text('Ingresar'),
            ),
            SizedBox(height: size.height * 0.03), // Espacio antes del nuevo botón

            // --- BOTÓN ALTERNATIVO PARA VER LISTAS ---
            TextButton(
              onPressed: () {
                Navigator.push( // Usamos push para poder volver al Login
                  context,
                  MaterialPageRoute(builder: (context) => const Listas()),
                );
              },
              child: Text(
                'Ver Lista de Usuarios',
                style: TextStyle(color: cons.azul4, fontSize: 16),
              ),
            ),
            // --- FIN BOTÓN ALTERNATIVO ---
          ],
        ),
      ),
    );
  }

  Widget buildTextFormField(String text, bool esPassword, IconData prefixIcon) {
    // ... (este método se mantiene igual que en la versión anterior)
    return TextFormField(
      controller: esPassword ? password : usuario,
      obscureText: esPassword ? mostrarOcultar : false,
      decoration: InputDecoration(
        filled: true,
        fillColor: cons.blanco,
        prefixIcon: Icon(prefixIcon, color: Colors.grey[600]),
        suffixIcon: esPassword
            ? IconButton(
          icon: Icon(
            mostrarOcultar ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey[600],
          ),
          onPressed: () {
            setState(() {
              mostrarOcultar = !mostrarOcultar;
            });
          },
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: cons.azul2, width: 1.5),
        ),
        hintText: text,
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      ),
      style: const TextStyle(fontSize: 16),
    );
  }

  @override
  void dispose() {
    usuario.dispose();
    password.dispose();
    super.dispose();
  }
}
