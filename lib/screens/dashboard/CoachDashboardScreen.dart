import 'dart:ui';

import 'package:flutter/material.dart';

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

  final Map<String, Map<String, double>> ratings = {};
  final Map<String, bool> attendance = {};
  DateTime? trainingDate;
  TimeOfDay? trainingTime;

  @override
  void initState() {
    super.initState();
    for (var player in players) {
      attendance[player['name']!] = false;
      ratings[player['name']!] = {
        'Note 1': 0,
        'Note 2': 0,
        'Note 3': 0,
        'Note 4': 0,
      };
    }
  }

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
        color: const Color(0xFFF6F6F6),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Adhérents',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _buildPlayersList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayersList() {
    return ListView.builder(
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(player['image']!),
            ),
            title: Text(
              player['name']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
              children: [
                const Text('Présent: '),
                Switch(
                  value: attendance[player['name']]!,
                  onChanged: (bool value) {
                    setState(() {
                      attendance[player['name']!] = value;
                    });
                  },
                  activeColor: Colors.blue[900],
                ),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () => _showRatingDialog(context, player['name']!),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Note',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showRatingDialog(BuildContext context, String playerName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Noter $playerName',
                style: TextStyle(color: Colors.blue[900]),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildRatingSlider('Note 1', playerName, setState),
                    _buildRatingSlider('Note 2', playerName, setState),
                    _buildRatingSlider('Note 3', playerName, setState),
                    _buildRatingSlider('Note 4', playerName, setState),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child:
                      Text('Fermer', style: TextStyle(color: Colors.blue[900])),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900]),
                  onPressed: () {
                    // Here you would typically save the ratings
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Sauvegarder',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildRatingSlider(
      String aspect, String playerName, StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(aspect,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blue[900])),
        Slider(
          value: ratings[playerName]![aspect]!,
          min: 0,
          max: 10,
          divisions: 10,
          label: ratings[playerName]![aspect]!.round().toString(),
          activeColor: Colors.blue[900],
          inactiveColor: Colors.blue[100],
          onChanged: (double value) {
            setState(() {
              ratings[playerName]![aspect] = value;
            });
          },
        ),
      ],
    );
  }
}
