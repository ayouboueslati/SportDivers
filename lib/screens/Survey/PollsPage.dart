import 'package:flutter/material.dart';
import 'package:sportdivers/Provider/PollsProvider/PollsProvider.dart';
import 'package:sportdivers/models/PollsModel.dart';
import 'package:provider/provider.dart';

class PollSurveyPage extends StatelessWidget {
  static const String id = 'Poll_Survey_Page';

  @override
  Widget build(BuildContext context) {
    final pollProvider = Provider.of<PollProvider>(context);

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
          'Sondages',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: pollProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : pollProvider.pollInstances.isEmpty
          ? _buildNoPollsDialog(context)
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: pollProvider.pollInstances.map((pollInstance) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildQuestionCard(pollInstance),
                  SizedBox(height: 20),
                  ...pollInstance.poll.options.asMap().entries.map(
                          (entry) => _buildOptionCard(
                          pollProvider, pollInstance, entry.key)),
                  SizedBox(height: 20),
                  _buildSubmitButton(pollProvider, pollInstance),
                  SizedBox(height: 40),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNoPollsDialog(BuildContext context) {
    return Center(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.poll_outlined,
                size: 64,
                color: Colors.blue[900],
              ),
              SizedBox(height: 20),
              Text(
                'Aucun sondage disponible',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Il n’y a actuellement aucun sondage auquel participer.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Retourner',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(PollInstance pollInstance) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          pollInstance.poll.text,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(
      PollProvider pollProvider, PollInstance pollInstance, int index) {
    final option = pollInstance.poll.options[index];
    final userAnswer = pollProvider.getUserAnswer(pollInstance.id);
    //final voteCounts = pollProvider.getVoteCounts(pollInstance.id);
    // final count = voteCounts != null ? voteCounts[option.id] ?? 0 : 0;
    final isSelected = pollProvider.selectedPollId == pollInstance.id &&
        pollProvider.selectedOptionId == option.id;
    final isPreviousAnswer = userAnswer == option.id;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isPreviousAnswer
            ? Colors.green[50]
            : (isSelected ? Colors.blue[50] : Colors.white),
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
            pollProvider.selectPoll(pollInstance.id);
            pollProvider.selectOption(option.id);
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    option.text,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: isPreviousAnswer || isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
                // if (userAnswer != null)
                //   Text(
                //     '$count votes',
                //     style: TextStyle(
                //       fontSize: 16,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.blue[700],
                //     ),
                //   ),
                if (isPreviousAnswer)
                  Icon(Icons.check_circle, color: Colors.green, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(
      PollProvider pollProvider, PollInstance pollInstance) {
    bool isSelected = pollProvider.selectedPollId == pollInstance.id &&
        pollProvider.selectedOptionId != null;

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
        onPressed: isSelected ? () => pollProvider.submitVote() : null,
        child: Text(
          pollProvider.getUserAnswer(pollInstance.id) != null
              ? 'Changer de vote'
              : 'Soumettre le vote',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
