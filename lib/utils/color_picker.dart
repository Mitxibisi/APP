import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerExample extends StatefulWidget {
  @override
  _ColorPickerExampleState createState() => _ColorPickerExampleState();
}

class _ColorPickerExampleState extends State<ColorPickerExample> {
  // Variable para el color seleccionado
  Color pickerColor = Color(0xff443a49); // Color inicial para el color picker
  Color currentColor = Color(0xff443a49); // Color actual seleccionado

  // Callback para actualizar el color con el color picker
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  // Método para abrir el selector de color
  void openColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: changeColor,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                setState(() => currentColor = pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selector de Color'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Mostrar un botón para abrir el selector de color
            ElevatedButton(
              onPressed: openColorPicker,
              child: const Text('Elegir color personalizado'),
            ),

            // Mostrar el color seleccionado
            Container(
              width: 100,
              height: 100,
              color: currentColor,
            ),
          ],
        ),
      ),
    );
  }
}
  