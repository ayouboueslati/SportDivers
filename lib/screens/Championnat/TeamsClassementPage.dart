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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: DailozColor.bggray,
          appBar: AppBar(
            leading: _buildBackButton(constraints),
            title: Text("Classement", style: hsSemiBold.copyWith(fontSize: 22)),
            centerTitle: true,
          ),
          body: Consumer<TournamentRankingProvider>(
            builder: (context, rankingProvider, child) {
              if (rankingProvider.isLoading && rankingProvider.rankings.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                );
              }

              if (rankingProvider.error != null) {
                return _buildErrorWidget(rankingProvider.error);
              }

              return _buildRankingsContent(
                  rankingProvider, constraints.maxWidth, constraints.maxHeight);
            },
          ),
        );
      },
    );
  }

  Widget _buildBackButton(BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        splashColor: DailozColor.transparent,
        highlightColor: DailozColor.transparent,
        onTap: () => Navigator.pop(context),
        child: Container(
          height: constraints.maxHeight / 20,
          width: constraints.maxHeight / 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: DailozColor.white,
            boxShadow: const [
              BoxShadow(color: DailozColor.textgray, blurRadius: 5)
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(left: constraints.maxWidth / 56),
            child: const Icon(
              Icons.arrow_back_ios,
              size: 18,
              color: DailozColor.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String? error) {
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
            'Error: $error',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRankingsContent(
      TournamentRankingProvider rankingProvider, double width, double height) {
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
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return ListView.builder(
                          itemCount: rankingProvider.rankings.length,
                          itemBuilder: (context, index) {
                            final team = rankingProvider.rankings[index];
                            return _buildTeamRow(
                                context,
                                team,
                                index + 1,
                                constraints.maxWidth,
                                constraints.maxHeight
                            );
                          },
                        );
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
  }

  Widget _buildHeader(double height, double width) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: height / 70,
          horizontal: width / 70
      ),
      decoration: BoxDecoration(
        color: Colors.blue[700],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: _buildHeaderText('#'),
          ),
          Expanded(
            flex: 5,
            child: _buildHeaderText('Équipe'),
          ),
          Expanded(
            flex: 1,
            child: _buildHeaderText('Pts'),
          ),
          Expanded(
            flex: 1,
            child: _buildHeaderText('G'),
          ),
          // Add more header columns here as needed
        ],
      ),
    );
  }

  Widget _buildHeaderText(String text) {
    return Text(
      text,
      style: hsSemiBold.copyWith(
          fontSize: 16,
          color: DailozColor.white
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildTeamRow(
      BuildContext context,
      dynamic team,
      int index,
      double width,
      double height
      ) {
    Color rowColor = _determineRowColor(index);
    Color textColor = _determineTextColor(index);

    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => PlayersClassment(tournamentId:widget.tournamentId),
        //   ),
        // );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: height / 70,
            horizontal: width / 25
        ),
        decoration: BoxDecoration(
            color: rowColor,
            borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20)
            )
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: _buildRowText('$index', textColor),
            ),
            Expanded(
              flex: 4,
              child: _buildTeamNameSection(team, textColor, width),
            ),
            Expanded(
              flex: 1,
              child: _buildRowText(
                  '${team.points}',
                  textColor,
                  textAlign: TextAlign.right
              ),
            ),
            Expanded(
              flex:1,
              child: _buildRowText(
                  '${team.goals}',
                  textColor,
                  textAlign: TextAlign.right
              ),
            ),
            // Add more columns here as needed
          ],
        ),
      ),
    );
  }

  Widget _buildTeamNameSection(dynamic team, Color textColor, double width) {
    return Row(
      children: [
        ClipOval(
          child: SizedBox(
            width: 36,
            height: 36,
            child: _buildTeamLogo(team.photo),
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
    );
  }

  Widget _buildTeamLogo(String photoUrl) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          photoUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, exception, stackTrace) {
            return const Icon(Icons.error);
          },
        ),
      ],
    );
  }

  Widget _buildRowText(
      String text,
      Color color, {
        TextAlign textAlign = TextAlign.start,
      }) {
    return Text(
      text,
      style: hsSemiBold.copyWith(fontSize: 16, color: color),
      textAlign: textAlign,
    );
  }

  Color _determineRowColor(int index) {
    if (index <= 3) {
      return DailozColor.lightred.withOpacity(0.1);
    }
    return index % 2 == 0
        ? DailozColor.bggray.withOpacity(0.3)
        : DailozColor.white;
  }

  Color _determineTextColor(int index) {
    return index <= 3 ? DailozColor.lightred : DailozColor.black;
  }
}