import 'package:flutter/material.dart';
import '../models/evento.dart';

class EventoDialog extends StatefulWidget {
  final Evento? evento;
  final void Function(Evento evento) onSave;
  final VoidCallback? onDelete;

  const EventoDialog({this.evento, required this.onSave, this.onDelete, super.key});

  @override
  _EventoDialogState createState() => _EventoDialogState();
}

class _EventoDialogState extends State<EventoDialog> {
  late TextEditingController tituloController;
  late Color color;
  late String tipoJornada;
  late int horaInicio, minutoInicio, horaFin, minutoFin;

  @override
  void initState() {
    super.initState();
    tituloController = TextEditingController(text: widget.evento?.titulo ?? '');
    color = widget.evento?.color ?? Colors.blue;
    tipoJornada = widget.evento?.tipoJornada ?? 'Mañana';
    horaInicio = widget.evento?.horaInicio ?? 0;
    minutoInicio = widget.evento?.minutoInicio ?? 0;
    horaFin = widget.evento?.horaFin ?? 0;
    minutoFin = widget.evento?.minutoFin ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Evento'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tituloController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            DropdownButton<Color>(
              value: color,
              items: const [
                  DropdownMenuItem(value: Colors.blue, child: Text("Azul")),
                  DropdownMenuItem(value: Colors.red, child: Text("Rojo")),
                  DropdownMenuItem(value: Colors.green, child: Text("Verde")),
                  DropdownMenuItem(value: Color.fromARGB(255, 255, 142, 221), child: Text("Rosita")),
                  DropdownMenuItem(value: Colors.white, child: Text("Blanco")),
                  DropdownMenuItem(value: Colors.purple, child: Text("Morado")),
                  DropdownMenuItem(value: Colors.pink, child: Text("Rosa")),
                  DropdownMenuItem(value: Colors.orange, child: Text("Naranja")),
                  DropdownMenuItem(value: Colors.yellow, child: Text("Amarillo")),
                  DropdownMenuItem(value: Colors.black, child: Text("Negro")),
                  DropdownMenuItem(value: Colors.cyan, child: Text("Cyan")),
                  DropdownMenuItem(value: Colors.amber, child: Text("Ambar")),
                  DropdownMenuItem(value: Colors.brown, child: Text("Marron")),
              ],
              onChanged: (value) {
                setState(() {
                  color = value!;
                });
              },
            ),
            DropdownButton<String>(
              value: tipoJornada,
              items: const [
                DropdownMenuItem(value: 'Mañana', child: Text("Mañana")),
                DropdownMenuItem(value: 'Tarde', child: Text("Tarde")),
                DropdownMenuItem(value: 'Partido', child: Text("Partido")),
                DropdownMenuItem(value: 'Vacio', child: Text("Vacío")),
              ],
              onChanged: (value) {
                setState(() {
                  tipoJornada = value!;
                });
              },
            ),
            if (tipoJornada != 'Vacio') ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Hora inicio'),
                      onChanged: (value) => horaInicio = int.tryParse(value) ?? 0,
                      controller: TextEditingController(text: horaInicio.toString()),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Minuto inicio'),
                      onChanged: (value) => minutoInicio = int.tryParse(value) ?? 0,
                      controller: TextEditingController(text: minutoInicio.toString()),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Hora fin'),
                      onChanged: (value) => horaFin = int.tryParse(value) ?? 0,
                      controller: TextEditingController(text: horaFin.toString()),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Minuto fin'),
                      onChanged: (value) => minutoFin = int.tryParse(value) ?? 0,
                      controller: TextEditingController(text: minutoFin.toString()),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      actions: [
        if (widget.onDelete != null)
          TextButton(
            onPressed: widget.onDelete,
            child: const Text('Eliminar'),
          ),
        TextButton(
          onPressed: () {
            final nuevoEvento = Evento(
              tituloController.text,
              color,
              tipoJornada,
              horaInicio: horaInicio,
              minutoInicio: minutoInicio,
              horaFin: horaFin,
              minutoFin: minutoFin,
            );
            widget.onSave(nuevoEvento);
            Navigator.pop(context);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}