class PollOption {
  final String id;
  final String text;

  PollOption({required this.id, required this.text});

  factory PollOption.fromJson(Map<String, dynamic> json) {
    return PollOption(
      id: json['id'],
      text: json['text'],
    );
  }
}

class Poll {
  final String id;
  final String text;
  final List<PollOption> options;

  Poll({required this.id, required this.text, required this.options});

  factory Poll.fromJson(Map<String, dynamic> json) {
    return Poll(
      id: json['id'],
      text: json['text'],
      options: (json['options'] as List)
          .map((optionJson) => PollOption.fromJson(optionJson))
          .toList(),
    );
  }
}

class PollInstance {
  final String id;
  final String name;
  final String createdAt;
  final Poll poll;
  final dynamic answer;  // Changed to dynamic to handle potential Map

  PollInstance({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.poll,
    this.answer,
  });

  factory PollInstance.fromJson(Map<String, dynamic> json) {
    return PollInstance(
      id: json['id'],
      name: json['name'],
      createdAt: json['createdAt'],
      poll: Poll.fromJson(json['poll']),
      answer: json['answer'],
    );
  }

  String? get answerId {
    if (answer is String) {
      return answer as String;
    } else if (answer is Map<String, dynamic>) {
      return (answer as Map<String, dynamic>)['id'] as String?;
    }
    return null;
  }
}