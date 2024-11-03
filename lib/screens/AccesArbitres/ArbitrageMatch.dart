import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sportdivers/models/MatchModel.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_fontstyle.dart';

class ArbitratorMatchPage extends StatefulWidget {
  const ArbitratorMatchPage({Key? key}) : super(key: key);

  @override
  _ArbitratorMatchPageState createState() => _ArbitratorMatchPageState();
}

class _ArbitratorMatchPageState extends State<ArbitratorMatchPage> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['MATCH CONTROL', 'ÉQUIPES', 'ACTIONS'];
  int homeScore = 0;
  int awayScore = 0;
  bool isMatchStarted = false;
  Duration matchTime = Duration.zero;
  late Timer _timer;

  // Static match data
  final String homeTeam = "Club Africain ";
  final String awayTeam = "FC Barcelone";
  final String homeTeamLogo = "assets/images/CA.png";
  final String awayTeamLogo = "assets/images/barca.png";

  List<Map<String, dynamic>> homeTeamPlayers = [];
  List<Map<String, dynamic>> awayTeamPlayers = [];
  List<Map<String, dynamic>> matchEvents = [];

  @override
  void initState() {
    super.initState();
    // Initialize with realistic player names
    homeTeamPlayers = [
      {
        'id': 'H1',
        'name': 'Mbappé',
        'number': 7,
        'goals': 0,
        'yellowCards': 0,
        'redCards': 0,
        'isOnField': true
      },
      {
        'id': 'H2',
        'name': 'Dembélé',
        'number': 10,
        'goals': 0,
        'yellowCards': 0,
        'redCards': 0,
        'isOnField': true
      },
      {
        'id': 'H3',
        'name': 'Hakimi',
        'number': 2,
        'goals': 0,
        'yellowCards': 0,
        'redCards': 0,
        'isOnField': true
      },
      {
        'id': 'H4',
        'name': 'Marquinhos',
        'number': 5,
        'goals': 0,
        'yellowCards': 0,
        'redCards': 0,
        'isOnField': true
      },
      {
        'id': 'H5',
        'name': 'Vitinha',
        'number': 17,
        'goals': 0,
        'yellowCards': 0,
        'redCards': 0,
        'isOnField': true
      },
    ];

    awayTeamPlayers = [
      {
        'id': 'A1',
        'name': 'Aubameyang',
        'number': 9,
        'goals': 0,
        'yellowCards': 0,
        'redCards': 0,
        'isOnField': true
      },
      {
        'id': 'A2',
        'name': 'Veretout',
        'number': 8,
        'goals': 0,
        'yellowCards': 0,
        'redCards': 0,
        'isOnField': true
      },
      {
        'id': 'A3',
        'name': 'Clauss',
        'number': 7,
        'goals': 0,
        'yellowCards': 0,
        'redCards': 0,
        'isOnField': true
      },
      {
        'id': 'A4',
        'name': 'Gigot',
        'number': 4,
        'goals': 0,
        'yellowCards': 0,
        'redCards': 0,
        'isOnField': true
      },
      {
        'id': 'A5',
        'name': 'Rongier',
        'number': 21,
        'goals': 0,
        'yellowCards': 0,
        'redCards': 0,
        'isOnField': true
      },
    ];
  }

  void startMatch() {
    setState(() {
      isMatchStarted = true;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          matchTime = Duration(seconds: matchTime.inSeconds + 1);
        });
      });
    });
  }

  void pauseMatch() {
    _timer.cancel();
    setState(() {
      isMatchStarted = false;
    });
  }

  void addGoal(bool isHomeTeam) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: DailozColor.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(Icons.sports_soccer, size: 28, color: DailozColor.appcolor),
                    const SizedBox(width: 12),
                    Text(
                      'Ajouter un but',
                      style: hsSemiBold.copyWith(
                        fontSize: 24,
                        color: DailozColor.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Sélectionnez le joueur qui a marqué',
                  style: TextStyle(
                    fontSize: 16,
                    color: DailozColor.textgray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: (isHomeTeam ? homeTeamPlayers : awayTeamPlayers)
                          .where((player) => player['isOnField'])
                          .map((player) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (isHomeTeam) {
                                homeScore++;
                              } else {
                                awayScore++;
                              }
                              player['goals']++;
                              matchEvents.add({
                                'time': matchTime,
                                'type': 'goal',
                                'player': player['name'],
                                'team': isHomeTeam ? 'home' : 'away',
                              });
                            });
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: DailozColor.bggray,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    color: DailozColor.lightgreen,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${player['number']}',
                                    style: const TextStyle(
                                      color: DailozColor.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  player['name'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: DailozColor.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ))
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: DailozColor.bggray,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Annuler',
                    style: TextStyle(
                      color: DailozColor.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void addCard(bool isHomeTeam, bool isYellow) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: DailozColor.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.square_rounded,
                      size: 28,
                      color: isYellow ? Colors.yellow : Colors.red,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isYellow ? 'Carton Jaune' : 'Carton Rouge',
                      style: hsSemiBold.copyWith(
                        fontSize: 24,
                        color: DailozColor.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Sélectionnez le joueur',
                  style: TextStyle(
                    fontSize: 16,
                    color: DailozColor.textgray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: (isHomeTeam ? homeTeamPlayers : awayTeamPlayers)
                          .where((player) => player['isOnField'])
                          .map((player) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (isYellow) {
                                player['yellowCards']++;
                                if (player['yellowCards'] == 2) {
                                  player['redCards']++;
                                  player['isOnField'] = false;
                                }
                              } else {
                                player['redCards']++;
                                player['isOnField'] = false;
                              }
                              matchEvents.add({
                                'time': matchTime,
                                'type': isYellow ? 'yellowCard' : 'redCard',
                                'player': player['name'],
                                'team': isHomeTeam ? 'home' : 'away',
                              });
                            });
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: DailozColor.bggray,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    color: DailozColor.lightgreen,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${player['number']}',
                                    style: const TextStyle(
                                      color: DailozColor.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  player['name'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: DailozColor.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ))
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: DailozColor.bggray,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Annuler',
                    style: TextStyle(
                      color: DailozColor.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTeamDetails(bool isHomeTeam) {
    final players = isHomeTeam ? homeTeamPlayers : awayTeamPlayers;
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: DailozColor.bggray,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isHomeTeam ? homeTeam : awayTeam,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ...players
              .map((player) => Container(
                    margin: EdgeInsets.only(bottom: 8),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: DailozColor.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: DailozColor.lightgreen,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${player['number']}',
                                style: TextStyle(
                                  color: DailozColor.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              player['name'],
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            if (player['goals'] > 0)
                              Container(
                                margin: EdgeInsets.only(right: 4),
                                child: Row(
                                  children: [
                                    Icon(Icons.sports_soccer, size: 16),
                                    Text('${player['goals']}'),
                                  ],
                                ),
                              ),
                            if (player['yellowCards'] > 0)
                              Container(
                                margin: EdgeInsets.only(right: 4),
                                child: Icon(Icons.square_rounded,
                                    color: Colors.yellow, size: 16),
                              ),
                            if (player['redCards'] > 0)
                              Icon(Icons.square_rounded,
                                  color: Colors.red, size: 16),
                            if (!player['isOnField'])
                              Icon(Icons.person_off,
                                  color: Colors.grey, size: 16),
                          ],
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
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
        title: Text("PSG vs OM", style: hsSemiBold.copyWith(fontSize: 22)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isMatchStarted ? Icons.pause : Icons.play_arrow,
              size: 50,
            ),
            onPressed: isMatchStarted ? pauseMatch : startMatch,
            padding: EdgeInsets.symmetric(
                vertical: height / 100, horizontal: width / 25),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width / 36, vertical: height / 36),
          child: Column(
            children: [
              // Match Timer
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: DailozColor.lightred,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${matchTime.inMinutes}:${(matchTime.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: DailozColor.white,
                  ),
                ),
              ),
              SizedBox(height: height / 40),

              // Score Display
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
                          Icon(Icons.sports_soccer, size: width / 6),
                          Text(homeTeam,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                          Text('$homeScore',
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold)),
                          ElevatedButton(
                            onPressed: () => addGoal(true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[800],
                              foregroundColor: DailozColor.white,
                              padding: EdgeInsets.symmetric(
                                  vertical: height / 100,
                                  horizontal: width / 25),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 6,
                            ),
                            child: Text(
                              'Ajouter But',
                              style: hsSemiBold.copyWith(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text('VS',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Column(
                        children: [
                          Icon(Icons.sports_soccer, size: width / 6),
                          Text(awayTeam,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                          Text('$awayScore',
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold)),
                          ElevatedButton(
                            onPressed: () => addGoal(false),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[800],
                              foregroundColor: DailozColor.white,
                              padding: EdgeInsets.symmetric(
                                  vertical: height / 100,
                                  horizontal: width / 25),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 6,
                            ),
                            child: Text(
                              'Ajouter But',
                              style: hsSemiBold.copyWith(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: height / 36),

              // Quick Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildQuickActionButton(
                    'Carton Jaune',
                    Icons.square_rounded,
                    Colors.yellow,
                    () => addCard(true, true),
                  ),
                  _buildQuickActionButton(
                    'Carton Rouge',
                    Icons.square_rounded,
                    Colors.red,
                    () => addCard(true, false),
                  ),
                  const SizedBox(width: 50,),
                  _buildQuickActionButton(
                    'Carton Jaune',
                    Icons.square_rounded,
                    Colors.yellow,
                    () => addCard(false, true),
                  ),
                  _buildQuickActionButton(
                    'Carton Rouge',
                    Icons.square_rounded,
                    Colors.red,
                    () => addCard(false, false),
                  ),
                ],
              ),

              SizedBox(height: height / 36),

              // Team Details Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildTeamDetails(true)),
                  SizedBox(width: 10),
                  Expanded(child: _buildTeamDetails(false)),
                ],
              ),

              SizedBox(height: height / 36),

              // Match Events
              Container(
                padding: EdgeInsets.all(width / 36),
                decoration: BoxDecoration(
                  color: DailozColor.bggray,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Événements du match',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: height / 66),
                    if (matchEvents.isEmpty)
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: Text('Aucun événement pour le moment',
                              style: TextStyle(color: DailozColor.textgray)),
                        ),
                      ),
                    ...matchEvents.map((event) {
                      IconData icon;
                      Color color;
                      switch (event['type']) {
                        case 'goal':
                          icon = Icons.sports_soccer;
                          color = DailozColor.appcolor;
                          break;
                        case 'yellowCard':
                          icon = Icons.square_rounded;
                          color = Colors.yellow;
                          break;
                        case 'redCard':
                          icon = Icons.square_rounded;
                          color = Colors.red;
                          break;
                        default:
                          icon = Icons.error;
                          color = Colors.grey;
                      }

                      return ListTile(
                        leading: Icon(icon, color: color),
                        title: Text(
                          '${event['time'].inMinutes}:${(event['time'].inSeconds % 60).toString().padLeft(2, '0')} - ${event['player']}',
                          style: TextStyle(fontSize: 14),
                        ),
                        subtitle: Text(
                          '${event['team'] == 'home' ? homeTeam : awayTeam}',
                          style: TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
      String tooltip, IconData icon, Color color, VoidCallback onPressed) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, color: color,size: 35,),
        onPressed: onPressed,

      ),
    );
  }

  @override
  void dispose() {
    if (isMatchStarted) {
      _timer.cancel();
    }
    super.dispose();
  }
}
