import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportdivers/Provider/ChampionatProviders/ArbitratorProvider.dart';
import 'package:sportdivers/models/MatchDetailsModel.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_fontstyle.dart';

class ArbitratorMatchPage extends StatefulWidget {
  final Match match;

  const ArbitratorMatchPage({Key? key, required this.match}) : super(key: key);

  @override
  _ArbitratorMatchPageState createState() => _ArbitratorMatchPageState();
}

class _ArbitratorMatchPageState extends State<ArbitratorMatchPage> with WidgetsBindingObserver {
  late MatchActionProvider _matchActionProvider;

  int homeScore = 0;
  int awayScore = 0;
  bool isMatchStarted = false;
  Duration matchTime = Duration.zero;

  Timer? _timer;
  DateTime? _startTime;

  // Use match details from the passed MatchByRole object
  late String homeTeam;
  late String awayTeam;
  late String homeTeamLogo;
  late String awayTeamLogo;

  List<Map<String, dynamic>> homeTeamPlayers = [];
  List<Map<String, dynamic>> awayTeamPlayers = [];
  List<Map<String, dynamic>> matchEvents = [];

  @override
  void initState() {
    super.initState();

    // Initialize the match action provider
    _matchActionProvider = MatchActionProvider(matchId: widget.match.id);

    homeTeam = widget.match.firstTeam.designation;
    awayTeam = widget.match.secondTeam.designation;
    homeTeamLogo = widget.match.firstTeam.photo!;
    awayTeamLogo = widget.match.secondTeam.photo!;

    // Initialize players (you might want to fetch actual player data)
    homeTeamPlayers = _initializePlayers(true);
    awayTeamPlayers = _initializePlayers(false);

    // Calculate initial score based on match actions
    homeScore = _calculateTeamScore(widget.match.actions, widget.match.firstTeam.id);
    awayScore = _calculateTeamScore(widget.match.actions, widget.match.secondTeam.id);

    _restoreMatchState();
  }


  List<Map<String, dynamic>> _initializePlayers(bool isHomeTeam) {
    // Get the team based on whether it's home or away
    Team team = isHomeTeam ? widget.match.firstTeam : widget.match.secondTeam;

    // Check if the team has players
    if (team.players == null || team.players!.isEmpty) {
      // If no players, return a default placeholder
      return [
        {
          'id': 'Unknown',
          'name': 'No Players',
          'number': 0,
          'goals': 0,
          'yellowCards': 0,
          'redCards': 0,
          'isOnField': false
        }
      ];
    }

    // Map the players from the model to the required format
    return team.players!.map((player) {
      // Calculate goals for this player from match actions
      int goals = widget.match.actions
          .where((action) =>
      action.type == 'GOAL' &&
          action.target == player.id)
          .length;

      // Calculate yellow cards
      int yellowCards = widget.match.actions
          .where((action) =>
      action.type == 'YELLOW_CARD' &&
          action.target == player.id)
          .length;

      // Calculate red cards
      int redCards = widget.match.actions
          .where((action) =>
      action.type == 'RED_CARD' &&
          action.target == player.id)
          .length;

      return {
        'id': player.id,
        'name': player.fullName,
        'number': 0, // You might want to add jersey number to the Player model
        'goals': goals,
        'yellowCards': yellowCards,
        'redCards': redCards,
        'isOnField': true // Assuming all players start on the field
      };
    }).toList();
  }

  int _calculateTeamScore(List<dynamic> actions, String teamId) {
    return actions
        .where((action) => action.type == 'GOAL' && action.targetTeam == teamId)
        .length;
  }


  Future<void> _restoreMatchState() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if the stored match ID matches the current match
    final storedMatchId = prefs.getString('current_match_id');
    if (storedMatchId != widget.match.id) {
      return;
    }

    setState(() {
      // Restore match time
      final savedSeconds = prefs.getInt('match_time_seconds') ?? 0;
      matchTime = Duration(seconds: savedSeconds);

      // Restore match started state
      isMatchStarted = prefs.getBool('is_match_started') ?? false;
    });

    // If match was running when app was closed, restart the timer
    if (isMatchStarted) {
      // Calculate elapsed time since last save
      final lastSaveTimeString = prefs.getString('last_save_time');
      if (lastSaveTimeString != null) {
        final lastSaveTime = DateTime.parse(lastSaveTimeString);
        final elapsedTime = DateTime.now().difference(lastSaveTime);
        matchTime += elapsedTime;
      }

      startMatch();
    }
  }

  Future<void> _saveMatchState() async {
    final prefs = await SharedPreferences.getInstance();

    await Future.wait([
      prefs.setString('current_match_id', widget.match.id),
      prefs.setInt('match_time_seconds', matchTime.inSeconds),
      prefs.setBool('is_match_started', isMatchStarted),
      prefs.setString('last_save_time', DateTime.now().toIso8601String())
    ]);
  }

  void startMatch() {
    // Cancel any existing timer
    _timer?.cancel();

    setState(() {
      isMatchStarted = true;
    });

    // Start a new timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        matchTime += Duration(seconds: 1);
        _saveMatchState();
      });
    });
  }

  void pauseMatch() {
    // Null-check before cancelling
    _timer?.cancel();

    setState(() {
      isMatchStarted = false;
    });

    _saveMatchState();
  }

  // In your build method, modify the play/pause button
  IconButton buildMatchControlButton() {
    return IconButton(
      icon: Icon(
        isMatchStarted ? Icons.pause : Icons.play_arrow,
        size: 50,
      ),
      onPressed: () {
        // Safely handle starting or pausing the match
        if (isMatchStarted) {
          pauseMatch();
        } else {
          startMatch();
        }
      },
      padding: EdgeInsets.symmetric(
          vertical: 10, horizontal: 10),
    );
  }

  @override
  void dispose() {
    // Ensure timer is cancelled when the widget is disposed
    _timer?.cancel();
    super.dispose();
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
                            _matchActionProvider.addMatchAction(
                                type: 'GOAL',
                                minute: matchTime.inMinutes,
                                targetTeam: isHomeTeam
                                    ? widget.match.firstTeam.id
                                    : widget.match.secondTeam.id,
                                target: player['id']
                            ).then((success) {
                              if (success) {
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
                              } else {
                                // Show error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            _matchActionProvider.errorMessage ??
                                                'Failed to add goal'
                                        )
                                    )
                                );
                              }
                            });
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
                        // ... (existing container code)
                        child: InkWell(
                          onTap: () {
                            String cardType = isYellow ? 'YELLOW_CARD' : 'RED_CARD';

                            _matchActionProvider.addMatchAction(
                                type: cardType,
                                minute: matchTime.inMinutes,
                                targetTeam: isHomeTeam
                                    ? widget.match.firstTeam.id
                                    : widget.match.secondTeam.id,
                                target: player['id']
                            ).then((success) {
                              if (success) {
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
                              } else {
                                // Show error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            _matchActionProvider.errorMessage ??
                                                'Failed to add card'
                                        )
                                    )
                                );
                              }
                            });
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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine responsiveness based on available width
        final isNarrow = constraints.maxWidth < 350;
        final isWide = constraints.maxWidth > 600;

        return Container(
          padding: EdgeInsets.all(isNarrow ? 6 : 10),
          decoration: BoxDecoration(
            color: DailozColor.bggray,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isHomeTeam ? homeTeam : awayTeam,
                style: TextStyle(
                    fontSize: isNarrow ? 14 : 16,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 10),
              ...players.map((player) => Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.all(isNarrow ? 6 : 8),
                decoration: BoxDecoration(
                  color: DailozColor.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: isNarrow ? 20 : 24,
                            height: isNarrow ? 20 : 24,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: DailozColor.lightgreen,
                              shape: BoxShape.circle,
                            ),
                            child: FittedBox(
                              child: Text(
                                '${player['number']}',
                                style: TextStyle(
                                  color: DailozColor.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              player['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: isNarrow ? 12 : 14,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        if (player['goals'] > 0)
                          Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: Row(
                              children: [
                                Icon(
                                    Icons.sports_soccer,
                                    size: isNarrow ? 14 : 16
                                ),
                                Text(
                                  '${player['goals']}',
                                  style: TextStyle(
                                      fontSize: isNarrow ? 12 : 14
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (player['yellowCards'] > 0)
                          Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: Icon(
                                Icons.square_rounded,
                                color: Colors.yellow,
                                size: isNarrow ? 14 : 16
                            ),
                          ),
                        if (player['redCards'] > 0)
                          Icon(
                              Icons.square_rounded,
                              color: Colors.red,
                              size: isNarrow ? 14 : 16
                          ),
                        if (!player['isOnField'])
                          Icon(
                              Icons.person_off,
                              color: Colors.grey,
                              size: isNarrow ? 14 : 16
                          ),
                      ],
                    ),
                  ],
                ),
              )).toList(),
            ],
          ),
        );
      },
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
        title: Text("Arbitrage", style: hsSemiBold.copyWith(fontSize: 22)),
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
                          Image.network(
                            homeTeamLogo,
                            width: width / 6,
                            height: width / 6,
                            fit: BoxFit.contain,
                          ),
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
                          Image.network(
                            awayTeamLogo,
                            width: width / 6,
                            height: width / 6,
                            fit: BoxFit.contain,
                          ),
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

}