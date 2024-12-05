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
          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: DailozColor.lightblue),
            );
          }

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
    final width = size.width;

    return SliverToBoxAdapter(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(title, style: hsSemiBold.copyWith(fontSize: 18, color: DailozColor.black)),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: DataTable(
                      columnSpacing: 16,
                      headingRowColor: MaterialStateColor.resolveWith(
                            (states) => DailozColor.lightblue.withOpacity(0.1),
                      ),
                      columns: [
                        DataColumn(
                          label: Text("#", style: hsSemiBold.copyWith(fontSize: 16, color: DailozColor.black)),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Text("Joueur", style: hsSemiBold.copyWith(fontSize: 16, color: DailozColor.black)),
                        ),
                        DataColumn(
                          label: Text(statKey.capitalize(), style: hsSemiBold.copyWith(fontSize: 16, color: DailozColor.black)),
                          numeric: true,
                        ),
                      ],
                      rows: data.asMap().entries.map((entry) {
                        int index = entry.key;
                        var player = entry.value;
                        return DataRow(
                          cells: [
                            DataCell(Text("${index + 1}", style: hsMedium.copyWith(fontSize: 14, color: DailozColor.black))),
                            DataCell(
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: DailozColor.lightblue.withOpacity(0.1),
                                    backgroundImage: player.profilePicture != null ? NetworkImage(player.profilePicture!) : null,
                                    child: player.profilePicture == null
                                        ? Icon(Icons.person, color: DailozColor.black)
                                        : null,
                                  ),
                                  SizedBox(width: 8),
                                  Text(player.fullname, style: hsMedium.copyWith(fontSize: 14, color: DailozColor.black)),
                                ],
                              ),
                            ),
                            DataCell(Text("${player.count}", style: hsMedium.copyWith(fontSize: 14, color: DailozColor.lightred))),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
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