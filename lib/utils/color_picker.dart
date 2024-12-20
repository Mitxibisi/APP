// create some values
Color pickerColor = Color(0xff443a49);
Color currentColor = Color(0xff443a49);

// ValueChanged<Color> callback
void changeColor(Color color) {
  setState(() => pickerColor = color);
}

// raise the [showDialog] widget
showDialog(
  context: context,
  child: AlertDialog(
    title: const Text('Pick a color!'),
    content: SingleChildScrollView(
      child: ColorPicker(
        pickerColor: pickerColor,
        onColorChanged: changeColor,
      ),
      // Use Material color picker:
      //
      // child: MaterialPicker(
      //   pickerColor: pickerColor,
      //   onColorChanged: changeColor,
      //   showLabel: true, // only on portrait mode
      // ),
      //
      // Use Block color picker:
      //
      // child: BlockPicker(
      //   pickerColor: currentColor,
      //   onColorChanged: changeColor,
      // ),
      //
      // child: MultipleChoiceBlockPicker(
      //   pickerColors: currentColors,
      //   onColorsChanged: changeColors,
      // ),
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
  ),
)