import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:sportdivers/Provider/AuthProvider/auth_provider.dart';
import 'package:sportdivers/Provider/TrainingSchedule/trainingScheduleProvider.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
import 'package:sportdivers/screens/training/SessionCardCoach.dart';

class TrainingScheduleScreenCoach extends StatefulWidget {
  static const String id = 'Training_Schedule_Coach_Screen';

  @override
  _TrainingScheduleScreenCoachState createState() => _TrainingScheduleScreenCoachState();
}

class _TrainingScheduleScreenCoachState extends State<TrainingScheduleScreenCoach> {
  DateTime _selectedDay = DateTime.now();
  bool _isLoading = true;
  bool _showMonthView = true;

  @override
  void initState() {
    super.initState();
    _fetchSessions();
  }

  Future<void> _fetchSessions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
      final token = authProvider.token;
      if (token != null) {
        await Provider.of<SessionProvider>(context, listen: false).fetchSessions(token);
        print('Sessions fetched successfully');
      } else {
        print('Token is null');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la récupération des sessions : $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onDaySelected(DateTime selectedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _showMonthView = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            if (_showMonthView)
              Expanded(
                child: Consumer<SessionProvider>(
                  builder: (context, sessionProvider, child) {
                    return MonthView(
                      controller: EventController(),
                      onCellTap: (events, date) {
                        _onDaySelected(date);
                      },
                      cellBuilder: (date, events, isToday, isInMonth, hideDaysNotInMonth) {
                        bool hasSession = sessionProvider.sessions.any((session) =>
                        session.weekday.index == date.weekday - 1 &&
                            session.isWithinRange(date, session.schedule.startDate, session.schedule.endDate));

                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[200]!),
                            color: isToday ? DailozColor.lightblue.withOpacity(0.2) : (isInMonth ? Colors.white : Colors.grey[100]),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    '${date.day}',
                                    style: TextStyle(
                                      color: isInMonth ? (isToday ? Colors.blue[800] : Colors.black87) : Colors.grey,
                                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              if (hasSession)
                                Positioned(
                                  bottom: 4,
                                  right: 4,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: DailozColor.lightred,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                      headerStyle: HeaderStyle(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                          ),
                        ),
                        headerTextStyle: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      weekDayBuilder: (dayIndex) {
                        final weekDays = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
                        return Container(
                          alignment: Alignment.center,
                          child: Text(
                            weekDays[dayIndex],
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                      onHeaderTitleTap: null,
                    );
                  },
                ),
              )
            else
              Expanded(
                child: Column(
                  children: [
                    EasyDateTimeLine(
                      initialDate: _selectedDay,
                      onDateChange: (selectedDate) {
                        setState(() {
                          _selectedDay = selectedDate;
                        });
                      },
                      headerProps: const EasyHeaderProps(
                        monthPickerType: MonthPickerType.switcher,
                        dateFormatter: DateFormatter.fullDateDMY(),
                      ),
                      dayProps: EasyDayProps(
                        dayStructure: DayStructure.dayStrDayNum,
                        activeDayStyle: DayStyle(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.blue[100]!,
                                Colors.blue[900]!,
                              ],
                            ),
                          ),
                        ),
                      ),
                      locale: "fr_FR",
                    ),
                    Expanded(
                      child: _buildTimelineList(context),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineList(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    final sessions = sessionProvider.sessions;

    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    final selectedDate = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);

    final dayAppointments = sessions.where((session) {
      return session.weekday.index == selectedDate.weekday - 1 &&
          session.isWithinRange(selectedDate, session.schedule.startDate, session.schedule.endDate);
    }).toList();

    dayAppointments.sort((a, b) => a.startTime.compareTo(b.startTime));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Rendez-vous pour ${_formatDate(_selectedDay)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: dayAppointments.isEmpty
              ? Center(child: Text('Aucun rendez-vous pour ce jour'))
              : ListView.builder(
            itemCount: dayAppointments.length,
            itemBuilder: (context, index) {
              final appointment = dayAppointments[index];
              return TimelineTile(
                alignment: TimelineAlign.manual,
                lineXY: 0.1,
                isFirst: index == 0,
                isLast: index == dayAppointments.length - 1,
                indicatorStyle: IndicatorStyle(
                  width: 20,
                  color: DailozColor.lightblue,
                  padding: const EdgeInsets.all(6),
                ),
                endChild: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SessionCardCoach(
                    teacher: appointment.teacher,
                    session: appointment,
                    isLoading: _isLoading,
                    sessionDate: selectedDate,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final formatter = DateFormat('yyyy-MM-dd', 'fr_FR');
    return formatter.format(date);
  }

  String _formatTime(String time) {
    try {
      final DateTime parsedTime = DateTime.parse(time);
      return DateFormat('HH:mm').format(parsedTime);
    } catch (e) {
      return time;
    }
  }
}