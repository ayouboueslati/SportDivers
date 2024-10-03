class Match {
  final String homeTeam;
  final String awayTeam;
  final String date;
  final String time;
  final String homeTeamLogo;
  final String awayTeamLogo;
  final String matchStatus;
  final String place;

  Match({
    required this.homeTeam,
    required this.awayTeam,
    required this.date,
    required this.time,
    required this.homeTeamLogo,
    required this.awayTeamLogo,
    required this.matchStatus,
    required this.place,
  });
}

final List<Match> matches = [
  Match(
    homeTeam: "Team A",
    awayTeam: "Team B",
    date: "01 Oct 2024",
    time: "15:00",
    homeTeamLogo: "assets/images/gafsa.png", // Replace with actual paths to images
    awayTeamLogo: "assets/images/barca.png",
    matchStatus: "Upcoming",
    place: "Rades",
  ),
  Match(
    homeTeam: "Team C",
    awayTeam: "Team D",
    date: "01 Oct 2024",
    time: "18:00",
    homeTeamLogo: "assets/images/CA.png",
    awayTeamLogo: "assets/images/barca.png",
    matchStatus: "Live",
    place: "Rades",
  ),
  Match(
    homeTeam: "Team E",
    awayTeam: "Team F",
    date: "02 Oct 2024",
    time: "12:00",
    homeTeamLogo: "assets/images/inter.png",
    awayTeamLogo: "assets/images/gafsa.png",
    matchStatus: "Finished",
    place: "Rades",
  ),
  Match(
    homeTeam: "Team C",
    awayTeam: "Team D",
    date: "01 Oct 2024",
    time: "18:00",
    homeTeamLogo: "assets/images/CA.png",
    awayTeamLogo: "assets/images/barca.png",
    matchStatus: "Live",
    place: "Rades",
  ),
  Match(
    homeTeam: "Team A",
    awayTeam: "Team B",
    date: "01 Oct 2024",
    time: "15:00",
    homeTeamLogo: "assets/images/gafsa.png", // Replace with actual paths to images
    awayTeamLogo: "assets/images/barca.png",
    matchStatus: "Upcoming",
    place: "Rades",
  ),
  Match(
    homeTeam: "Team E",
    awayTeam: "Team F",
    date: "02 Oct 2024",
    time: "12:00",
    homeTeamLogo: "assets/images/inter.png",
    awayTeamLogo: "assets/images/gafsa.png",
    matchStatus: "Finished",
    place: "Rades",
  ),
  Match(
    homeTeam: "Team A",
    awayTeam: "Team B",
    date: "01 Oct 2024",
    time: "15:00",
    homeTeamLogo: "assets/images/gafsa.png", // Replace with actual paths to images
    awayTeamLogo: "assets/images/barca.png",
    matchStatus: "Upcoming",
    place: "Rades",
  ),
  Match(
    homeTeam: "Team A",
    awayTeam: "Team B",
    date: "01 Oct 2024",
    time: "15:00",
    homeTeamLogo: "assets/images/gafsa.png", // Replace with actual paths to images
    awayTeamLogo: "assets/images/barca.png",
    matchStatus: "Upcoming",
    place: "Rades",
  ),
  Match(
    homeTeam: "Team A",
    awayTeam: "Team B",
    date: "01 Oct 2024",
    time: "15:00",
    homeTeamLogo: "assets/images/gafsa.png", // Replace with actual paths to images
    awayTeamLogo: "assets/images/barca.png",
    matchStatus: "Upcoming",
    place: "Rades",
  )
];