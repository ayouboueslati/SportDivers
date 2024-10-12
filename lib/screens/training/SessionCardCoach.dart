import 'package:flutter/material.dart';
import 'package:sportdivers/components/CustomToast.dart';
import 'package:sportdivers/components/TranslationSessionType.dart';
import 'package:sportdivers/screens/dashboard/CoachDashboardScreen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sportdivers/models/session.dart';
import 'package:sportdivers/models/sessionTypes.dart';
import 'package:sportdivers/models/teacherProfile.dart';

class SessionCardCoach extends StatefulWidget {
  final TeacherProfile teacher;
  final Session session;
  final bool isLoading;
  final DateTime sessionDate;

  const SessionCardCoach({
    Key? key,
    required this.teacher,
    required this.session,
    required this.sessionDate,
    this.isLoading = false,
  }) : super(key: key);

  @override
  _SessionCardCoachState createState() => _SessionCardCoachState();
}

class _SessionCardCoachState extends State<SessionCardCoach> {
  bool isSessionEnded() {
    final now = DateTime.now();
    final endTime = _combineDateTime(widget.sessionDate, widget.session.endTime);
    return now.isAfter(endTime);
  }

  DateTime _combineDateTime(DateTime date, String timeString) {
    // Parse the ISO 8601 string
    DateTime parsedDateTime = DateTime.parse(timeString);

    // Combine the date from sessionDate with the time from parsedDateTime
    return DateTime(
      date.year,
      date.month,
      date.day,
      parsedDateTime.hour,
      parsedDateTime.minute,
      parsedDateTime.second,
    );
  }
  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return _buildShimmer();
    }

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        if (isSessionEnded()) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CoachDashboardScreen(
                sessionDate: widget.sessionDate,
                sessionId: widget.session.id,
                groupId: widget.session.schedule.group?.id ?? '',
              ),
            ),
          );
        } else {
          showReusableToast(
            context: context,
            message: 'Vous ne pouvez accéder au tableau de bord qu\'après la fin de la session.',
            duration: Duration(seconds: 5),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.session.field != null)
                Text(
                  widget.session.field!.designation,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          getIconForSessionType(widget.session.type),
                          size: 18.0,
                          color: Colors.black87,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            translateSessionType(widget.session.type),
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 18.0,
                        color: Colors.black87,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formatSessionTime(widget.session.startTime),
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffECEAFF),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Text(
                          sessionTypeToString(widget.session.type),
                          style: const TextStyle(fontSize: 10, color: Color(0xFF6C5DD3)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 20.0,
                width: 150.0,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 16.0,
                    width: 100.0,
                    color: Colors.grey[300],
                  ),
                  Container(
                    height: 16.0,
                    width: 60.0,
                    color: Colors.grey[300],
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Container(
                height: 20.0,
                width: 80.0,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData getIconForSessionType(Sessiontypes type) {
    switch (type) {
      case Sessiontypes.TRAINING_SESSION:
        return Icons.fitness_center;
      case Sessiontypes.FRIENDLY_GAME:
        return Icons.sports_soccer;
      default:
        return Icons.emoji_events;
    }
  }

  String sessionTypeToString(Sessiontypes type) {
    return type.toString().split('.').last.replaceAll('_', ' ');
  }

  String formatSessionTime(String time) {
    try {
      final DateTime parsedTime = DateTime.parse(time);
      return '${parsedTime.hour}:${parsedTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return time; // Return the original string if parsing fails
    }
  }
}