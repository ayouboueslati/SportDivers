import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CoachDashboardScreen extends StatefulWidget {
  static const String id = 'coach_dashboard_screen';

  @override
  _CoachDashboardScreenState createState() => _CoachDashboardScreenState();
}

class _CoachDashboardScreenState extends State<CoachDashboardScreen> {
  final List<Map<String, String>> players = [
    {"name": "Black Widow", "image": "assets/images/black-widow.jpg"},
    {"name": "Captain America", "image": "assets/images/captain-america.jpg"},
    {"name": "Captain Marvel", "image": "assets/images/captain-marvel.jpg"},
    {"name": "Hulk", "image": "assets/images/hulk.jpg"},
    {"name": "Ironman", "image": "assets/images/ironman.jpeg"},
    {"name": "Nick Fury", "image": "assets/images/nick-fury.jpg"},
    {"name": "Scarlet Witch", "image": "assets/images/scarlet-witch.jpg"},
    {"name": "Spiderman", "image": "assets/images/spiderman.jpg"},
    {"name": "Thor", "image": "assets/images/thor.png"},
  ];

  final Map<String, double> ratings = {};
  DateTime? trainingDate;
  TimeOfDay? trainingTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coach Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Training Date Picker
              ListTile(
                title: Text(trainingDate == null
                    ? 'Select Training Date'
                    : 'Training Date: ${DateFormat('yyyy-MM-dd').format(trainingDate!)}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2022),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      trainingDate = pickedDate;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),

              // Training Time Picker
              ListTile(
                title: Text(trainingTime == null
                    ? 'Select Training Time'
                    : 'Training Time: ${trainingTime!.format(context)}'),
                trailing: Icon(Icons.access_time),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      trainingTime = pickedTime;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),

              const Text(
                'Rate Players',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: players.map((player) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(player['image']!),
                      ),
                      title: Text(player['name']!),
                      trailing: DropdownButton<double>(
                        value: ratings[player['name']],
                        hint: Text('Rate'),
                        items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                            .map((rating) => DropdownMenuItem<double>(
                                  value: rating.toDouble(),
                                  child: Text(rating.toString()),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            ratings[player['name']!] = value!;
                          });
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Button to navigate to the CreateFormation screen
            ],
          ),
        ),
      ),
    );
  }
}
