import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerScreen extends StatefulWidget {
  @override
  _ColorPickerScreenState createState() => _ColorPickerScreenState();
}

class _ColorPickerScreenState extends State<ColorPickerScreen> {
  Color pickerColor = Color(0xff443a49); // Color inicial del picker

  // Función para cambiar el color
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona un color'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Mostrar el color actual en el picker
            ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: changeColor,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Regresa el color seleccionado al archivo principal
                Navigator.pop(context, pickerColor);
              },
              child: Text('Seleccionar color'),
            ),
          ],
        ),
      ),
    );
  }
}