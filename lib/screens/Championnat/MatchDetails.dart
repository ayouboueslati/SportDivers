import 'package:flutter/material.dart';
import 'package:sportdivers/models/MatchModel.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_fontstyle.dart';

class MatchDetailsPage extends StatefulWidget {
  static String id = 'Match_Details_Page';

  final Match match;

  const MatchDetailsPage({Key? key, required this.match}) : super(key: key);

  @override
  _MatchDetailsPageState createState() => _MatchDetailsPageState();
}

class _MatchDetailsPageState extends State<MatchDetailsPage> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['DÉTAILS', 'ÉQUIPES', 'CLASSEMENTS'];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
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
        title:
            Text("Détails du match", style: hsSemiBold.copyWith(fontSize: 22)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width / 36, vertical: height / 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height / 96),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${widget.match.date} ${widget.match.time}",
                      style: hsRegular.copyWith(fontSize: 14)),
                ],
              ),
              SizedBox(height: height / 40),
              Container(
                padding: EdgeInsets.all(width / 36),
                decoration: BoxDecoration(
                  color: DailozColor.bggray,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Image.asset(widget.match.homeTeamLogo,
                              width: width / 6, height: width / 6),
                          SizedBox(height: height / 96),
                          Text(widget.match.homeTeam,
                              style: hsMedium.copyWith(fontSize: 14),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                    Text('-', style: hsSemiBold.copyWith(fontSize: 24)),
                    Expanded(
                      child: Column(
                        children: [
                          Image.asset(widget.match.awayTeamLogo,
                              width: width / 6, height: width / 6),
                          SizedBox(height: height / 96),
                          Text(widget.match.awayTeam,
                              style: hsMedium.copyWith(fontSize: 14),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height / 36),
              Container(
                decoration: BoxDecoration(
                  color: DailozColor.bggray,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: _tabs.asMap().entries.map((entry) {
                    int idx = entry.key;
                    String tab = entry.value;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = idx;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: height / 66),
                          decoration: BoxDecoration(
                            color: _selectedIndex == idx
                                ? DailozColor.appcolor
                                : DailozColor.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            tab,
                            style: hsMedium.copyWith(
                              fontSize: 14,
                              color: _selectedIndex == idx
                                  ? DailozColor.white
                                  : DailozColor.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: height / 36),
              _buildTabContent(height, width),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(double height, double width) {
    switch (_selectedIndex) {
      case 0:
        return _buildMatchDetails(height, width);
      case 1:
        return _buildTeamDetails(height, width);
      case 2:
        return _buildLeagueStandings(height, width);
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildMatchDetails(double height, double width) {
    return Container(
      padding: EdgeInsets.all(width / 36),
      decoration: BoxDecoration(
        color: DailozColor.bggray,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Détails du match',
              style:
                  hsSemiBold.copyWith(fontSize: 18, color: DailozColor.black)),
          SizedBox(height: height / 66),
          Text('Date: ${widget.match.date}',
              style: hsRegular.copyWith(fontSize: 14)),
          Text('Heure: ${widget.match.time}',
              style: hsRegular.copyWith(fontSize: 14)),
          Text('Stade: ${widget.match.place}',
              style: hsRegular.copyWith(fontSize: 14)),
          SizedBox(height: height / 66),
          Text('Résumé du match:',
              style: hsMedium.copyWith(fontSize: 16, color: DailozColor.black)),
          SizedBox(height: height / 96),
          Text(
            'Le match entre ${widget.match.homeTeam} et ${widget.match.awayTeam} promet d\'être passionnant. Les deux équipes sont en forme et cherchent à gagner des points importants pour le classement.',
            style: hsRegular.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamDetails(double height, double width) {
    List<Map<String, dynamic>> teamsData = [
      {
        'name': widget.match.homeTeam,
        'players': List.generate(
            20,
            (index) => {
                  'name': 'Player ${index + 1}',
                  'score': 20 - index,
                  'yellowCards': index % 3,
                  'redCards': index % 10 == 0 ? 1 : 0,
                  'assists': (15 - index).clamp(0, 15),
                }),
      },
      {
        'name': widget.match.awayTeam,
        'players': List.generate(
            20,
            (index) => {
                  'name': 'Player ${String.fromCharCode(65 + index)}',
                  'score': 20 - index,
                  'yellowCards': index % 4,
                  'redCards': index % 12 == 0 ? 1 : 0,
                  'assists': (18 - index).clamp(0, 18),
                }),
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: DailozColor.bggray,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: widget.match.homeTeam),
                Tab(text: widget.match.awayTeam),
              ],
              labelColor: DailozColor.appcolor,
              unselectedLabelColor: DailozColor.textgray,
              indicatorColor: DailozColor.appcolor,
            ),
            SizedBox(
              height: height * 0.6, // Adjust this value as needed
              child: TabBarView(
                children: teamsData.map((team) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(width / 36),
                          child: Text(
                            'Classement des joueurs',
                            style: hsSemiBold.copyWith(
                                fontSize: 18, color: DailozColor.black),
                          ),
                        ),
                        Table(
                          columnWidths: {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(3),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(1),
                            4: FlexColumnWidth(1),
                            5: FlexColumnWidth(1),
                          },
                          children: [
                            TableRow(
                              decoration:
                                  BoxDecoration(color: DailozColor.grey),
                              children: [
                                _buildTableCell('Pos', isHeader: true),
                                _buildTableCell('Nom', isHeader: true),
                                _buildTableCell('Buts', isHeader: true),
                                _buildTableCell('CJ', isHeader: true),
                                _buildTableCell('CR', isHeader: true),
                                _buildTableCell('Passes', isHeader: true),
                              ],
                            ),
                            ...team['players'].asMap().entries.map((entry) {
                              int idx = entry.key;
                              var player = entry.value;
                              return TableRow(
                                decoration: BoxDecoration(
                                  color: idx.isEven
                                      ? DailozColor.white
                                      : DailozColor.bggray,
                                ),
                                children: [
                                  _buildTableCell('${idx + 1}'),
                                  _buildTableCell(player['name']),
                                  _buildTableCell('${player['score']}'),
                                  _buildTableCell('${player['yellowCards']}'),
                                  _buildTableCell('${player['redCards']}'),
                                  _buildTableCell('${player['assists']}'),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Text(
        text,
        style: isHeader
            ? hsSemiBold.copyWith(fontSize: 12, color: DailozColor.black)
            : hsRegular.copyWith(fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLeagueStandings(double height, double width) {
    List<Map<String, dynamic>> standings = List.generate(
      20,
      (index) => {
        'position': index + 1,
        'team': 'Team ${String.fromCharCode(65 + index)}',
        'points': 100 - (index * 3),
        'logo':
            'assets/team_logos/team_${String.fromCharCode(65 + index).toLowerCase()}.png',
      },
    );

    return Container(
      decoration: BoxDecoration(
        color: DailozColor.bggray,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: standings.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              padding: EdgeInsets.symmetric(
                  vertical: height / 66, horizontal: width / 36),
              decoration: BoxDecoration(
                color: DailozColor.grey,
                borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Text('Pos',
                          style: hsSemiBold.copyWith(
                              fontSize: 14, color: DailozColor.black))),
                  Expanded(
                      flex: 4,
                      child: Text('Équipe',
                          style: hsSemiBold.copyWith(
                              fontSize: 14, color: DailozColor.black))),
                  Expanded(
                      flex: 1,
                      child: Text('Pts',
                          style: hsSemiBold.copyWith(
                              fontSize: 14, color: DailozColor.black))),
                ],
              ),
            );
          }
          var team = standings[index - 1];
          return Container(
            padding: EdgeInsets.symmetric(
                vertical: height / 86, horizontal: width / 36),
            decoration: BoxDecoration(
              color: index.isOdd ? DailozColor.white : DailozColor.bggray,
              borderRadius: index == standings.length
                  ? BorderRadius.vertical(bottom: Radius.circular(14))
                  : null,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(team['position'].toString(),
                      style: hsMedium.copyWith(fontSize: 14)),
                ),
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: DailozColor.grey,
                        backgroundImage: AssetImage(
                            'assets/images/icons/default_avatar.png'),
                        foregroundImage: AssetImage(team['logo']),
                      ),
                      SizedBox(width: width / 36),
                      Expanded(
                          child: Text(team['team'],
                              style: hsRegular.copyWith(fontSize: 14))),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(team['points'].toString(),
                      style: hsMedium.copyWith(fontSize: 14)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
