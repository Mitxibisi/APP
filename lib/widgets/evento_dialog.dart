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
  late String titulo;
  late Color color;
  late String tipoJornada;

  @override
  void initState() {
    super.initState();
    titulo = widget.evento?.titulo ?? '';
    color = widget.evento?.color ?? Colors.blue;
    tipoJornada = widget.evento?.tipoJornada ?? 'Mañana';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Evento'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Título'),
            onChanged: (value) => titulo = value,
          ),
          // Otros campos...
        ],
      ),
      actions: [
        if (widget.onDelete != null)
          TextButton(
            onPressed: widget.onDelete,
            child: const Text('Eliminar'),
          ),
        TextButton(
          onPressed: () {
            final evento = Evento(titulo, color, tipoJornada);
            widget.onSave(evento);
            Navigator.pop(context);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}