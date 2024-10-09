import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:sportdivers/Provider/AuthProvider/auth_provider.dart';
import 'package:sportdivers/Provider/TrainingSchedule/trainingScheduleProvider.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_fontstyle.dart';
import 'package:sportdivers/screens/training/sessionCard.dart';

class TrainingScheduleScreen extends StatefulWidget {
  static const String id = 'Training_Schedule_Screen';

  @override
  _TrainingScheduleScreenState createState() => _TrainingScheduleScreenState();
}

class _TrainingScheduleScreenState extends State<TrainingScheduleScreen> {
  DateTime _selectedDay = DateTime.now();
  bool _isLoading = true;
  double height = 0.00;
  double width = 0.00;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    //   appBar: AppBar(
    //   leading: Padding(
    //     padding: const EdgeInsets.all(10),
    //     child: InkWell(
    //       splashColor: DailozColor.transparent,
    //       highlightColor: DailozColor.transparent,
    //       onTap: () => Navigator.pop(context),
    //       child: Container(
    //         height: height / 20,
    //         width: height / 20,
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(5),
    //           color: DailozColor.white,
    //           boxShadow: [
    //             BoxShadow(
    //                 color: DailozColor.grey.withOpacity(0.3), blurRadius: 5)
    //           ],
    //         ),
    //         child: Padding(
    //           padding: EdgeInsets.only(left: width / 56),
    //           child: Icon(
    //             Icons.arrow_back_ios,
    //             size: 18,
    //             color: DailozColor.black,
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    //   title: Text(
    //     'Horaire d\'Entraînement',
    //     style: hsBold.copyWith(
    //       color: DailozColor.black,
    //       fontSize: 22,
    //     ),
    //   ),
    //   backgroundColor: DailozColor.white,
    //   elevation: 0,
    // ),
      body: SafeArea(
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
              dayProps: const EasyDayProps(
                dayStructure: DayStructure.dayStrDayNum,
                activeDayStyle: DayStyle(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff3371FF),
                        Color(0xff8426D6),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _buildTimelineList(context),
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
              ? const Center(child: Text('Aucun rendez-vous pour ce jour'))
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
                  child: SessionCard(
                    teacher: appointment.teacher,
                    session: appointment,
                    isLoading: _isLoading,
                    sessionDate: selectedDate,
                  ),
                ),
                // startChild: Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                //   child: Text(
                //     _formatTime(appointment.startTime),
                //     style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //       color: Theme.of(context).primaryColor,
                //     ),
                //   ),
                // ),
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

  String _formatTime(String time) {
    try {
      final DateTime parsedTime = DateTime.parse(time);
      return DateFormat('HH:mm').format(parsedTime);
    } catch (e) {
      return time;
    }
  }
}