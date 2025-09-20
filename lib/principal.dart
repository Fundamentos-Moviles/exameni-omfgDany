import 'package:flutter/material.dart';
import 'dart:math';
import 'constantes.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});
  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  // Variables de inicialización de Memorama
  int rows = 4; // tamaño inicializado, cambiará
  int cols = 4;
  late List<List<Color>> gridColors;
  final _random = Random();

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
      Color chosenColor = availableColors[randomIndex];
      selectedColors.add(chosenColor);
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
  }

// Verificar comportamiento
  void _onTap(int r, int c) {
    print('Celda presionada: ($r, $c) con color ${gridColors[r][c]}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
// Dentro de tu método build, en el Scaffold:
      appBar: AppBar(
        title: Text('Memorama ($rows x $cols) By: Daniel Pacheco Martinez 353968', selectionColor: Colors.white),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Reiniciar Tablero',
            onPressed: () {
              setState(() {
                _generateMemoramaGrid();
              });
            },
          ),
        ],
      ),
      body: Column(

        children: List.generate(rows, (r) {
          return Expanded(
            child: Row(
              children: List.generate(cols, (c) {
                final color = gridColors[r][c];
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