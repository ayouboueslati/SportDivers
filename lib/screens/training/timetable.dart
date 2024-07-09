import 'package:flutter/material.dart';

class TrainingScheduleScreen extends StatelessWidget {
  const TrainingScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'May 5, 2020',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.calendar_today, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                final dayNumbers = [4, 5, 6, 7, 8, 9, 10];
                return Column(
                  children: [
                    Text(days[index], style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(
                      dayNumbers[index].toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            index == 5 ? FontWeight.bold : FontWeight.normal,
                        color: index == 5 ? Colors.blue : Colors.black,
                      ),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildScheduleItem(
                    context,
                    time: '7:00 AM',
                    title: 'Wakeup',
                    description: 'Early wakeup from bed and fresh',
                  ),
                  _buildScheduleItem(
                    context,
                    time: '8:00 AM',
                    title: 'Morning Exercise',
                    description: '4 types of exercise',
                  ),
                  _buildScheduleItem(
                    context,
                    time: '9:00 AM',
                    title: 'Meeting',
                    description: 'Zoom call, Discuss team task for the day',
                    participants: [
                      'assets/images/cr7.jpg',
                      'assets/images/cr7.jpg',
                      'assets/images/cr7.jpg',
                      'assets/images/cr7.jpg',
                    ],
                  ),
                  _buildScheduleItem(
                    context,
                    time: '10:00 AM',
                    title: 'Breakfast',
                    description:
                        'Morning breakfast with bread, banana, egg bowl, and tea',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(
    BuildContext context, {
    required String time,
    required String title,
    required String description,
    List<String>? participants,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 80,
            child: Text(time, style: const TextStyle(fontSize: 16)),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color:
                    participants != null ? Colors.blue[50] : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(fontSize: 14)),
                  if (participants != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: participants.map((avatar) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: CircleAvatar(
                            backgroundImage: AssetImage(avatar),
                            radius: 12,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
