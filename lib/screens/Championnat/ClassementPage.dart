import 'package:flutter/material.dart';
import 'package:sportdivers/screens/Championnat/ButeursAssistsClassment.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_fontstyle.dart';

class ClassementPage extends StatelessWidget {
  static String id = 'Classement_Page';


  final List<Map<String, dynamic>> standings = List.generate(
    20,
        (index) => {
      'position': index + 1,
      'team': 'Team ${String.fromCharCode(65 + index)}',
      'points': 100 - (index * 3),
      'logo':
      'assets/team_logos/team_${String.fromCharCode(65 + index).toLowerCase()}.png',
    },
  );

  ClassementPage({Key? key}) : super(key: key);

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
        title: Text("Classement", style: hsSemiBold.copyWith(fontSize: 22)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: height / 70),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: width / 20),
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
                children: [
                  _buildHeader(height, width),
                  Expanded(
                    child: ListView.builder(
                      itemCount: standings.length,
                      itemBuilder: (context, index) => _buildTeamRow(
                          context, standings[index], index + 1, height, width),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: height / 70),
        ],
      ),
    );
  }

  Widget _buildHeader(double height, double width) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: height / 50, horizontal: width / 20),
      decoration: BoxDecoration(
        color: Colors.blue[700],
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Text('Pos',
                  style: hsSemiBold.copyWith(
                      fontSize: 16, color: DailozColor.white))),
          Expanded(
              flex: 4,
              child: Text('Équipe',
                  style: hsSemiBold.copyWith(
                      fontSize: 16, color: DailozColor.white))),
          Expanded(
              flex: 1,
              child: Text('Pts',
                  style: hsSemiBold.copyWith(
                      fontSize: 16, color: DailozColor.white))),
        ],
      ),
    );
  }

  Widget _buildTeamRow(BuildContext context, Map<String, dynamic> team,
      int index, double height, double width) {
    Color rowColor =
    index % 2 == 0 ? DailozColor.bggray.withOpacity(0.3) : DailozColor.white;
    Color textColor = DailozColor.black;

    if (index <= 3) {
      rowColor = DailozColor.lightred.withOpacity(0.1);
      textColor = DailozColor.lightred;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ButeursAssistsClassment(teamName: team['team']),
          ),
        );
      },
      child: Container(
        padding:
        EdgeInsets.symmetric(vertical: height / 70, horizontal: width / 20),
        decoration: BoxDecoration(
          color: rowColor,
          borderRadius: index == standings.length
              ? BorderRadius.vertical(bottom: Radius.circular(20))
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                team['position'].toString(),
                style: hsSemiBold.copyWith(fontSize: 16, color: textColor),
              ),
            ),
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: DailozColor.grey,
                    backgroundImage:
                    AssetImage('assets/images/icons/default_avatar.png'),
                    foregroundImage: AssetImage(team['logo']),
                  ),
                  SizedBox(width: width / 30),
                  Expanded(
                    child: Text(
                      team['team'],
                      style: hsMedium.copyWith(fontSize: 16, color: textColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                team['points'].toString(),
                style: hsSemiBold.copyWith(fontSize: 16, color: textColor),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}