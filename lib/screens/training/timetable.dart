import 'package:flutter/material.dart';
import 'package:footballproject/Provider/AuthProvider/auth_provider.dart';
import 'package:footballproject/Provider/TrainingSchedule/trainingScheduleProvider.dart';
import 'package:footballproject/models/weekday.dart';
import 'package:footballproject/screens/training/sessionCard.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _fetchSessions();
  }

  Future<void> _fetchSessions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      final token = authProvider.token;
      if (token != null) {
        await Provider.of<SessionProvider>(context, listen: false)
            .fetchSessions(token);
        print('Sessions fetched successfully');
      } else {
        print('Token is null');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching sessions: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.blue[900],
        title: const Text(
          'Training Schedule',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return _selectedDay != null && isSameDay(_selectedDay!, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (_selectedDay == null ||
                    !isSameDay(_selectedDay!, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blue[100],
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.blue[700],
                  shape: BoxShape.circle,
                ),
                markerSize: 0,
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _buildAppointmentList(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentList(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    final sessions = sessionProvider.sessions;

    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_selectedDay == null) {
      return const Center(child: Text('Select a day to view appointments'));
    }

    final selectedDate = DateTime(
      _selectedDay!.year,
      _selectedDay!.month,
      _selectedDay!.day,
    );

    // Filter sessions based on selected date
    final List<String> weekday = [
      'MONDAY',
      'TUESDAY',
      'WEDNESDAY',
      'THURSDAY',
      'FRIDAY',
      'SATURDAY',
      'SUNDAY'
    ];
    final dayAppointments = sessions.where((session) {
      return session.weekday.index == selectedDate.weekday - 1 &&
          session.isWithinRange(selectedDate, session.schedule.startDate,
              session.schedule.endDate);
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Appointments for ${_formatDate(_selectedDay!)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: dayAppointments.isEmpty
              ? const Center(child: Text('No appointments for this day'))
              : ListView.builder(
                  itemCount: dayAppointments.length,
                  itemBuilder: (context, index) {
                    final appointment = dayAppointments[index];
                    return SessionCard(
                      teacher: appointment.teacher,
                      session: appointment,
                      isLoading: _isLoading,
                      sessionDate: selectedDate,
                    );
                  },
                ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    date1 = DateTime(date1.year, date1.month, date1.day);
    date2 = DateTime(date2.year, date2.month, date2.day);
    return date1 == date2;
  }

  bool isAfter(DateTime date1, DateTime date2) {
    return date1.isAfter(date2);
  }

  bool isBefore(DateTime date1, DateTime date2) {
    return date1.isBefore(date2);
  }
}
