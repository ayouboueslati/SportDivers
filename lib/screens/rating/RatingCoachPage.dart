import 'package:flutter/material.dart';

class RatingCoachPage extends StatefulWidget {
  static const String id = 'Rating_Coach_Page';

  @override
  _RatingCoachPageState createState() => _RatingCoachPageState();
}

class _RatingCoachPageState extends State<RatingCoachPage> {
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

  final Map<String, bool> attendance = {};
  final Map<String, List<double>> ratings = {};

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
          'Coach Rating',
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
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  "Hello coach, thank you for evaluating your trainees",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
                ),
                const SizedBox(height: 20),
                _buildPlayersList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayersList() {
    return Column(
      children: players.map((player) {
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(player['image']!),
            ),
            title: Text(
              player['name']!,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Row(
              children: [
                Text('Present', style: TextStyle(fontSize: 16)),
                SizedBox(width: 10),
                Switch(
                  value: attendance[player['name']] ?? false,
                  onChanged: (value) {
                    setState(() {
                      attendance[player['name']!] = value;
                    });
                  },
                  activeColor: Colors.blue[900],
                  activeTrackColor: Colors.blue[200],
                ),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () {
                _showRatingDialog(player['name']!);
              },
              child: Text('Note'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[900],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showRatingDialog(String playerName) {
    showDialog(
      context: context,
      builder: (context) {
        final currentRatings = ratings[playerName] ?? [5.0, 5.0, 5.0, 5.0];
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Rate $playerName',
                  style: TextStyle(
                      color: Colors.blue[900], fontWeight: FontWeight.bold)),
              content: Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildRatingField('Skill', currentRatings[0], (value) {
                      setState(() {
                        currentRatings[0] = value;
                      });
                    }),
                    _buildRatingField('Stamina', currentRatings[1], (value) {
                      setState(() {
                        currentRatings[1] = value;
                      });
                    }),
                    _buildRatingField('Discipline', currentRatings[2], (value) {
                      setState(() {
                        currentRatings[2] = value;
                      });
                    }),
                    _buildRatingField('Teamwork', currentRatings[3], (value) {
                      setState(() {
                        currentRatings[3] = value;
                      });
                    }),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child:
                      Text('Cancel', style: TextStyle(color: Colors.grey[600])),
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      ratings[playerName] = currentRatings;
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildRatingField(
      String label, double rating, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 8,
              child: Slider(
                value: rating,
                min: 1.0,
                max: 10.0,
                divisions: 9,
                label: rating.toStringAsFixed(1),
                onChanged: onChanged,
                activeColor: Colors.blue[900],
                inactiveColor: Colors.blue[100],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[900],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  rating.toStringAsFixed(1),
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
