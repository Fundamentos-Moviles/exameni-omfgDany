import 'package:flutter/material.dart';
import 'dart:async'; // temporizadores
import 'dart:math';
import 'constantes.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});
  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  // Variables del Tablero
  int rows = 4;
  int cols = 4;
  late List<List<Color>> gridColors;
  final _random = Random();

  // Variables de Estado
  late List<List<bool>> gridRevealed; // qué celdas están visibles
  final Color hiddenColor = Colors.blueGrey.shade200; // Color para las celdas ocultas
  (int, int)? firstSelection; // coordenadas (r, c) de la primera selección
  bool isCheckingPair = false; // Bloquea clics mientras se verifica un par
  int foundPairs = 0; // Contador de pares para la condición de victoria
  bool isGameOver = false; // Indica si el juego ha terminado

  @override
  void initState() {
    super.initState();
    _generateMemoramaGrid();
  }

  int _generateRandomGridDimension() {
    const List<int> possibleDimensions = [2, 4, 6, 8];
    return possibleDimensions[_random.nextInt(possibleDimensions.length)];
  }

  void _generateMemoramaGrid() {
    // Reinicio completo del estado
    setState(() {
      isGameOver = false;
      foundPairs = 0;
      firstSelection = null;
      isCheckingPair = false;

      // Generación de dimensiones y colores (lógica sin cambios)
      do {
        rows = _generateRandomGridDimension();
        cols = _generateRandomGridDimension();
      } while (rows * cols > colores32.length * 2);

      final int numCells = rows * cols;
      final int numPairs = numCells ~/ 2;
      final List<Color> availableColors = List<Color>.from(colores32);
      final List<Color> selectedColors = [];
      for (int i = 0; i < numPairs; i++) {
        int randomIndex = _random.nextInt(availableColors.length);
        selectedColors.add(availableColors[randomIndex]);
        availableColors.removeAt(randomIndex);
      }
      final List<Color> pairedColors = [];
      for (Color color in selectedColors) {
        pairedColors.add(color);
        pairedColors.add(color);
      }
      pairedColors.shuffle();
      gridColors = List.generate(rows, (r) {
        return List.generate(cols, (c) {
          int index = r * cols + c;
          return pairedColors[index];
        });
      });

      // 1. Mostrar todas las celdas al principio
      gridRevealed = List.generate(rows, (_) => List.filled(cols, true));

      // 2. Después de 3 segundos, ocultarlas todas
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) { // Comprobar si el widget sigue en pantalla
          setState(() {
            gridRevealed = List.generate(rows, (_) => List.filled(cols, false));
          });
        }
      });
    });
  }


  void _onTap(int r, int c) {
    if (isCheckingPair || isGameOver || gridRevealed[r][c]) {
      return;
    }

    setState(() {
      gridRevealed[r][c] = true; // Revelar

      if (firstSelection == null) {
        // Es la PRIMERA celda seleccionada del par
        firstSelection = (r, c);
      } else {
        // Es la SEGUNDA celda seleccionada, comparar
        isCheckingPair = true;
        final (r1, c1) = firstSelection!;
        final (r2, c2) = (r, c);

        if (gridColors[r1][c1] == gridColors[r2][c2]) {
          // Correcto
          foundPairs++;
          firstSelection = null;
          isCheckingPair = false;

          // Condición de Victoria
          if (foundPairs == (rows * cols) ~/ 2) {
            isGameOver = true;
            _showSnackBar("¡Felicidades, ganaste!", Colors.green);
          }
        } else {
          // error
          // Esperar 2 segundos
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                gridRevealed[r1][c1] = false;
                gridRevealed[r2][c2] = false;
                firstSelection = null;
                isCheckingPair = false;
              });
            }
          });
        }
      }
    });
  }

  // rendirse y mostrar el tablero
  void _giveUp() {
    setState(() {
      isGameOver = true;
      gridRevealed = List.generate(rows, (_) => List.filled(cols, true)); // Revelar todo
    });
    _showSnackBar("Perdiste, Se muestra el tablero completo", Colors.red);
  }

  // Helper implementado directamente aqui para mostrar un SnackBar
  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memorama ($rows x $cols) By: Daniel Pacheco Martinez 353968', selectionColor: Colors.white),
        backgroundColor: Colors.amber,
        actions: [
          // Botón para rendirse
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            tooltip: 'Me rindo',
            onPressed: () {
              if (!isGameOver) _giveUp();
            },
          ),
          // Botón para reiniciar
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Reiniciar Tablero',
            onPressed: () {
              // Ahora esta función ya reinicia todo el estado del juego
              _generateMemoramaGrid();
            },
          ),
        ],
      ),
      body: Column(
        children: List.generate(rows, (r) {
          return Expanded(
            child: Row(
              children: List.generate(cols, (c) {
                // Decidir colores mostrados
                final color = gridRevealed[r][c] ? gridColors[r][c] : hiddenColor;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onTap(r, c),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black26, width: 1),
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