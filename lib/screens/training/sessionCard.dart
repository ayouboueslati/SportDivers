import 'package:flutter/material.dart';
import 'package:footballproject/components/TranslationSessionType.dart';
import 'package:footballproject/screens/training/rateSession.dart';
import 'package:shimmer/shimmer.dart';
import 'package:footballproject/models/session.dart';
import 'package:footballproject/models/sessionTypes.dart';
import 'package:footballproject/models/teacherProfile.dart';

class SessionCard extends StatefulWidget {
  final TeacherProfile teacher;
  final Session session;
  final bool isLoading;
  final DateTime sessionDate;

  const SessionCard({
    Key? key,
    required this.teacher,
    required this.session,
    required this.sessionDate,
    this.isLoading = false,
  }) : super(key: key);

  @override
  _SessionCardState createState() => _SessionCardState();
}

class _SessionCardState extends State<SessionCard> {
  @override
  Widget build(BuildContext context) {
    // Debugging profile picture URL
    if (widget.teacher.profilePicture != null) {
      print('Profile Picture URL: ${widget.teacher.profilePicture}');
    } else {
      print('Profile Picture URL is null');
    }

    if (widget.isLoading) {
      return _buildShimmer();
    }

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return RateSessionDialog(
              session: widget.session,
              sessionDate: widget.sessionDate,
            );
          },
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: _getCardColor(widget.session.type),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Teacher's Name and Profile Picture
              Row(
                children: [
                  // Profile Picture
                  CircleAvatar(
                    radius: 24.0,
                    backgroundImage: widget.teacher.profilePicture != null &&
                        widget.teacher.profilePicture!.isNotEmpty
                        ? NetworkImage(widget.teacher.profilePicture!)
                        : const AssetImage('assets/images/icons/default_avatar.png')
                    as ImageProvider,
                    backgroundColor: Colors.grey[300],
                    onBackgroundImageError: (_, __) {
                      // Handle the error, e.g., logging or providing a fallback image
                    },
                  ),

                  const SizedBox(width: 8.0),
                  // First and Last Name
                  Expanded(
                    child: Text(
                      '${widget.teacher.firstName} ${widget.teacher.lastName}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              // Field Name
              if (widget.session.field != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    widget.session.field!.designation,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              const SizedBox(height: 8.0),
              // Session Type and Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Session Type
                  Row(
                    children: [
                      Icon(
                        getIconForSessionType(widget.session.type),
                        size: 18.0,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        translateSessionType(widget.session.type),
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  // Session Time (HH:mm)
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 18.0,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        formatSessionTime(widget.session.startTime),
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shimmer for Teacher's Name
              Row(
                children: [
                  // Shimmer for Profile Picture
                  CircleAvatar(
                    radius: 24.0,
                    backgroundColor: Colors.grey[300],
                  ),
                  const SizedBox(width: 8.0),
                  // Shimmer for First and Last Name
                  Expanded(
                    child: Container(
                      height: 20.0,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              // Shimmer for Field Name
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  height: 16.0,
                  width: 100.0,
                  color: Colors.grey[300],
                ),
              ),
              const SizedBox(height: 8.0),
              // Shimmer for Session Type and Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Shimmer for Session Type
                  Row(
                    children: [
                      Icon(
                        Icons.account_circle,
                        size: 18.0,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(width: 4.0),
                      Container(
                        height: 16.0,
                        width: 100.0,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                  // Shimmer for Session Time
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 18.0,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(width: 4.0),
                      Container(
                        height: 16.0,
                        width: 60.0,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                ],
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

  Color _getCardColor(Sessiontypes type) {
    switch (type) {
      case Sessiontypes.TRAINING_SESSION:
        return Colors.blue[700]!; // Blue for training
      case Sessiontypes.FRIENDLY_GAME:
        return Colors.green[600]!; // Green for friendly games
      default:
        return Colors.orange[800]!; // Orange for other session types
    }
  }
}
