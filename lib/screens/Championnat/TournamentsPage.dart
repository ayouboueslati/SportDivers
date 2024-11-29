import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportdivers/Provider/ChampionatProviders/TournamentProvider.dart';
import 'package:sportdivers/models/tournamentModel.dart';
import 'package:sportdivers/screens/Championnat/MatchsByRole/MatchListByRole.dart';
import 'package:sportdivers/screens/Championnat/MatchsList.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_fontstyle.dart';

class TournamentScreen extends StatelessWidget {
  static String id = 'Tournament_Screen';

  const TournamentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider(
      create: (context) => TournamentProvider()..fetchTournaments(),
      child: Scaffold(
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
          title: Text("Tournois", style: hsSemiBold.copyWith(fontSize: 22)),
          centerTitle: true,
        ),
        body: Consumer<TournamentProvider>(
          builder: (context, tournamentProvider, child) {
            if (tournamentProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              );
            }

            if (tournamentProvider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
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
                      'Error: ${tournamentProvider.error}',
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => tournamentProvider.fetchTournaments(),
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 16),
                itemCount: tournamentProvider.tournaments.length,
                itemBuilder: (context, index) {
                  final tournament = tournamentProvider.tournaments[index];
                  return TournamentItem(
                    tournament: tournament,
                    onRegister: () =>
                        tournamentProvider.registerForTournament(tournament.id),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class TournamentItem extends StatelessWidget {
  final Tournament tournament;
  final VoidCallback onRegister;

  const TournamentItem({
    Key? key,
    required this.tournament,
    required this.onRegister,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tournament.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.category, 'Type', tournament.type),
            _buildInfoRow(Icons.calendar_today, 'Date Début',
                tournament.formattedStartDate),
            _buildInfoRow(
                Icons.calendar_month, 'Date Fin', tournament.formattedEndDate),
            _buildInfoRow(Icons.attach_money, 'Frais d\'inscription',
                '${tournament.fees.toStringAsFixed(2)} DT'),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, MatchListByRolePage.id,
                          arguments: tournament);
                    },
                    icon: Icon(Icons.sports_soccer_outlined),
                    label: const Text('Vos Matchs'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, MatchListPage.id,
                          arguments: tournament);
                    },
                    icon: Icon(Icons.sports_soccer_outlined),
                    label: const Text('Tous Les Matchs'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[600], size: 20),
          SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupSection(String title, List<dynamic> groups) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.blue[700],
          ),
        ),
        SizedBox(height: 8),
        ...groups
            .map((group) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.chevron_right,
                          color: Colors.blue[600], size: 20),
                      SizedBox(width: 8),
                      Text(
                        group.designation,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }
}
