import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/evento.dart';
import '../widgets/evento_dialog.dart';

class CalendarioScreen extends StatefulWidget {
  const CalendarioScreen({super.key});

  @override
  _CalendarioScreenState createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  final Map<DateTime, List<Evento>> _eventos = {};

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prueba'),
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

            //Inicio estilo del calendario
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 247, 115, 159),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 197, 217),
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                defaultTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                holidayTextStyle: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                outsideDaysVisible: true, // Ocultar días de meses anteriores/posteriores
              ),
              headerStyle: const HeaderStyle(
                titleTextStyle: TextStyle(fontSize: 18),
                formatButtonVisible: false, // Oculta el botón para cambiar el formato
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.blue),
                rightChevronIcon: Icon(Icons.chevron_right, color: Colors.blue),
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekendStyle: TextStyle( color: Colors.red),
                weekdayStyle: TextStyle( color: Colors.black),
              ),
            //Final estilo calendario

          ),
          Expanded(
            child: ListView.builder(
              itemCount: _eventos[_selectedDay]?.length ?? 0,
              itemBuilder: (context, index) {
                final evento = _eventos[_selectedDay]![index];
                return ListTile(
                  title: Text(evento.titulo),
                  subtitle: Text("Horas trabajadas: ${evento.horasTrabajadas}"),
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
      builder: (context) => EventoDialog(
        onSave: (nuevoEvento) {
          setState(() {
            if (_eventos[_selectedDay] == null) {
              _eventos[_selectedDay] = [];
            }
            _eventos[_selectedDay]!.add(nuevoEvento);
          });
        },
      ),
    );
  }

  void _mostrarDialogoEvento(Evento evento, int index) {
    showDialog(
      context: context,
      builder: (context) => EventoDialog(
        evento: evento,
        onSave: (eventoEditado) {
          setState(() {
            _eventos[_selectedDay]?[index] = eventoEditado;
          });
        },
        onDelete: () {
          setState(() {
            _eventos[_selectedDay]?.removeAt(index);
          });
        },
      ),
    );
  }
}