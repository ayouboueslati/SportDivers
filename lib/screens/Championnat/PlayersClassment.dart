import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportdivers/Provider/ChampionatProviders/PlayersClassementProvider.dart';
import 'package:sportdivers/models/PlayersClassementModel.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_fontstyle.dart';

class PlayersClassment extends StatefulWidget {

  final String tournamentId;

  const PlayersClassment({
    Key? key,
    required this.tournamentId
  }) : super(key: key);

  @override
  _PlayersClassmentState createState() => _PlayersClassmentState();
}

class _PlayersClassmentState extends State<PlayersClassment> {
  @override
  void initState() {
    super.initState();
    // Fetch player rankings when the widget is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PlayerRankingProvider>(context, listen: false)
          .fetchPlayerRankings(widget.tournamentId);
    });
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
            onTap: () => Navigator.pop(context),
            child: Container(
              height: height / 20,
              width: height / 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: DailozColor.white,
                boxShadow: const [
                  BoxShadow(color: DailozColor.textgray, blurRadius: 5)
                ],
              ),
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
        title: Text("classement", style: hsSemiBold.copyWith(fontSize: 22)),
        centerTitle: true,
      ),
      body: Consumer<PlayerRankingProvider>(
        builder: (context, provider, child) {
          // Show loading indicator while fetching data
          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: DailozColor.lightblue),
            );
          }

          // Show error if there's an issue
          if (provider.error != null) {
            return Center(
              child: Text(
                  'Error: ${provider.error}',
                  style: hsMedium.copyWith(color: DailozColor.lightred)
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: height / 40)),
              _buildSection(
                  context,
                  "Classement des buteurs",
                  provider.topScorers,
                  'but'
              ),
              SliverToBoxAdapter(child: SizedBox(height: height / 40)),
              _buildSection(
                  context,
                  "Classement des cartons rouges",
                  provider.redCards,
                  'carton rouge'
              ),
              SliverToBoxAdapter(child: SizedBox(height: height / 40)),
              _buildSection(
                  context,
                  "Classement des cartons jaunes",
                  provider.yellowCards,
                  'carton jaune'
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<PlayerRanking> data, String statKey) {
    final size = MediaQuery.of(context).size;

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: size.width / 20),
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
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: DailozColor.lightblue.withOpacity(0.1)),
                  children: [
                    TableCell(child: _buildHeaderCell("Pos")),
                    TableCell(child: _buildHeaderCell("Joueur")),
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
                          TableCell(child: _buildPlayerCell(player.fullname, player.profilePicture)),
                          TableCell(child: _buildCell("${player.count}", color: DailozColor.lightred)),
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

  // Existing helper methods from the original implementation remain the same
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

  Widget _buildPlayerCell(String name, String? photoUrl) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: DailozColor.lightblue.withOpacity(0.1),
            backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
            child: photoUrl == null
                ? Icon(Icons.person, color: DailozColor.black)
                : null,
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

// Extension remains the same
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}