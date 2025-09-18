import 'package:flutter/material.dart';
import 'dart:math';

class Principal extends StatefulWidget {
  const Principal({super.key});
  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  static const int rows = 6;
  static const int cols = 4;

  // Fila 3 colores constantes iniciales
  static const List<Color> row3Const = [
    Colors.teal, Colors.indigo, Colors.lime, Colors.cyan,
  ];
  // Fila 5 colores constantes iniciales
  static const List<Color> row5Const = [
    Colors.deepOrange, Colors.blueGrey, Colors.amber, Colors.green,
  ];

  late List<List<Color>> gridColors;
  final _rnd = Random();

  @override
  void initState() {
    super.initState();
    _initGrid();
  }

  void _initGrid() {
    gridColors = List.generate(rows, (r) => List.filled(cols, Colors.white));

    // Fila 1 alternancias entre celdas
    gridColors[0] = [
      Colors.blue,   //azul <-> rojo
      Colors.yellow, //amarillo <-> azul
      Colors.purple, //morado <-> rosa
      Colors.orange, //naranja <-> café
    ];

    // Filas 2,4,6 bloqueadas: gris
    gridColors[1] = List.filled(cols, Colors.grey.shade400); // fila 2
    gridColors[3] = List.filled(cols, Colors.grey.shade400); // fila 4
    gridColors[5] = List.filled(cols, Colors.grey.shade400); // fila 6

    // Fila 3 y 5: colores definidos
    gridColors[2] = List<Color>.from(row3Const); // fila 3
    gridColors[4] = List<Color>.from(row5Const); // fila 5
  }

  bool _isBlockedRow(int r) => r == 1 || r == 3 || r == 5;

  bool _isCellInteractive(int r, int c) {
    if (_isBlockedRow(r)) return false;     // filas 2,4,6
    if (r == 0) return true;                // fila 1: todas las celdas
    if (r == 2) return true;                // fila 3: todas las celdas para swap
    if (r == 4 && c == 0) return true;      // fila 5: solo la 1ra celda
    return false;
  }

  Color _rand() => Color.fromARGB(
    255, _rnd.nextInt(256), _rnd.nextInt(256), _rnd.nextInt(256),
  );

  void _onTap(int r, int c) {
    if (!_isCellInteractive(r, c)) return;

    setState(() {
      if (r == 0) {
        // fila 1
        switch (c) {
          case 0:
            gridColors[r][c] =
            gridColors[r][c] == Colors.blue ? Colors.red : Colors.blue;
            break;
          case 1:
            gridColors[r][c] =
            gridColors[r][c] == Colors.yellow ? Colors.blue : Colors.yellow;
            break;
          case 2:
            gridColors[r][c] =
            gridColors[r][c] == Colors.purple ? Colors.pink : Colors.purple;
            break;
          case 3:
            gridColors[r][c] =
            gridColors[r][c] == Colors.orange ? Colors.brown : Colors.orange;
            break;
        }
      } else if (r == 2) {
        // Fila 3
        if (c == 0 || c == 3) {
          final t = gridColors[r][0];
          gridColors[r][0] = gridColors[r][3];
          gridColors[r][3] = t;
        } else if (c == 1 || c == 2) {
          final t = gridColors[r][1];
          gridColors[r][1] = gridColors[r][2];
          gridColors[r][2] = t;
        }
      } else if (r == 4 && c == 0) {
        // Fila 5
        for (int j = 1; j < cols; j++) {
          gridColors[r][j] = _rand();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: List.generate(rows, (r) {
          return Expanded(
            child: Row(
              children: List.generate(cols, (c) {
                final color = gridColors[r][c];
                final enabled = _isCellInteractive(r, c);
                return Expanded(
                  child: GestureDetector(
                    onTap: enabled ? () => _onTap(r, c) : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: color,
                        border: Border.all(color: Colors.black12, width: 0.5),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ),
    );
  }
}
