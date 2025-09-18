import 'package:flutter/material.dart';
// Quita la importación directa de cons si ya no la necesitas aquí directamente
// import 'package:flutter3/constantes.dart' as cons;
import 'package:examenp1_353968/utils/singleton.dart'; // <--- IMPORTANTE: Importa tu Singleton
import 'package:examenp1_353968/constantes.dart' as cons; // Mantenemos esto para los colores por ahora

class Listas extends StatefulWidget {
  const Listas({super.key});

  @override
  State<Listas> createState() => _ListasState();
}

class _ListasState extends State<Listas> {
  // Obtener la instancia del Singleton.
  // Esto se puede hacer aquí o directamente en el build, pero hacerlo aquí
  // una vez es un poco más limpio si lo vas a usar múltiples veces en el build.
  final Singleton _singleton = Singleton();

  // Función para forzar la reconstrucción del widget, útil si modificas
  // la lista desde otra parte y quieres que esta pantalla se actualice.
  // Para una actualización automática más robusta, se usaría un gestor de estado (Provider, Riverpod, BLoC).
  void _actualizarLista() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuarios (Singleton)'),
        backgroundColor: cons.azul1, // Todavía usamos cons para colores
        foregroundColor: cons.blanco,
        actions: [
          // Botón de ejemplo para añadir un usuario y ver la actualización
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              // Ejemplo de cómo añadir un nuevo usuario a través del Singleton
              String nuevoId = (_singleton.listUsuarios.length + 10).toString(); // ID simple de ejemplo
              _singleton.agregarUsuario("$nuevoId#Usuario#Nuevo#pass#01/01/24#1");
              _actualizarLista(); // Llama a setState para reconstruir y mostrar el nuevo usuario
            },
            tooltip: 'Añadir Usuario Ejemplo',
          )
        ],
      ),
      body: ListView.builder(
        // Ahora leemos desde la lista del Singleton
        itemCount: _singleton.listUsuarios.length,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        itemBuilder: (BuildContext context, int index) {
          // Obtener los datos del usuario desde la lista del Singleton
          final usuarioData = _singleton.listUsuarios[index].toString().split('#');

          if (usuarioData.length < 6) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              color: Colors.red[100],
              child: const Text('Datos incompletos en Singleton', textAlign: TextAlign.center),
            );
          }

          final String id = usuarioData[0];
          final String nombre = usuarioData[1];
          final String apellidos = usuarioData[2];
          final String contrasena = usuarioData[3];
          final String fechaNac = usuarioData[4];
          final String nombreCompleto = '$nombre $apellidos';

          return Container(
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[350]!),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // --- FILA 1: ID (izquierda) y Nombre (derecha) ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ID: $id',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      nombreCompleto,
                      style: TextStyle(color: cons.azul4, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // --- FILA 2: Contraseña (centrada) ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Contraseña: $contrasena',
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // --- FILA 3: Fecha (izquierda) y Iconos (derecha) ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nacimiento: $fechaNac',
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            print('Editar presionado - ID: $id, Nombre: $nombreCompleto (desde Singleton)');
                            // Aquí podrías navegar a una pantalla de edición pasando el id
                            // y luego, al volver, llamar a _actualizarLista() si algo cambió.
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            child: Icon(Icons.edit, color: Colors.black54, size: 22),
                          ),
                        ),
                        const SizedBox(width: 12),
                        InkWell(
                          onTap: () {
                            print('Eliminar presionado - ID: $id, Nombre: $nombreCompleto (desde Singleton)');
                            // Eliminar el usuario a través del Singleton
                            _singleton.eliminarUsuarioPorIndice(index); // O usar eliminarUsuario(id)
                            _actualizarLista(); // Llama a setState para reconstruir la lista
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            child: Icon(Icons.delete, color: Colors.red, size: 22),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

