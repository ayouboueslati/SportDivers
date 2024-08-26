import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PollSurveyPage extends StatefulWidget {
  static const String id = 'Poll_Survey_Page';

  @override
  _PollSurveyPageState createState() => _PollSurveyPageState();
}

class _PollSurveyPageState extends State<PollSurveyPage> {
  String question = "What's your favorite sports event?";
  List<String> options = ["Olympics", "World Cup", "Super Bowl", "Wimbledon"];
  List<int> votes = [45, 30, 15, 10];
  int? selectedOption;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPollData();
  }

  Future<void> fetchPollData() async {
    // Simulating API call
    await Future.delayed(Duration(seconds: 2));
    // TODO: Replace with actual API call
    // final response = await http.get(Uri.parse('https://your-api.com/poll-data'));
    // if (response.statusCode == 200) {
    //   final data = json.decode(response.body);
    //   setState(() {
    //     question = data['question'];
    //     options = List<String>.from(data['options']);
    //     votes = List<int>.from(data['votes']);
    //     isLoading = false;
    //   });
    // } else {
    //   throw Exception('Failed to load poll data');
    // }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> submitVote() async {
    if (selectedOption == null) return;

    setState(() {
      isLoading = true;
    });

    // TODO: Replace with actual API call
    // final response = await http.post(
    //   Uri.parse('https://your-api.com/submit-vote'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: json.encode({'optionIndex': selectedOption}),
    // );
    // if (response.statusCode == 200) {
    //   // Vote submitted successfully
    //   fetchPollData(); // Refresh data
    // } else {
    //   throw Exception('Failed to submit vote');
    // }

    // Simulating API call
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      votes[selectedOption!]++;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        toolbarHeight: 60,
        shadowColor: Colors.grey.withOpacity(0.3),
        elevation: 5,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.blue[900],
        title: const Text(
          'Poll Survey',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuestionCard(),
                    SizedBox(height: 20),
                    ...options
                        .asMap()
                        .entries
                        .map((entry) => _buildOptionCard(entry.key)),
                    SizedBox(height: 20),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildQuestionCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          question,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(int index) {
    bool isSelected = selectedOption == index;
    int totalVotes = votes.reduce((a, b) => a + b);
    double percentage = totalVotes > 0 ? votes[index] / totalVotes : 0;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue[50] : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            setState(() {
              selectedOption = index;
            });
          },
          child: Stack(
            children: [
              FractionallySizedBox(
                widthFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      options[index],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: Colors.blue[900],
                      ),
                    ),
                    Text(
                      '${(percentage * 100).toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[900],
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: selectedOption != null ? submitVote : null,
        child: Text(
          'Submit Vote',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
