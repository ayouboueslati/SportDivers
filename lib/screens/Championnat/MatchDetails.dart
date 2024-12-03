import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportdivers/Provider/ChampionatProviders/MatchDetailsProvider.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_fontstyle.dart';

class MatchDetailsPage extends StatefulWidget {
  static String id = 'Match_Details_Page';

  final String matchId; // Changed from Match to matchId

  const MatchDetailsPage({Key? key, required this.matchId}) : super(key: key);

  @override
  _MatchDetailsPageState createState() => _MatchDetailsPageState();
}

class _MatchDetailsPageState extends State<MatchDetailsPage> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['DÉTAILS', 'CLASSEMENTS'];

  @override
  void initState() {
    super.initState();
    // Fetch match details when the page is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MatchDetailsProvider>(context, listen: false)
          .fetchMatchDetails(widget.matchId);
    });
  }

  int _calculateTeamScore(List<dynamic> actions, String teamId) {
    return actions
        .where((action) =>
    action.type == 'GOAL' && action.targetTeam == teamId)
        .length;
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
                    onPressed: () => provider.fetchMatchDetails(widget.matchId),
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
                      Text(
                        "${provider.match!.date.day}/${provider.match!.date.month}/${provider.match!.date.year} ${provider.match!.date.hour}:${provider.match!.date.minute}",
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
                              // First Team Logo
                              provider.match!.firstTeam.photo != null
                                  ? Image.network(
                                provider.match!.firstTeam.photo!,
                                width: width / 6,
                                height: width / 6,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildDefaultTeamLogo(),
                              )
                                  : _buildDefaultTeamLogo(),
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
                            // Score Display
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
                              // Second Team Logo
                              provider.match!.secondTeam.photo != null
                                  ? Image.network(
                                provider.match!.secondTeam.photo!,
                                width: width / 6,
                                height: width / 6,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildDefaultTeamLogo(),
                              )
                                  : _buildDefaultTeamLogo(),
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
          );
        },
      ),
    );
  }

  Widget _buildTabContent(double height, double width) {
    switch (_selectedIndex) {
      case 0:
        return _buildMatchDetails(height, width);
      // case 1:
      //   return _buildTeamDetails(height, width);
      case 1:
        return _buildLeagueStandings(height, width);
      default:
        return SizedBox.shrink();
    }
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

  // Helper method to build a default team logo
  Widget _buildDefaultTeamLogo() {
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

  Widget _buildMatchDetails(double height, double width) {
    final provider = Provider.of<MatchDetailsProvider>(context);

    return Container(
      padding: EdgeInsets.all(width / 36),
      decoration: BoxDecoration(
        color: DailozColor.bggray,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Match header
          Text('Détails du match',
              style:
                  hsSemiBold.copyWith(fontSize: 18, color: DailozColor.black)),
          SizedBox(height: height / 66),
          Text(
            'Date: ${provider.match!.date.day}/${provider.match!.date.month}/${provider.match!.date.year}',
            style: hsRegular.copyWith(fontSize: 14),
          ),
          Text(
            'Heure: ${provider.match!.date.hour}:${provider.match!.date.minute.toString().padLeft(2, '0')}',
            style: hsRegular.copyWith(fontSize: 14),
          ),
          Text(
            'Stade: ${provider.match!.field.designation}',
            style: hsRegular.copyWith(fontSize: 14),
          ),
          SizedBox(height: height / 36),

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
}

class TimelineItem extends StatelessWidget {
  final bool isFirstTeam;
  final int minute;
  final Widget icon;
  final String actionName;
  final String teamName;
  final double width;

  const TimelineItem({
    Key? key,
    required this.isFirstTeam,
    required this.minute,
    required this.icon,
    required this.actionName,
    required this.teamName,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          isFirstTeam ? _buildFirstTeamTimeline() : _buildSecondTeamTimeline(),
    );
  }

  List<Widget> _buildFirstTeamTimeline() {
    return [
      // Left side (First Team)
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  '$actionName ($teamName)',
                  style: hsRegular.copyWith(fontSize: 12),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: width / 36),
              icon,
              SizedBox(width: width / 36),
              Text(
                '$minute′',
                style: hsRegular.copyWith(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
      // Vertical Line
      Container(
        width: 2,
        height: 50,
        color: DailozColor.textgray.withOpacity(0.5),
      ),
      // Right side (empty)
      Expanded(child: SizedBox()),
    ];
  }

  List<Widget> _buildSecondTeamTimeline() {
    return [
      // Left side (empty)
      Expanded(child: SizedBox()),
      // Vertical Line
      Container(
        width: 2,
        height: 50,
        color: DailozColor.textgray.withOpacity(0.5),
      ),
      // Right side (Second Team)
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '$minute′',
                style: hsRegular.copyWith(fontSize: 12),
              ),
              SizedBox(width: width / 36),
              icon,
              SizedBox(width: width / 36),
              Flexible(
                child: Text(
                  '$actionName ($teamName)',
                  style: hsRegular.copyWith(fontSize: 12),
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }
}
