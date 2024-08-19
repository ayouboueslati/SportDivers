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
        title: const Text(
          'Coach Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
      ),
      body: Container(
        color:const Color(0xFFF6F6F6),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildDateTimePicker(
                  title: 'Training Date',
                  value: trainingDate == null
                      ? 'Select Training Date'
                      : DateFormat('yyyy-MM-dd').format(trainingDate!),
                  icon: Icons.calendar_today,
                  onTap: _selectDate,
                ),
                const SizedBox(height: 20),
                _buildDateTimePicker(
                  title: 'Training Time',
                  value: trainingTime == null
                      ? 'Select Training Time'
                      : trainingTime!.format(context),
                  icon: Icons.access_time,
                  onTap: _selectTime,
                ),
                const SizedBox(height: 30),
                _buildSectionTitle('Rate Players'),
                const SizedBox(height: 20),
                _buildPlayersList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimePicker({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(color: Colors.grey[700]),
        ),
        trailing: Icon(icon, color: Colors.blue[900]),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.blue[900],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPlayersList() {
    return Column(
      children: players.map((player) {
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(player['image']!),
            ),
            title: Text(
              player['name']!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButton<double>(
                value: ratings[player['name']],
                hint: Text('Rate'),
                underline: SizedBox(),
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
          ),
        );
      }).toList(),
    );
  }

  void _selectDate() async {
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
  }

  void _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        trainingTime = pickedTime;
      });
    }
  }
}