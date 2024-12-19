import 'package:flutter/material.dart';
import 'screens/calendario_screen.dart';

void main() {
  runApp(const MiCalendarioApp());
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