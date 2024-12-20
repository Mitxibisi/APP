import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerScreen extends StatefulWidget {
  final ValueChanged<Color> onColorChanged; // Callback para manejar el color seleccionado

  const ColorPickerScreen({super.key, required this.onColorChanged});

  @override
  _ColorPickerScreenState createState() => _ColorPickerScreenState();
}

class _ColorPickerScreenState extends State<ColorPickerScreen> {
  Color pickerColor = Color(0xff443a49); // Color inicial del picker

  // Función para cambiar el color
  void changeColor(Color color) {
    setState(() => pickerColor = color);
    widget.onColorChanged(color); // Llama a la función pasada desde el widget principal
  }

  @override
  Widget build(BuildContext context) {
    return ColorPicker(
      pickerColor: pickerColor,
      onColorChanged: changeColor,  // Actualiza el color al cambiarlo
    );
  }
}