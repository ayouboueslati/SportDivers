import 'package:flutter/material.dart';
import 'package:sportdivers/Provider/constantsProvider.dart';
import 'package:sportdivers/models/PollsModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PollProvider with ChangeNotifier {
  bool isLoading = true;
  List<PollInstance> pollInstances = [];
  Map<String, String> userAnswers = {};
  Map<String, Map<String, double>> votePercentages = {};
  Map<String, Map<String, int>> voteCounts = {};
  String? errorMessage;
  String? selectedPollId;
  String? selectedOptionId;
  Map<String, bool> changeVoteMode = {};

  PollProvider() {
    fetchPollData();
  }

  Future<void> fetchPollData() async {
    final url = Uri.parse('${Constants.baseUrl}/polls/instances');
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        pollInstances = data.map((json) => PollInstance.fromJson(json)).toList();

        // Load user answers from the API response
        for (var poll in pollInstances) {
          if (poll.answerId != null) {
            userAnswers[poll.id] = poll.answerId!;
          }
        }

        await fetchVotePercentages();
        await fetchVoteCounts();
        isLoading = false;
        notifyListeners();
      } else {
        throw Exception('Failed to load poll data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching poll data: $error');
      errorMessage = 'Failed to load polls. Please try again later.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchVotePercentages() async {
    for (var poll in pollInstances) {
      final url = Uri.parse('${Constants.baseUrl}/polls/instances/${poll.id}/results');
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');

        if (token == null) {
          throw Exception('Token not found');
        }

        final response = await http.get(url, headers: {
          'Authorization': 'Bearer $token',
        });

        if (response.statusCode == 200) {
          final data = json.decode(response.body) as Map<String, dynamic>;
          votePercentages[poll.id] = Map<String, double>.from(data['percentages']);
        } else {
          throw Exception('Failed to load vote percentages: ${response.statusCode}');
        }
      } catch (error) {
        print('Error fetching vote percentages for poll ${poll.id}: $error');
      }
    }
    notifyListeners();
  }
  Future<void> fetchVoteCounts() async {
    for (var poll in pollInstances) {
      final url = Uri.parse('${Constants.baseUrl}/polls/instances/${poll.id}/results');
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');

        if (token == null) {
          throw Exception('Token not found');
        }

        final response = await http.get(url, headers: {
          'Authorization': 'Bearer $token',
        });

        if (response.statusCode == 200) {
          final data = json.decode(response.body) as Map<String, dynamic>;
          voteCounts[poll.id] = Map<String, int>.from(data['counts']);
        } else {
          throw Exception('Failed to load vote counts: ${response.statusCode}');
        }
      } catch (error) {
        print('Error fetching vote counts for poll ${poll.id}: $error');
      }
    }
    notifyListeners();
  }

  void toggleChangeVoteMode(String pollId) {
    changeVoteMode[pollId] = !(changeVoteMode[pollId] ?? false);
    if (changeVoteMode[pollId]!) {
      // Entering change vote mode, reset selection
      if (selectedPollId == pollId) {
        selectedOptionId = null;
      }
    } else {
      // Exiting change vote mode, reset selection
      if (selectedPollId == pollId) {
        selectedPollId = null;
        selectedOptionId = null;
      }
    }
    notifyListeners();
  }

  bool isChangeVoteModeActive(String pollId) {
    return changeVoteMode[pollId] ?? false;
  }

  void selectPoll(String pollId) {
    selectedPollId = pollId;
    notifyListeners();
  }

  void selectOption(String pollId, String optionId) {
    if (isChangeVoteModeActive(pollId) || getUserAnswer(pollId) == null) {
      selectedPollId = pollId;
      selectedOptionId = optionId;
      notifyListeners();
    }
  }

  Future<void> submitVote() async {
    if (selectedPollId == null || selectedOptionId == null) {
      errorMessage = 'Please select an option before submitting.';
      notifyListeners();
      return;
    }

    errorMessage = null;
    notifyListeners();

    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.put(
        Uri.parse('${Constants.baseUrl}/polls/instances/$selectedPollId/submit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'answer': selectedOptionId,
        }),
      );

      if (response.statusCode == 200) {
        userAnswers[selectedPollId!] = selectedOptionId!;
        changeVoteMode[selectedPollId!] = false;
        await fetchVotePercentages();
        await fetchVoteCounts();
      } else {
        throw Exception('Failed to submit vote: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      print('Error submitting vote: $error');
      errorMessage = 'Failed to submit vote. Please try again.';
    } finally {
      notifyListeners();
    }
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  String? getUserAnswer(String pollId) {
    return userAnswers[pollId];
  }

  Map<String, double>? getVotePercentages(String pollId) {
    return votePercentages[pollId];
  }
  // Update the getter method
  Map<String, int>? getVoteCounts(String pollId) {
    return voteCounts[pollId];
  }
  void printDebugInfo() {
    print('User Answers: $userAnswers');
    print('Vote Percentages: $votePercentages');
  }
}