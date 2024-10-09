import 'package:flutter/material.dart';
import 'package:sportdivers/Provider/PollsProvider/PollsProvider.dart';
import 'package:sportdivers/models/PollsModel.dart';
import 'package:provider/provider.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_fontstyle.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_icons.dart';

class PollSurveyPage extends StatelessWidget {
  static const String id = 'Poll_Survey_Page';

  @override
  Widget build(BuildContext context) {
    final pollProvider = Provider.of<PollProvider>(context);
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      backgroundColor: DailozColor.bggray,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            splashColor: DailozColor.transparent,
            highlightColor: DailozColor.transparent,
            onTap: () => Navigator.pop(context),
            child: Container(
              height: height / 20,
              width: height / 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: DailozColor.white,
                boxShadow: [
                  BoxShadow(color: DailozColor.textgray, blurRadius: 5)
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(left: width / 56),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 18,
                  color: DailozColor.black,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          'Sondages',
          style: hsSemiBold.copyWith(fontSize: 18),
        ),
        backgroundColor: DailozColor.white,
        elevation: 0,
      ),
      body: pollProvider.isLoading
          ? Center(child: CircularProgressIndicator(color: DailozColor.appcolor))
          : pollProvider.pollInstances.isEmpty
          ? _buildNoPollsDialog(context)
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sondages disponibles',
                style: hsSemiBold.copyWith(
                  fontSize: 24,
                  color: DailozColor.black,
                ),
              ),
              SizedBox(height: height / 36),
              ...pollProvider.pollInstances.map((pollInstance) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuestionCard(pollInstance, width, height),
                    SizedBox(height: height / 36),
                    ...pollInstance.poll.options.asMap().entries.map(
                            (entry) => _buildOptionCard(pollProvider,
                            pollInstance, entry.key, width, height)),
                    SizedBox(height: height / 36),
                    _buildSubmitButton(
                        pollProvider, pollInstance, width, height),
                    SizedBox(height: height / 24),
                  ],
                );
              }).toList(),
            ],
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
                color: DailozColor.appcolor,
              ),
              SizedBox(height: 20),
              Text(
                'Aucun sondage disponible',
                style: hsBold.copyWith(
                  fontSize: 24,
                  color: DailozColor.appcolor,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Il n\'y a actuellement aucun sondage auquel participer.',
                textAlign: TextAlign.center,
                style: hsRegular.copyWith(
                  fontSize: 16,
                  color: DailozColor.textgray,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: DailozColor.lightred,
                  foregroundColor: DailozColor.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Retourner',
                  style: hsSemiBold.copyWith(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(
      PollInstance pollInstance, double width, double height) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: DailozColor.lightred,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding:
        EdgeInsets.symmetric(horizontal: width / 36, vertical: height / 56),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question',
              style: hsMedium.copyWith(
                fontSize: 18,
                color: DailozColor.white.withOpacity(0.8),
              ),
            ),
            SizedBox(height: height / 100),
            Text(
              pollInstance.poll.text,
              style: hsMedium.copyWith(
                fontSize: 18,
                color: DailozColor.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
      PollProvider pollProvider,
      PollInstance pollInstance,
      int index,
      double width,
      double height,
      ) {
    final option = pollInstance.poll.options[index];
    final userAnswer = pollProvider.getUserAnswer(pollInstance.id);
    final isSelected = pollProvider.selectedPollId == pollInstance.id &&
        pollProvider.selectedOptionId == option.id;
    final isPreviousAnswer = userAnswer == option.id;

    return InkWell(
      splashColor: DailozColor.transparent,
      highlightColor: DailozColor.transparent,
      onTap: () {
        pollProvider.selectPoll(pollInstance.id);
        pollProvider.selectOption(option.id);
      },
      child: Row(
        children: [
          Icon(
            isPreviousAnswer || isSelected
                ? Icons.check_box_sharp
                : Icons.check_box_outline_blank,
            size: 22,
            color: isPreviousAnswer || isSelected
                ? DailozColor.appcolor
                : DailozColor.textgray,
          ),
          SizedBox(width: width / 36),
          Expanded(
            child: Text(
              option.text,
              style: hsRegular.copyWith(fontSize: 16, color: DailozColor.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(
      PollProvider pollProvider,
      PollInstance pollInstance,
      double width,
      double height,
      ) {
    bool isSelected = pollProvider.selectedPollId == pollInstance.id &&
        pollProvider.selectedOptionId != null;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: DailozColor.lightred,
          foregroundColor: DailozColor.white,
          padding: EdgeInsets.symmetric(vertical: height / 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: isSelected ? () => pollProvider.submitVote() : null,
        child: Text(
          pollProvider.getUserAnswer(pollInstance.id) != null
              ? 'Changer de vote'
              : 'Soumettre le vote',
          style: hsSemiBold.copyWith(fontSize: 16),
        ),
      ),
    );
  }
}