import 'package:flutter/material.dart';
import 'package:sportdivers/models/MatchListByRoleModel.dart';
import 'package:sportdivers/screens/Championnat/MatchsByRole/ConvocationPage.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_fontstyle.dart';

class MatchDetailsByRolePage extends StatefulWidget {
  static String id = 'Match_Details_By_Role_Page';

  final MatchByRole match;

  const MatchDetailsByRolePage({Key? key, required this.match})
      : super(key: key);

  @override
  _MatchDetailsByRolePageState createState() => _MatchDetailsByRolePageState();
}

class _MatchDetailsByRolePageState extends State<MatchDetailsByRolePage> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['DÉTAILS', 'ÉQUIPES', 'CLASSEMENTS'];


  void _showTeamSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Sélectionner l\'équipe à convoquer',
            style: hsSemiBold.copyWith(fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTeamSelectionButton(
                teamName: widget.match.firstTeam.designation,
                teamId: widget.match.firstTeam.id, // Assuming there's an ID field
              ),
              SizedBox(height: 10),
              _buildTeamSelectionButton(
                teamName: widget.match.secondTeam.designation,
                teamId: widget.match.secondTeam.id, // Assuming there's an ID field
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler', style: hsRegular),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Helper method to build team selection button
  Widget _buildTeamSelectionButton({
    required String teamName,
    required String teamId
  }) {
    return ElevatedButton(
      onPressed: () {
        // Close the dialog
        Navigator.of(context).pop();

        // Navigate to ConvocationPage with selected team
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConvocationPage(
              teamId: teamId, // Pass the selected team's ID
              matchId: widget.match.id,
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: DailozColor.appcolor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        teamName,
        style: hsRegular.copyWith(fontSize: 16),
      ),
    );
  }


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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${widget.match.date.day}/${widget.match.date.month}/${widget.match.date.year} ${widget.match.date.hour.toString().padLeft(2, '0')}:${widget.match.date.minute.toString().padLeft(2, '0')}",
                        style: hsRegular.copyWith(fontSize: 14),
                      ),

                      Flexible(
                        child:  ElevatedButton.icon(
                          onPressed: _showTeamSelectionDialog, // Replace the existing navigation
                          icon: const Icon(Icons.groups_rounded),
                          label: const Text('Convoque'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
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
                          widget.match.firstTeam.photo.isNotEmpty
                              ? Image.network(
                                  widget.match.firstTeam.photo,
                                  width: width / 6,
                                  height: width / 6,
                                  errorBuilder: (context, error, stackTrace) =>
                                      _buildDefaultTeamImage(),
                                )
                              : _buildDefaultTeamImage(),
                          SizedBox(height: height / 96),
                          Text(
                            widget.match.firstTeam.designation,
                            style: hsMedium.copyWith(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            widget.match.firstTeamType,
                            style: hsRegular.copyWith(
                                fontSize: 12, color: DailozColor.textgray),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Text('-', style: hsSemiBold.copyWith(fontSize: 24)),
                    Expanded(
                      child: Column(
                        children: [
                          widget.match.secondTeam.photo.isNotEmpty
                              ? Image.network(
                                  widget.match.secondTeam.photo,
                                  width: width / 6,
                                  height: width / 6,
                                  errorBuilder: (context, error, stackTrace) =>
                                      _buildDefaultTeamImage(),
                                )
                              : _buildDefaultTeamImage(),
                          SizedBox(height: height / 96),
                          Text(
                            widget.match.secondTeam.designation,
                            style: hsMedium.copyWith(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            widget.match.secondTeamType,
                            style: hsRegular.copyWith(
                                fontSize: 12, color: DailozColor.textgray),
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

  Widget _buildDefaultTeamImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: DailozColor.bggray,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.sports_soccer,
        color: DailozColor.textgray,
        size: 40,
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
            'Heure: ${widget.match.date.hour.toString().padLeft(2, '0')}:${widget.match.date.minute.toString().padLeft(2, '0')}',
            style: hsRegular.copyWith(fontSize: 14),
          ),
          Text(
            'Stade: ${widget.match.field.designation}',
            style: hsRegular.copyWith(fontSize: 14),
          ),
          if (widget.match.arbiter != null)
            Text(
              'Arbitre: ${widget.match.arbiter != null ? "Présent" : "Non assigné"}',
              style: hsRegular.copyWith(fontSize: 14),
            ),
          SizedBox(height: height / 66),
          Text('Phase du tournoi:',
              style: hsMedium.copyWith(fontSize: 16, color: DailozColor.black)),
          SizedBox(height: height / 96),
          Text(
            'Date de la phase: ${widget.match.tournamentPhase.date.day}/${widget.match.tournamentPhase.date.month}/${widget.match.tournamentPhase.date.year}',
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
    return Container(
      padding: EdgeInsets.all(width / 36),
      decoration: BoxDecoration(
        color: DailozColor.bggray,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTeamDetailSection(
              'Équipe 1',
              widget.match.firstTeam.designation,
              widget.match.firstTeam.category.designation,
              widget.match.firstTeam.photo),
          SizedBox(height: height / 36),
          _buildTeamDetailSection(
              'Équipe 2',
              widget.match.secondTeam.designation,
              widget.match.secondTeam.category.designation,
              widget.match.secondTeam.photo),
        ],
      ),
    );
  }

  Widget _buildTeamDetailSection(
      String title, String teamName, String category, String photoUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: hsSemiBold.copyWith(fontSize: 18, color: DailozColor.black)),
        SizedBox(height: 10),
        Row(
          children: [
            photoUrl.isNotEmpty
                ? Image.network(
                    photoUrl,
                    width: 80,
                    height: 80,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildDefaultTeamImage(),
                  )
                : _buildDefaultTeamImage(),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(teamName, style: hsMedium.copyWith(fontSize: 16)),
                Text('Catégorie: $category',
                    style: hsRegular.copyWith(
                        fontSize: 14, color: DailozColor.textgray)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLeagueStandings(double height, double width) {
    return Container(
      decoration: BoxDecoration(
        color: DailozColor.bggray,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          'Classements à venir',
          style: hsMedium.copyWith(fontSize: 16, color: DailozColor.black),
        ),
      ),
    );
  }
}
