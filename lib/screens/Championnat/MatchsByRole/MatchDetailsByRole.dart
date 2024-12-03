import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportdivers/Provider/AuthProvider/auth_provider.dart';
import 'package:sportdivers/Provider/ChampionatProviders/MatchDetailsProvider.dart';
import 'package:sportdivers/components/CustomToast.dart';
import 'package:sportdivers/models/MatchListByRoleModel.dart';
import 'package:sportdivers/screens/Championnat/MatchDetails.dart';
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
  final List<String> _tabs = ['DÉTAILS', 'CLASSEMENTS'];

  @override
  void initState() {
    super.initState();
    // Fetch match details when the page is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MatchDetailsProvider>(context, listen: false)
          .fetchMatchDetails(widget.match.id);
    });
  }

  int _calculateTeamScore(List<dynamic> actions, String teamId) {
    return actions
        .where((action) =>
    action.type == 'GOAL' && action.targetTeam == teamId)
        .length;
  }

  void _navigateToConvocation() {
    // Calculate the time difference between now and the match start
    DateTime now = DateTime.now();
    DateTime matchStart = widget.match.date;

    // Check if the current time is within 48 hours before the match
    if (matchStart.difference(now).inHours <= 48 && matchStart.isAfter(now)) {
      // Find the first team the coach is allowed to convocate for
      String? teamId;

      if (widget.match.coachTeams!.contains(widget.match.firstTeam.id)) {
        teamId = widget.match.firstTeam.id;
      } else if (widget.match.coachTeams!.contains(widget.match.secondTeam.id)) {
        teamId = widget.match.secondTeam.id;
      }

      if (teamId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConvocationPage(
              teamId: teamId!, // Use the found team ID
              matchId: widget.match.id,
              coachTeams: widget.match.coachTeams!,
            ),
          ),
        );
      } else {
        showReusableToastRed(
          context: context,
          message: 'Vous n\'êtes pas autorisé à convoquer pour ce match',
          duration: Duration(seconds: 5),
        );
      }
    } else {
      showReusableToastRed(
        context: context,
        message: 'La convocation n\'est possible que dans les 48 heures précédant le match',
        duration: Duration(seconds: 5),
      );
    }
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
      body: Consumer<MatchDetailsProvider>(
        builder: (context, provider, child) {
          // Handle loading state
          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: DailozColor.appcolor,
              ),
            );
          }

          // Handle error state
          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 60),
                  SizedBox(height: 16),
                  Text(
                    'Erreur de chargement',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    provider.error!,
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                    onPressed: () => provider.fetchMatchDetails(widget.match.id),
                    child: Text('Réessayer'),
                  )
                ],
              ),
            );
          }

          // Handle case where no match is loaded
          if (provider.match == null) {
            return Center(
              child: Text('Aucun match trouvé'),
            );
          }

          return SingleChildScrollView(
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
                            "${provider.match!.date.day}/${provider.match!.date.month}/${provider.match!.date.year} ${provider.match!.date.hour.toString().padLeft(2, '0')}:${provider.match!.date.minute.toString().padLeft(2, '0')}",
                            style: hsRegular.copyWith(fontSize: 14),
                          ),
                          // Only show the button if the user is not a student
                          Consumer<AuthenticationProvider>(
                            builder: (context, authProvider, child) {
                              return authProvider.accountType != 'STUDENT'
                                  ? ElevatedButton.icon(
                                onPressed: _navigateToConvocation,
                                icon: const Icon(Icons.groups_rounded),
                                label: const Text('Convoque'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: DailozColor.textblue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              )
                                  : SizedBox.shrink(); // Hide the button completely for students
                            },
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
                              provider.match!.firstTeam.photo != null
                                  ? Image.network(
                                provider.match!.firstTeam.photo!,
                                width: width / 6,
                                height: width / 6,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildDefaultTeamImage(),
                              )
                                  : _buildDefaultTeamImage(),
                              SizedBox(height: height / 96),
                              Text(
                                provider.match!.firstTeam.designation,
                                style: hsMedium.copyWith(fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              '${_calculateTeamScore(provider.match!.actions, provider.match!.firstTeam.id)} - ${_calculateTeamScore(provider.match!.actions, provider.match!.secondTeam.id)}',
                              style: hsSemiBold.copyWith(fontSize: 24, color: DailozColor.black),
                            ),
                            Text(
                              'Score',
                              style: hsRegular.copyWith(fontSize: 12, color: DailozColor.textgray),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              provider.match!.secondTeam.photo != null
                                  ? Image.network(
                                provider.match!.secondTeam.photo!,
                                width: width / 6,
                                height: width / 6,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildDefaultTeamImage(),
                              )
                                  : _buildDefaultTeamImage(),
                              SizedBox(height: height / 96),
                              Text(
                                provider.match!.secondTeam.designation,
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
                              padding:
                              EdgeInsets.symmetric(vertical: height / 66),
                              decoration: BoxDecoration(
                                color: _selectedIndex == idx
                                    ? DailozColor.textblue
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
                  _buildTabContent(height, width, provider),
                ],
              ),
            ),
          );
        },
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

  Widget _buildTabContent(double height, double width, MatchDetailsProvider provider) {
    switch (_selectedIndex) {
      case 0:
        return _buildMatchDetails(height, width, provider);
      case 1:
        return _buildLeagueStandings(height, width);
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildMatchDetails(double height, double width, MatchDetailsProvider provider) {
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
              style: hsSemiBold.copyWith(fontSize: 18, color: DailozColor.black)),
          SizedBox(height: height / 66),
          Text(
            'Date: ${provider.match!.date.day}/${provider.match!.date.month}/${provider.match!.date.year}',
            style: hsRegular.copyWith(fontSize: 14),
          ),
          Text(
            'Heure: ${provider.match!.date.hour.toString().padLeft(2, '0')}:${provider.match!.date.minute.toString().padLeft(2, '0')}',
            style: hsRegular.copyWith(fontSize: 14),
          ),
          Text(
            'Stade: ${provider.match!.field.designation}',
            style: hsRegular.copyWith(fontSize: 14),
          ),
          if (provider.match!.arbiter != null)
            Text(
              'Arbitre: ${provider.match!.arbiter != null ? "Présent" : "Non assigné"}',
              style: hsRegular.copyWith(fontSize: 14),
            ),
          SizedBox(height: height / 66),
          // Match Timeline
          if (provider.match!.actions.isNotEmpty)
            Text('Événements du match:',
                style: hsMedium.copyWith(fontSize: 16, color: DailozColor.black)),
          SizedBox(height: height / 36),
          _buildMatchTimeline(height, width, provider),
        ],
      ),
    );
  }
  Widget _buildMatchTimeline(
      double height, double width, MatchDetailsProvider provider) {
    // Sort actions by minute to ensure chronological order
    final sortedActions = List<dynamic>.from(provider.match!.actions)
      ..sort((a, b) => a.minute.compareTo(b.minute));

    return Container(
      height: height / 2, // Adjust height as needed
      child: ListView.builder(
        itemCount: sortedActions.length,
        itemBuilder: (context, index) {
          final action = sortedActions[index];

          // Determine which side the timeline item should be on
          bool isFirstTeam = action.targetTeam == provider.match!.firstTeam.id;
          String teamName = isFirstTeam
              ? provider.match!.firstTeam.designation
              : provider.match!.secondTeam.designation;

          return TimelineItem(
            isFirstTeam: isFirstTeam,
            minute: action.minute,
            icon: _getActionIcon(action.type),
            actionName: action.actionName,
            teamName: teamName,
            width: width,
          );
        },
      ),
    );
  }
  // Helper method to get action icon
  Widget _getActionIcon(String actionType) {
    switch (actionType) {
      case 'GOAL':
        return Icon(Icons.sports_soccer, color: Colors.green, size: 24);
      case 'YELLOW_CARD':
        return Icon(Icons.rectangle, color: Colors.yellow, size: 24);
      case 'RED_CARD':
        return Icon(Icons.rectangle, color: Colors.red, size: 24);
      default:
        return Icon(Icons.event, color: DailozColor.textgray, size: 24);
    }
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

}
