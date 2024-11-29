import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportdivers/Provider/ChampionatProviders/ConvocationProvider.dart';
import 'package:sportdivers/models/ConvocationStudModel.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_fontstyle.dart';


class ConvocationPage extends StatefulWidget {
  static String id = 'Convocation_Screen';
  final String matchId; // New parameter
  final String teamId;
  final List<String> coachTeams;

  const ConvocationPage({
    Key? key,
    required this.matchId,
    required this.teamId,
    required this.coachTeams,
  }) : super(key: key);

  @override
  _ConvocationPageState createState() => _ConvocationPageState();
}

class _ConvocationPageState extends State<ConvocationPage> {
  @override
  void initState() {
    super.initState();
    // Validate team belongs to coach before fetching
    if (!widget.coachTeams.contains(widget.teamId)) {
      // Show an error or prevent access
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vous n\'êtes pas autorisé à convoquer cette équipe'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context);
        return;
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ConvocationProvider>(context, listen: false)
          .fetchGroupStudents(widget.teamId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      appBar: AppBar(
        leading: _buildBackButton(height, width),
        title: Text(
          'Convocation',
          style: hsBold.copyWith(
            color: DailozColor.black,
            fontSize: 22,
          ),
        ),
        backgroundColor: DailozColor.white,
        elevation: 0,
        actions: [_buildSubmitButton(context)],
      ),
      body: Consumer<ConvocationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return _buildLoadingIndicator();
          }

          if (provider.errorMessage != null) {
            return _buildErrorWidget(provider.errorMessage!);
          }

          if (provider.students.isEmpty) {
            return _buildEmptyListWidget();
          }

          return _buildStudentList(provider);
        },
      ),
    );
  }

  Widget _buildBackButton(double height, double width) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Container(
          height: height / 20,
          width: height / 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: DailozColor.white,
            boxShadow: [
              BoxShadow(
                  color: DailozColor.grey.withOpacity(0.3),
                  blurRadius: 5
              )
            ],
          ),
          child: const Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: DailozColor.black,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Consumer<ConvocationProvider>(
        builder: (context, provider, child) {
          return ElevatedButton.icon(
            icon: const Icon(Icons.save, color: Colors.white),
            label: Text('Valider', style: hsMedium.copyWith(color: Colors.white)),
            onPressed: provider.selectedStudentIds.isNotEmpty
                ? () => _submitConvocation(context, provider)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }

  void _submitConvocation(BuildContext context, ConvocationProvider provider) async {
    final result = await provider.submitConvocation(
        matchId: widget.matchId,
        teamId: widget.teamId,
        coachTeams: widget.coachTeams
    );

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'adhérents convoqués',
              style: hsRegular
          ),
          backgroundColor: Colors.green[600],
        ),
      );
      Navigator.pop(context, provider.selectedStudentIds);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Échec de la convocation', style: hsRegular),
          backgroundColor: Colors.red[600],
        ),
      );
    }
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(color: Colors.blue[800]),
    );
  }

  Widget _buildErrorWidget(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 100, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            style: hsRegular.copyWith(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyListWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group_off, size: 100, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Aucun adhérent trouvé',
            style: hsRegular.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentList(ConvocationProvider provider) {
    return ListView.builder(
      itemCount: provider.students.length,
      itemBuilder: (context, index) {
        final student = provider.students[index];
        final isSelected = provider.selectedStudentIds.contains(student.id);

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildStudentAvatar(student),
                const SizedBox(width: 16),
                _buildStudentInfo(student, isSelected, provider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStudentAvatar(Student student) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: DailozColor.grey,
      backgroundImage: student.profilePicture != null
          ? NetworkImage(student.profilePicture!)
          : null,
      child: student.profilePicture == null
          ? Text(
        student.initials,
        style: hsBold.copyWith(fontSize: 24, color: Colors.white),
      )
          : null,
    );
  }
  Widget _buildStudentInfo(
      Student student,
      bool isSelected,
      ConvocationProvider provider
      ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            student.fullName,
            style: hsSemiBold.copyWith(
              fontSize: 18,
              color: Colors.blue[600],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Convoque :',
                style: hsMedium.copyWith(
                  fontSize: 16,
                  color: Colors.green[400],
                ),
              ),
              const SizedBox(width: 15,),
              Switch(
                value: isSelected,
                onChanged: (_) {
                  provider.toggleStudentSelection(student.id);
                },
                activeColor: Colors.green[400],
              ),
              const SizedBox(width: 15,),
            ],
          ),
        ],
      ),
    );
  }
}