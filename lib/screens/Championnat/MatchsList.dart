import 'package:flutter/material.dart';
import 'package:sportdivers/models/MatchModel.dart';
import 'package:sportdivers/screens/Championnat/MatchDetails.dart';

class MatchListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        shadowColor: Colors.grey.withOpacity(0.3),
        elevation: 5,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.blue[900],
        title: const Text(
          'Matchs à venir',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: matches.length,
        itemBuilder: (context, index) {
          final match = matches[index];
          return Column(
            children: [
              if (index == 0 || match.date != matches[index - 1].date)
                Container(
                  color: Colors.grey[200],
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    match.date,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MatchDetailsPage(match: match),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          match.time,
                          style: TextStyle(
                            color: match.matchStatus == "Live" ? Colors.red : Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  match.homeTeamLogo,
                                  width: 24,
                                  height: 24,
                                  errorBuilder: (context, error, stackTrace) => SizedBox(width: 24, height: 24),
                                ),
                                SizedBox(width: 8),
                                Text(match.homeTeam),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Image.asset(
                                  match.awayTeamLogo,
                                  width: 24,
                                  height: 24,
                                  errorBuilder: (context, error, stackTrace) => SizedBox(width: 24, height: 24),
                                ),
                                SizedBox(width: 8),
                                Text(match.awayTeam),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(match.place)
                      ),
                    ],
                  ),
                ),
              ),
              Divider(height: 1, color: Colors.grey[300]),
            ],
          );
        },
      ),
    );
  }
}