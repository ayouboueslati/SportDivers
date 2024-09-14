import 'package:flutter/material.dart';
import 'package:footballproject/Provider/AuthProvider/auth_provider.dart';
import 'package:footballproject/Provider/TrainingSchedule/trainingScheduleProvider.dart';
import 'package:footballproject/models/weekday.dart';
import 'package:footballproject/screens/training/SessionCardCoach.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class TrainingScheduleScreen extends StatefulWidget {
  static const String id = 'Training_Schedule_Screen';

  @override
  _TrainingScheduleScreenState createState() => _TrainingScheduleScreenState();
}

class _TrainingScheduleScreenState extends State<TrainingScheduleScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
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
        SnackBar(
            content: Text('Erreur lors de la récupération des sessions : $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<DateTime> _getSessionDays(DateTime day) {
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final sessions = sessionProvider.sessions;

    return sessions.where((session) {
      return session.weekday.index == (day.weekday - 1) % 7 &&
          _isWithinRange(day, session.schedule.startDate, session.schedule.endDate);
    }).map((_) => day).toList();
  }

  bool _isWithinRange(DateTime date, DateTime start, DateTime end) {
    return !date.isBefore(start) && !date.isAfter(end);
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
          'Horaire d\'Entraînement',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _calendarFormat == CalendarFormat.month
                  ? _buildFullScreenCalendar()
                  : _buildWeekViewWithSessions(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullScreenCalendar() {
    return TableCalendar(
      eventLoader: _getSessionDays,
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2050, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return _selectedDay != null && isSameDay(_selectedDay!, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
          _calendarFormat = CalendarFormat.week;
        });
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
        markerSize: 8,
        markersMaxCount: 3,
        markerDecoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
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
    );
  }

  Widget _buildWeekViewWithSessions() {
    return Column(
      children: [
        TableCalendar(
          eventLoader: _getSessionDays,
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2050, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return _selectedDay != null && isSameDay(_selectedDay!, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
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
            markerSize: 8,
            markersMaxCount: 3,
            markerDecoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: true,
            titleCentered: true,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: _buildAppointmentList(),
        ),
      ],
    );
  }

  Widget _buildAppointmentList() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_selectedDay == null) {
      return const Center(
          child: Text('Sélectionnez un jour pour voir les rendez-vous'));
    }

    final sessionProvider = Provider.of<SessionProvider>(context);
    final sessions = sessionProvider.sessions;

    final dayAppointments = sessions.where((session) {
      return session.weekday.index == (_selectedDay!.weekday - 1) % 7 &&
          _isWithinRange(_selectedDay!, session.schedule.startDate,
              session.schedule.endDate);
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Rendez-vous pour ${_formatDate(_selectedDay!)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: dayAppointments.isEmpty
              ? const Center(child: Text('Aucun rendez-vous pour ce jour'))
              : ListView.builder(
            itemCount: dayAppointments.length,
            itemBuilder: (context, index) {
              final appointment = dayAppointments[index];
              return SessionCardCoach(
                teacher: appointment.teacher,
                session: appointment,
                isLoading: _isLoading,
                sessionDate: _selectedDay!,
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
}