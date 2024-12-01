import 'package:flutter/material.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_fontstyle.dart';

class PlayersClassment extends StatelessWidget {
  final String teamName;

  // Extended sample data for top scorers and assist providers
  final List<Map<String, dynamic>> topScorers = [
    {'name': 'Player A', 'goals': 15, 'photoUrl': 'assets/images/ronaldinho.png'},
    {'name': 'Player B', 'goals': 12, 'photoUrl': 'assets/images/ronaldinho.png'},
    {'name': 'Player C', 'goals': 10, 'photoUrl': 'assets/images/ronaldinho.png'},
    {'name': 'Player D', 'goals': 9, 'photoUrl': 'assets/images/ronaldinho.png'},
    {'name': 'Player E', 'goals': 8, 'photoUrl': 'assets/images/ronaldinho.png'},
    {'name': 'Player F', 'goals': 7, 'photoUrl': 'assets/images/ronaldinho.png'},
    {'name': 'Player G', 'goals': 6, 'photoUrl': 'assets/images/ronaldinho.png'},
  ];

  final List<Map<String, dynamic>> topAssists = [
    {'name': 'Player X', 'assists': 10, 'photoUrl': 'assets/images/ronaldinho.png'},
    {'name': 'Player Y', 'assists': 8, 'photoUrl': 'assets/images/ronaldinho.png'},
    {'name': 'Player Z', 'assists': 7, 'photoUrl': 'assets/images/ronaldinho.png'},
    {'name': 'Player W', 'assists': 6, 'photoUrl': 'assets/images/ronaldinho.png'},
    {'name': 'Player V', 'assists': 5, 'photoUrl': 'assets/images/ronaldinho.png'},
    {'name': 'Player U', 'assists': 4, 'photoUrl': 'assets/images/ronaldinho.png'},
    {'name': 'Player T', 'assists': 3, 'photoUrl': 'assets/images/ronaldinho.png'},
  ];

  PlayersClassment({Key? key, required this.teamName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      backgroundColor: DailozColor.bggray,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            splashColor: DailozColor.transparent,
            highlightColor: DailozColor.transparent,
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: height / 20,
              width: height / 20,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: DailozColor.white,
                  boxShadow: const [
                    BoxShadow(color: DailozColor.textgray, blurRadius: 5)
                  ]),
              child: Padding(
                padding: EdgeInsets.only(left: width / 56),
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 18,
                  color: DailozColor.black,
                ),
              ),
            ),
          ),
        ),
        title: Text(teamName, style: hsSemiBold.copyWith(fontSize: 22)),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: height / 40)),
          _buildSection(context, "Classement des buteurs", topScorers, 'goals'),
          SliverToBoxAdapter(child: SizedBox(height: height / 40)),
          _buildSection(context, "Classement des passes décisives", topAssists, 'assists'),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Map<String, dynamic>> data, String statKey) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 20),
        decoration: BoxDecoration(
          color: DailozColor.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: DailozColor.textgray.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(title, style: hsSemiBold.copyWith(fontSize: 18, color: DailozColor.black)),
            ),
            Table(
              columnWidths: {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(4),
                2: FlexColumnWidth(1.3),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: DailozColor.lightblue.withOpacity(0.1)),
                  children: [
                    TableCell(child: _buildHeaderCell("Rank")),
                    TableCell(child: _buildHeaderCell("Player")),
                    TableCell(child: _buildHeaderCell(statKey.capitalize())),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 250, // Fixed height for the scrollable area
              child: ListView(
                children: [
                  Table(
                    columnWidths: {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(4),
                      2: FlexColumnWidth(1.3),
                    },
                    children: data.asMap().entries.map((entry) {
                      int index = entry.key;
                      var player = entry.value;
                      return TableRow(
                        children: [
                          TableCell(child: _buildCell("${index + 1}")),
                          TableCell(child: _buildPlayerCell(player['name'], player['photoUrl'])),
                          TableCell(child: _buildCell("${player[statKey]}", color: DailozColor.lightred)),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, style: hsSemiBold.copyWith(fontSize: 16, color: DailozColor.black)),
    );
  }

  Widget _buildCell(String text, {Color color = DailozColor.black}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, style: hsMedium.copyWith(fontSize: 14, color: color), textAlign: TextAlign.center),
    );
  }

  Widget _buildPlayerCell(String name, String photoUrl) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(photoUrl),
            radius: 20,
            onBackgroundImageError: (exception, stackTrace) {
              // If the image fails to load, show a placeholder
              // return Icon(Icons.person);
            },
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(name, style: hsMedium.copyWith(fontSize: 14, color: DailozColor.black)),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}