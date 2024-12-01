import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportdivers/Provider/ChampionatProviders/TeamsClassementProvider.dart';
import 'package:sportdivers/screens/Championnat/PlayersClassment.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_fontstyle.dart';

class TeamsClassementPage extends StatefulWidget {
  static String id = 'Classement_Page';
  final String tournamentId;

  const TeamsClassementPage({Key? key, required this.tournamentId})
      : super(key: key);

  @override
  _TeamsClassementPageState createState() => _TeamsClassementPageState();
}

class _TeamsClassementPageState extends State<TeamsClassementPage> {
  @override
  void initState() {
    super.initState();
    // Fetch rankings when the page is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TournamentRankingProvider>(context, listen: false)
          .fetchTournamentRankings(widget.tournamentId);
    });
  }

  Future<void> _refreshRankings() async {
    await Provider.of<TournamentRankingProvider>(context, listen: false)
        .fetchTournamentRankings(widget.tournamentId);
  }

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
      body: Consumer<TournamentRankingProvider>(
        builder: (context, rankingProvider, child) {
          // Show loading indicator while initially fetching
          if (rankingProvider.isLoading && rankingProvider.rankings.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          }

          // Show error if there's an issue
          if (rankingProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erreur de chargement',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Error: ${rankingProvider.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Display rankings with RefreshIndicator
          return RefreshIndicator(
            onRefresh: _refreshRankings,
            child: Column(
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
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildHeader(height, width),
                        Expanded(
                          child: ListView.builder(
                            itemCount: rankingProvider.rankings.length,
                            itemBuilder: (context, index) {
                              final team = rankingProvider.rankings[index];
                              return _buildTeamRow(
                                  context, team, index + 1, height, width);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (rankingProvider.isLoading)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                SizedBox(height: height / 70),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(double height, double width) {
    return Container(
      padding:
      EdgeInsets.symmetric(vertical: height / 50, horizontal: width / 20),
      decoration: BoxDecoration(
        color: Colors.blue[700],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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

  Widget _buildTeamRow(BuildContext context, dynamic team, int index,
      double height, double width) {
    Color rowColor = index % 2 == 0
        ? DailozColor.bggray.withOpacity(0.3)
        : DailozColor.white;
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
            builder: (context) => PlayersClassment(teamName: team.designation),
          ),
        );
      },
      child: Container(
        padding:
        EdgeInsets.symmetric(vertical: height / 70, horizontal: width / 20),
        decoration: BoxDecoration(
            color: rowColor,
            borderRadius:
            const BorderRadius.vertical(bottom: Radius.circular(20))),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                '$index',
                style: hsSemiBold.copyWith(fontSize: 16, color: textColor),
              ),
            ),
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  ClipOval(
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            team.photo,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                      null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (BuildContext context, Object exception,
                                StackTrace? stackTrace) {
                              return const Icon(Icons.error);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: width / 30),
                  Expanded(
                    child: Text(
                      team.designation,
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
                '${team.points}',
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