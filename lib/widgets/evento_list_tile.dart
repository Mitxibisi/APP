
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Selecciona un color'),
                      content: SingleChildScrollView(
                        child: ColorPickerScreen(
                          onColorChanged: (color) {
                            // Cambiar el color en el principal cuando se seleccione uno
                            setState(() {
                              currentColor = color;
                            });
                          },
                        ),
                      ),
                            
