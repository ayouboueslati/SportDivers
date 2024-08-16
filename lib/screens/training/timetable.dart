import 'package:flutter/material.dart';
import 'package:footballproject/components/AppDrawer.dart';
import 'package:table_calendar/table_calendar.dart';

class TrainingScheduleScreen extends StatefulWidget {
  static const String id = 'Training_Schedule_Screen';
  @override
  _TrainingScheduleScreenState createState() => _TrainingScheduleScreenState();
}

class _TrainingScheduleScreenState extends State<TrainingScheduleScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<RendezVous>> _appointments = {};

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    super.initState();

    // Create DateTime objects for specific dates
    final date1 = DateTime(2024, 8, 1);
    final date2 = DateTime(2024, 8, 2);
    final date3 = DateTime(2024, 8, 5);
    final date4 = DateTime(2024, 8, 15);
    final date5 = DateTime(2024, 8, 27);
    final date6 = DateTime(2024, 8, 11);

    _appointments = {
      date1: [
        RendezVous("Lionel Messi", "Training Session", "09:00", "90 min"),
        RendezVous("Cristiano Ronaldo", "Media Interview", "11:00", "30 min"),
        RendezVous("LeBron James", "Fitness Training", "13:00", "60 min"),
      ],
      date2: [
        RendezVous("Roger Federer", "Tennis Practice", "10:00", "120 min"),
        RendezVous("Serena Williams", "Press Conference", "12:00", "45 min"),
      ],
      date3: [
        RendezVous("Tom Brady", "Team Meeting", "09:00", "60 min"),
        RendezVous("Usain Bolt", "Speed Training", "11:00", "45 min"),
        RendezVous("Michael Phelps", "Swimming Practice", "14:00", "120 min"),
      ],
      date4: [
        RendezVous("Rafael Nadal", "Match Preparation", "08:30", "90 min"),
        RendezVous("Simone Biles", "Gymnastics Routine", "11:00", "60 min"),
        RendezVous("Novak Djokovic", "Recovery Session", "13:00", "45 min"),
      ],
      date5: [
        RendezVous("Tiger Woods", "Golf Training", "09:00", "90 min"),
        RendezVous("Michael Jordan", "Charity Event", "11:30", "120 min"),
        RendezVous("Lewis Hamilton", "Track Practice", "15:00", "60 min"),
      ],
      date6: [
        RendezVous("Kobe Bryant", "Film Session", "10:00", "45 min"),
        RendezVous("Naomi Osaka", "Mental Coaching", "12:00", "30 min"),
        RendezVous("Shaquille O'Neal", "Endorsement Shoot", "14:00", "90 min"),
      ],
    };


    // Set initial selected and focused day
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60,
        shadowColor: Colors.grey.withOpacity(0.3),
        elevation: 5,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.blue[900],
        title:const Text(
          'Training Schedule',
          style: TextStyle(color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 26

          ),
        ),
      ),
      //drawer: AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },
              eventLoader: (day) {
                return _appointments[DateTime(day.year, day.month, day.day)] ??
                    [];
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                selectedDecoration:const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                markerSize: 0, // Set marker size to 0 to hide default markers
                markerDecoration:const BoxDecoration(
                    color: Colors.transparent), // Make markers transparent
              ),
              headerStyle:const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  final events =
                      _appointments[DateTime(day.year, day.month, day.day)] ??
                          [];
                  if (events.isNotEmpty) {
                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue[900],
                        // Light blue color for days with appointments
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  return null; // Return null to use default appearance for days without appointments
                },
                markerBuilder: (context, date, events) =>
                    Container(), // Return an empty container for markers
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _buildAppointmentList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentList() {
    if (_selectedDay == null) {
      return Center(child: Text('Sélectionnez un jour pour voir les rendez-vous'));
    }
    final selectedDate =
    DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
    List<RendezVous> dayAppointments = _appointments[selectedDate] ?? [];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Appointment for ${_formatDate(_selectedDay!)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: dayAppointments.isEmpty
              ? Center(child: Text('Aucun rendez-vous pour ce jour'))
              : ListView.builder(
            itemCount: dayAppointments.length,
            itemBuilder: (context, index) {
              RendezVous appointment = dayAppointments[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    appointment.nomClient,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    '${appointment.service}\n${appointment.heure} (${appointment.duree})',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  trailing:
                  const Icon(Icons.arrow_forward_ios, color: Colors.black),
                  onTap: () => _showAppointmentDetails(appointment),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAppointmentDetails(RendezVous appointment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Détails du rendez-vous',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Client', appointment.nomClient),
              _buildDetailRow('Service', appointment.service),
              _buildDetailRow('Heure', appointment.heure),
              _buildDetailRow('Durée', appointment.duree),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                'Fermer',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

class RendezVous {
  final String nomClient;
  final String service;
  final String heure;
  final String duree;

  RendezVous(this.nomClient, this.service, this.heure, this.duree);
}

bool isSameDay(DateTime? a, DateTime? b) {
  if (a == null || b == null) {
    return false;
  }
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
