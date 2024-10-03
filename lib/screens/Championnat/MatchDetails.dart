import 'package:flutter/material.dart';
import 'package:sportdivers/models/MatchModel.dart';

class MatchDetailsPage extends StatefulWidget {
  final Match match;

  const MatchDetailsPage({Key? key, required this.match}) : super(key: key);

  @override
  _MatchDetailsPageState createState() => _MatchDetailsPageState();
}

class _MatchDetailsPageState extends State<MatchDetailsPage> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['DÉTAILS', 'ÉQUIPES', 'CLASSEMENTS'];

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
          'Détails du match',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.grey[200],
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text('${widget.match.date} ${widget.match.time}'),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Image.asset(widget.match.homeTeamLogo, width: 60, height: 60),
                          SizedBox(height: 8),
                          Text(widget.match.homeTeam, textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                    Text('-', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Column(
                        children: [
                          Image.asset(widget.match.awayTeamLogo, width: 60, height: 60),
                          SizedBox(height: 8),
                          Text(widget.match.awayTeam, textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: ToggleButtons(
                isSelected: List.generate(_tabs.length, (index) => index == _selectedIndex),
                onPressed: (int index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                children: _tabs.map((tab) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(tab,style: TextStyle(color: Colors.blue[900]),),
                )).toList(),
              ),
            ),
          ),
          Expanded(
            child: _buildTabContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildMatchDetails();
      case 1:
        return _buildTeamDetails();
      case 2:
        return _buildLeagueStandings();
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildMatchDetails() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Détails du match', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.blue[900]),),
          SizedBox(height: 16),
          Text('Date: ${widget.match.date}'),
          Text('Heure: ${widget.match.time}'),
          Text('Stade: ${widget.match.place}'),
          SizedBox(height: 16),
          Text('Résumé du match:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900])),
          Text('Le match entre ${widget.match.homeTeam} et ${widget.match.awayTeam} promet d\'être passionnant. Les deux équipes sont en forme et cherchent à gagner des points importants pour le classement.'),
        ],
      ),
    );
  }

  Widget _buildTeamDetails() {
    // This is dummy data. In a real app, you'd fetch this from your data source.
    List<Map<String, dynamic>> teamsData = [
      {
        'name': widget.match.homeTeam,
        'players': List.generate(20, (index) => {
          'name': 'Player ${index + 1}',
          'score': 20 - index,
          'yellowCards': index % 3,
          'redCards': index % 10 == 0 ? 1 : 0,
          'assists': (15 - index).clamp(0, 15),
        }),
      },
      {
        'name': widget.match.awayTeam,
        'players': List.generate(20, (index) => {
          'name': 'Player ${String.fromCharCode(65 + index)}',
          'score': 20 - index,
          'yellowCards': index % 4,
          'redCards': index % 12 == 0 ? 1 : 0,
          'assists': (18 - index).clamp(0, 18),
        }),
      },
    ];

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: widget.match.homeTeam),
              Tab(text: widget.match.awayTeam),
            ],
            labelColor: Colors.blue[900],
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue[900],
          ),
          Expanded(
            child: TabBarView(
              children: teamsData.map((team) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Classement des joueurs',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.blue[900]),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          Container(
                            color: Colors.grey[200],
                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            child: Row(
                              children: [
                                Expanded(flex: 1, child: Text('Pos', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue[900]))),
                                Expanded(flex: 3, child: Text('Nom', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue[900]))),
                                Expanded(flex: 1, child: Text('Buts', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue[900]))),
                                Expanded(flex: 1, child: Text('CJ', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue[900]))),
                                Expanded(flex: 1, child: Text('CR', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue[900]))),
                                Expanded(flex: 1, child: Text('Passes', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue[900]))),
                              ],
                            ),
                          ),
                          ...team['players'].asMap().entries.map((entry) {
                            int idx = entry.key;
                            var player = entry.value;
                            return Container(
                              color: idx.isEven ? Colors.white : Colors.grey[100],
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                child: Row(
                                  children: [
                                    Expanded(flex: 1, child: Text('${idx + 1}')),
                                    Expanded(flex: 3, child: Text(player['name'])),
                                    Expanded(flex: 1, child: Text('${player['score']}')),
                                    Expanded(flex: 1, child: Text('${player['yellowCards']}')),
                                    Expanded(flex: 1, child: Text('${player['redCards']}')),
                                    Expanded(flex: 1, child: Text('${player['assists']}')),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeagueStandings() {
    // This is dummy data. In a real app, you'd fetch this from your data source.
    List<Map<String, dynamic>> standings = List.generate(
      20,
          (index) => {
        'position': index + 1,
        'team': 'Team ${String.fromCharCode(65 + index)}',
        'points': 100 - (index * 3),
        'logo': 'assets/team_logos/team_${String.fromCharCode(65 + index).toLowerCase()}.png',
      },
    );

    return ListView.builder(
      itemCount: standings.length + 1, // +1 for the header
      itemBuilder: (context, index) {
        if (index == 0) {
          // Header
          return Container(
            color: Colors.grey[300],
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Expanded(flex: 1, child: Text('Pos', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900]))),
                Expanded(flex: 4, child: Text('Équipe', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900]))),
                Expanded(flex: 1, child: Text('Pts', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900]))),
              ],
            ),
          );
        }
        var team = standings[index - 1];
        return Container(
          color: index.isOdd ? Colors.grey[100] : Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(team['position'].toString(), style: TextStyle(fontWeight: FontWeight.bold))
                ),
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: AssetImage('assets/images/icons/default_avatar.png'),
                        foregroundImage: AssetImage(team['logo']),
                      ),
                      SizedBox(width: 12),
                      Expanded(child: Text(team['team'], style: TextStyle(fontWeight: FontWeight.w500))),
                    ],
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Text(team['points'].toString(), style: TextStyle(fontWeight: FontWeight.bold))
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}