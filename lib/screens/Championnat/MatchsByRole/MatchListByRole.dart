import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportdivers/Provider/ChampionatProviders/MatchListByRoleProvider.dart';
import 'package:sportdivers/models/MatchListByRoleModel.dart';
import 'package:sportdivers/models/tournamentModel.dart';
import 'package:sportdivers/screens/Championnat/MatchsByRole/MatchDetailsByRole.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_fontstyle.dart';

class MatchListByRolePage extends StatelessWidget {
  static String id = 'Match_List_By_Role_page';
  final Tournament tournament;

  const MatchListByRolePage({Key? key, required this.tournament}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return ChangeNotifierProvider(
      create: (context) => MatchListProviderByRole()..fetchMatchesByRole(tournament.id),
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
          title: Text("Vos Matchs", style: hsSemiBold.copyWith(fontSize: 22)),
          centerTitle: true,
        ),
        body: Consumer<MatchListProviderByRole>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 60),
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
                      provider.error!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            // Group matches by date
            Map<DateTime, List<MatchByRole>> matchesByDate = {};
            for (var match in provider.matches) {
              DateTime matchDate = DateTime(match.date.year, match.date.month, match.date.day);
              if (!matchesByDate.containsKey(matchDate)) {
                matchesByDate[matchDate] = [];
              }
              matchesByDate[matchDate]!.add(match);
            }

            return RefreshIndicator(
              onRefresh: () => provider.fetchMatchesByRole(tournament.id),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width/36, vertical: height/36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: matchesByDate.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: height/56, top: height/56),
                            padding: EdgeInsets.symmetric(horizontal: width/30, vertical: height/100),
                            decoration: BoxDecoration(
                              color: DailozColor.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _formatDate(entry.key),
                              style: hsSemiBold.copyWith(
                                fontSize: 16,
                                color: DailozColor.black,
                              ),
                            ),
                          ),
                          ...entry.value.map((match) => _buildMatchItem(context, match, height, width)).toList(),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMatchItem(BuildContext context, MatchByRole match, double height, double width) {
    return Container(
      margin: EdgeInsets.only(bottom: height / 46),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: DailozColor.white,
        boxShadow: [
          BoxShadow(
            color: DailozColor.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MatchDetailsByRolePage(match: match),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(width / 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width / 36,
                        vertical: height / 120,
                      ),
                      decoration: BoxDecoration(
                        color: DailozColor.bggray,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _formatTime(match.date),
                        style: hsMedium.copyWith(
                          fontSize: 14,
                          color: DailozColor.black,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width / 36,
                        vertical: height / 120,
                      ),
                      decoration: BoxDecoration(
                        color: DailozColor.bggray,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        match.field.designation,
                        style: hsMedium.copyWith(
                          fontSize: 12,
                          color: DailozColor.textgray,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height / 66),
                _buildTeamRow(match.firstTeam.designation, match.firstTeam.photo, height),
                SizedBox(height: height / 80),
                _buildTeamRow(match.secondTeam.designation, match.secondTeam.photo, height),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamRow(String teamName, String logoUrl, double height) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: DailozColor.bggray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildTeamAvatar(logoUrl, height),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              teamName,
              style: hsSemiBold.copyWith(fontSize: 14, color: DailozColor.black),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamAvatar(String logoUrl, double height) {
    return Container(
      height: height / 26,
      width: height / 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: DailozColor.white,
        border: Border.all(
          color: DailozColor.bggray,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 52),
        child: logoUrl.isNotEmpty
            ? Image.network(
          logoUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          },
        )
            : _buildDefaultAvatar(),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: DailozColor.bggray,
      child: Icon(
        Icons.sports_soccer,
        size: 16,
        color: DailozColor.textgray,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}