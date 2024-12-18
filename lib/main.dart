import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();  // Inicializa Hive para usarlo con Flutter
  Hive.registerAdapter(EventoAdapter());  // Registra el adaptador de la clase Evento
  
  await Hive.openBox<Evento>('eventos');  // Abre una caja llamada 'eventos'
  
  runApp(const MiCalendarioApp());
}

class EventoAdapter extends TypeAdapter<Evento> {
  @override
  final typeId = 0;

  @override
  Evento read(BinaryReader reader) {
    return Evento(
      reader.readString(),
      reader.read(),
      reader.readString(),
      horaInicio: reader.readInt(),
      minutoInicio: reader.readInt(),
      horaFin: reader.readInt(),
      minutoFin: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, Evento obj) {
    writer.writeString(obj.titulo);
    writer.write(obj.color);
    writer.writeString(obj.tipoJornada);
    writer.writeInt(obj.horaInicio);
    writer.writeInt(obj.minutoInicio);
    writer.writeInt(obj.horaFin);
    writer.writeInt(obj.minutoFin);
  }
}

class MiCalendarioApp extends StatelessWidget {
  const MiCalendarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendario de Eventos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalendarioScreen(),
    );
  }
}

class CalendarioScreen extends StatefulWidget {
  const CalendarioScreen({super.key});

  @override
  _CalendarioScreenState createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  final Map<DateTime, List<Evento>> _eventos = {}; // Mapa de eventos por día

   int totalHorasTrabajadas() {
    int totalHoras = 0;
    int mesActual = _selectedDay.month;
    int anioActual = _selectedDay.year;

    _eventos.forEach((day, eventos) {
      if (day.month == mesActual && day.year == anioActual) {
        for (var evento in eventos) {
          totalHoras += evento.horasTrabajadas;
        }
      }
    });

    return totalHoras;
  }

  @override
  void initState() {
    super.initState();
    _loadEventos();
  }

  // Cargar los eventos desde Hive
  void _loadEventos() async {
    var box = await Hive.openBox<Evento>('eventos'); // Abrir la caja
    setState(() {
      // Limpiar los eventos actuales
      _eventos.clear();
      
      // Recorrer los eventos guardados en Hive
      for (var evento in box.values) {
        // Crear la fecha a partir de la fecha del evento (solo año, mes y día)
        DateTime fecha = DateTime(evento.horaInicio, evento.minutoInicio);
        
        // Si no hay eventos en ese día, crear una nueva lista
        if (_eventos[fecha] == null) {
          _eventos[fecha] = [];
        }
        
        // Agregar el evento a la lista de ese día
        _eventos[fecha]!.add(evento);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario de Ane'),
        actions: [
          IconButton(
            icon: const Icon(Icons.timelapse),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Total de Horas Trabajadas'),
                  content: Text(
                      'Total de horas trabajadas este mes: ${totalHorasTrabajadas()} horas'),
                  actions: [
                    TextButton(
                      child: const Text('Cerrar'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _selectedDay,
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
              headerStyle: const HeaderStyle(
               formatButtonVisible: false,  // Esto oculta el botón "Two Weeks"
             ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _eventos[_selectedDay]?.length ?? 0,
              itemBuilder: (context, index) {
                final evento = _eventos[_selectedDay]![index];
                return ListTile(
                  title: Text(evento.titulo),
                  subtitle:
                      Text("Horas trabajadas: ${((((evento.horaFin * 60) + evento.minutoFin) - ((evento.horaInicio * 60) + evento.minutoInicio)) ~/ 60)}h:${((((evento.horaFin * 60) + evento.minutoFin) - ((evento.horaInicio * 60) + evento.minutoInicio)) % 60)}min"),
                  tileColor: evento.color,
                  onTap: () => _mostrarDialogoEvento(evento, index),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarDialogoNuevoEvento(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _mostrarDialogoNuevoEvento() {
  showDialog(
    context: context,
    builder: (context) {
      String tituloEvento = '';
      Color colorEvento = Colors.blue;
      String tipoJornada = 'Mañana';
      int horaInicio = 0;
      int minutoInicio = 0;
      int horaFin = 0;
      int minutoFin = 0;

      TextEditingController tituloController = TextEditingController();
      TextEditingController horaInicioController = TextEditingController();
      TextEditingController minutoInicioController = TextEditingController();
      TextEditingController horaFinController = TextEditingController();
      TextEditingController minutoFinController = TextEditingController();

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Nuevo Evento'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tituloController,
                  onChanged: (value) => tituloEvento = value,
                  decoration: const InputDecoration(labelText: 'Título del Evento'),
                ),
                DropdownButton<Color>(
                  value: colorEvento,
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
                      colorEvento = value ?? Colors.blue;
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
                if (tipoJornada == 'Partido' || tipoJornada == 'Mañana' || tipoJornada == 'Tarde') ...[
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Hora inicio'),
                          controller: horaInicioController,
                          onChanged: (value) => horaInicio = int.tryParse(value) ?? 0,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Minuto inicio'),
                          controller: minutoInicioController,
                          onChanged: (value) => minutoInicio = int.tryParse(value) ?? 0,
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
                          controller: horaFinController,
                          onChanged: (value) => horaFin = int.tryParse(value) ?? 0,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Minuto fin'),
                          controller: minutoFinController,
                          onChanged: (value) => minutoFin = int.tryParse(value) ?? 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text('Añadir'),
                onPressed: () {
                  final nuevoEvento = Evento(
                    tituloEvento,
                    colorEvento,
                    tipoJornada,
                    horaInicio: horaInicio,
                    minutoInicio: minutoInicio,
                    horaFin: horaFin,
                    minutoFin: minutoFin,
                  );

                  // Agregar el evento a la caja de Hive
                  var box = Hive.box<Evento>('eventos');
                    box.add(nuevoEvento);  // Añadir el evento a Hive

                  setState(() {
                    if (_eventos[_selectedDay] == null) {
                      _eventos[_selectedDay] = [];
                    }
                    _eventos[_selectedDay]!.add(nuevoEvento);
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    },
  );
}

void _mostrarDialogoEvento(Evento evento, int index) {
  showDialog(
    context: context,
    builder: (context) {
      String tituloEvento = evento.titulo;
      Color colorEvento = evento.color;
      String tipoJornada = evento.tipoJornada;
      int horaInicio = evento.horaInicio;
      int minutoInicio = evento.minutoInicio;
      int horaFin = evento.horaFin;
      int minutoFin = evento.minutoFin;

      TextEditingController tituloController = TextEditingController(text: tituloEvento);
      TextEditingController horaInicioController = TextEditingController(text: horaInicio.toString());
      TextEditingController minutoInicioController = TextEditingController(text: minutoInicio.toString());
      TextEditingController horaFinController = TextEditingController(text: horaFin.toString());
      TextEditingController minutoFinController = TextEditingController(text: minutoFin.toString());

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Editar Evento'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tituloController,
                  onChanged: (value) => tituloEvento = value,
                  decoration: const InputDecoration(labelText: 'Título del Evento'),
                ),
                DropdownButton<Color>(
                  value: colorEvento,
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
                      colorEvento = value ?? Colors.blue;
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
                if (tipoJornada == 'Partido' || tipoJornada == 'Mañana' || tipoJornada == 'Tarde') ...[
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Hora inicio'),
                          controller: horaInicioController,
                          onChanged: (value) => horaInicio = int.tryParse(value) ?? 0,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Minuto inicio'),
                          controller: minutoInicioController,
                          onChanged: (value) => minutoInicio = int.tryParse(value) ?? 0,
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
                          controller: horaFinController,
                          onChanged: (value) => horaFin = int.tryParse(value) ?? 0,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Minuto fin'),
                          controller: minutoFinController,
                          onChanged: (value) => minutoFin = int.tryParse(value) ?? 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Eliminar'),
                onPressed: () {
                  // Eliminar el evento de Hive
                  var box = Hive.box<Evento>('eventos');
                    box.deleteAt(index);  // Eliminar el evento por índice en la caja
                  setState(() {
                    _eventos[_selectedDay]?.removeAt(index);
                  });
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Guardar'),
                onPressed: () {
                  setState(() {
                    _eventos[_selectedDay]?[index] = Evento(
                      tituloEvento,
                      colorEvento,
                      tipoJornada,
                      horaInicio: horaInicio,
                      minutoInicio: minutoInicio,
                      horaFin: horaFin,
                      minutoFin: minutoFin,
                    );
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    },
  );
}

}

@HiveType(typeId: 0)
class Evento {
  @HiveField(0)
  final String titulo;
  @HiveField(1)
  final Color color;
  @HiveField(2)
  final String tipoJornada;
  @HiveField(3)
  final int horaInicio;
  @HiveField(4)
  final int minutoInicio;
  @HiveField(5)
  final int horaFin;
  @HiveField(6)
  final int minutoFin;

  Evento(
    this.titulo,
    this.color,
    this.tipoJornada, {
    this.horaInicio = 0,
    this.minutoInicio = 0,
    this.horaFin = 0,
    this.minutoFin = 0,
  });

  int get horasTrabajadas {
    if (tipoJornada == 'Partido' || tipoJornada == 'Mañana' || tipoJornada == 'Tarde') {
      final totalMinutos = (horaFin * 60 + minutoFin) - (horaInicio * 60 + minutoInicio);
     return totalMinutos >= 0 ? totalMinutos ~/ 60 : 0;
    }
    return 0;
  }
}