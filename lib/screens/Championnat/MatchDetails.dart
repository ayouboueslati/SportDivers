import 'package:flutter/material.dart';
import 'package:sportdivers/models/tournamentModel.dart';
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
        title: Text("Détails du match", style: hsSemiBold.copyWith(fontSize: 22)),
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
                  Text(
                    "${widget.match.date.day}/${widget.match.date.month}/${widget.match.date.year} ${widget.match.date.hour}:${widget.match.date.minute}",
                    style: hsRegular.copyWith(fontSize: 14),
                  ),
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
                          Image.network(
                            widget.match.firstTeam.photo,
                            width: width / 6,
                            height: width / 6,
                          ),
                          SizedBox(height: height / 96),
                          Text(
                            widget.match.firstTeam.designation,
                            style: hsMedium.copyWith(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Text('-', style: hsSemiBold.copyWith(fontSize: 24)),
                    Expanded(
                      child: Column(
                        children: [
                          Image.network(
                            widget.match.secondTeam.photo,
                            width: width / 6,
                            height: width / 6,
                          ),
                          SizedBox(height: height / 96),
                          Text(
                            widget.match.secondTeam.designation,
                            style: hsMedium.copyWith(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
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
          Text(
            'Date: ${widget.match.date.day}/${widget.match.date.month}/${widget.match.date.year}',
            style: hsRegular.copyWith(fontSize: 14),
          ),
          Text(
            'Heure: ${widget.match.date.hour}:${widget.match.date.minute.toString().padLeft(2, '0')}',
            style: hsRegular.copyWith(fontSize: 14),
          ),
          Text(
            'Stade: ${widget.match.field.designation}',
            style: hsRegular.copyWith(fontSize: 14),
          ),
          SizedBox(height: height / 66),
          Text('Résumé du match:',
              style: hsMedium.copyWith(fontSize: 16, color: DailozColor.black)),
          SizedBox(height: height / 96),
          Text(
            'Le match entre ${widget.match.firstTeam.designation} et ${widget.match.secondTeam.designation} promet d\'être passionnant.',
            style: hsRegular.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamDetails(double height, double width) {
    // You can implement the team details logic here
    return Container(
      decoration: BoxDecoration(
        color: DailozColor.bggray,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          'Team Details',
          style: hsMedium.copyWith(fontSize: 16, color: DailozColor.black),
        ),
      ),
    );
  }

  Widget _buildLeagueStandings(double height, double width) {
    // You can implement the league standings logic here
    return Container(
      decoration: BoxDecoration(
        color: DailozColor.bggray,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          'League Standings',
          style: hsMedium.copyWith(fontSize: 16, color: DailozColor.black),
        ),
      ),
    );
  }
}