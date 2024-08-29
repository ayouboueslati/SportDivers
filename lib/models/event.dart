class Event {
  final int id;
  final String titre;
  final String description;
  final String image;
  final String start;
  final String end;

  Event({
    required this.id,
    required this.titre,
    required this.description,
    required this.image,
    required this.start,
    required this.end,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      titre: json['titre'],
      description: json['description'],
      image: json['image'],
      start: json['start'],
      end: json['end'],
    );
  }
}