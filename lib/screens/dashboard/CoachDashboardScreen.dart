import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportdivers/Provider/TrainingSchedule/CoachDashboardProvider.dart';
import 'package:sportdivers/components/CustomToast.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_color.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_fontstyle.dart';

class CoachDashboardScreen extends StatefulWidget {
  static String id = 'Coach_Dashboard_Screen';

  final DateTime sessionDate;
  final String sessionId;
  final String groupId;

  const CoachDashboardScreen({
    Key? key,
    required this.sessionDate,
    required this.sessionId,
    required this.groupId,
  }) : super(key: key);

  @override
  _CoachDashboardScreenState createState() => _CoachDashboardScreenState();
}

class _CoachDashboardScreenState extends State<CoachDashboardScreen> {
  Map<String, bool> attendance = {};
  Map<String, Map<String, double>> ratings = {};
  List<dynamic> students = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    try {
      final loadedStudents = await apiProvider.getStudents();
      setState(() {
        students = loadedStudents
            .where((student) =>
        student['profile']['group'] != null &&
            student['profile']['group']['id'] == widget.groupId)
            .toList();
        for (var student in students) {
          final studentId = student['profile']['id'];
          attendance[studentId] = false;
          ratings[studentId] = {
            'grade1': 0,
            'grade2': 0,
            'grade3': 0,
            'grade4': 0,
          };
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec du chargement des étudiants: $e', style: hsRegular)),
      );
    }
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
            onTap: () => Navigator.pop(context),
            child: Container(
              height: height / 20,
              width: height / 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: DailozColor.white,
                boxShadow: [
                  BoxShadow(
                      color: DailozColor.grey.withOpacity(0.3), blurRadius: 5)
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
          'Session ${widget.sessionDate.toString().split(' ')[0]}',
          style: hsBold.copyWith(
            color: DailozColor.black,
            fontSize: 22,
          ),
        ),
        backgroundColor: DailozColor.white,
        elevation: 0,
        actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.save, color: Colors.white),
            label: Text('Valider', style: hsMedium.copyWith(color: Colors.white)),
            onPressed: _saveAttendanceAndGrades,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],

      ),
      body: isLoading
          ?  Center(child: CircularProgressIndicator(color: Colors.blue[800]))
          : ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          final studentId = student['profile']['id'];

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
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: student['profile']['profilePicture'] != null
                        ? NetworkImage(student['profile']['profilePicture'])
                        : null,
                    backgroundColor: Colors.blue[800],
                    child: student['profile']['profilePicture'] == null
                        ? Text(
                      student['profile']['firstName'][0],
                      style: hsBold.copyWith(fontSize: 24, color: Colors.white),
                    )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${student['profile']['firstName']} ${student['profile']['lastName']}',
                          style: hsSemiBold.copyWith(
                            fontSize: 18,
                            color: Colors.blue[800],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Présent:',
                              style: hsMedium.copyWith(
                                fontSize: 16,
                                color: Colors.blue[800],
                              ),
                            ),
                            Switch(
                              value: attendance[studentId]!,
                              onChanged: (value) {
                                setState(() {
                                  attendance[studentId] = value;
                                });
                              },
                              activeColor: Colors.blue[800],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () => _showGradingDialog(context, studentId),
                    child: Text('Note', style: hsRegular.copyWith(color: Colors.white)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   icon: const Icon(Icons.save, color: Colors.white),
      //   label: Text('Valider', style: hsMedium.copyWith(color: Colors.white)),
      //   onPressed: _saveAttendanceAndGrades,
      //   backgroundColor: Colors.blue[800],
      // ),
    );
  }

  void _showGradingDialog(BuildContext context, String studentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Noter l\'étudiant', style: hsBold.copyWith(color: Colors.blue[800])),
              content: Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildGradeSlider('Assiduité', studentId, 'grade1', setState),
                    _buildGradeSlider('Comportement', studentId, 'grade2', setState),
                    _buildGradeSlider('Performance', studentId, 'grade3', setState),
                    _buildGradeSlider('Jeu Collectif', studentId, 'grade4', setState),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Annuler', style: hsMedium.copyWith(color: Colors.blue[800])),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    double average = _calculateAverageGrade(studentId);
                    Navigator.of(context).pop();
                    this.setState(() {});
                    _showAverageGradeToast(average);
                  },
                  child: Text('Enregistrer', style: hsRegular),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildGradeSlider(String label, String studentId, String gradeKey, Function setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: hsSemiBold.copyWith(color: Colors.blue[800]),
        ),
        Row(
          children: [
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.blue[800],
                  inactiveTrackColor: DailozColor.appcolor.withOpacity(0.3),
                  thumbColor: Colors.blue[800],
                  overlayColor: DailozColor.appcolor.withAlpha(32),
                  valueIndicatorColor: Colors.blue[800],
                ),
                child: Slider(
                  value: ratings[studentId]![gradeKey]!,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: ratings[studentId]![gradeKey]!.round().toString(),
                  onChanged: (value) {
                    setState(() {
                      ratings[studentId]![gradeKey] = value;
                    });
                  },
                ),
              ),
            ),
            Container(
              width: 40,
              alignment: Alignment.center,
              child: Text(
                ratings[studentId]![gradeKey]!.round().toString(),
                style: hsBold.copyWith(color: Colors.blue[800]),
              ),
            ),
          ],
        ),
      ],
    );
  }

  double _calculateAverageGrade(String studentId) {
    double sum = ratings[studentId]!.values.reduce((a, b) => a + b);
    return sum / 4;
  }

  void _showAverageGradeToast(double average) {
    showReusableToast(
      context: context,
      message: 'Moyenne des notes: ${average.toStringAsFixed(2)}',
      duration: Duration(seconds: 5),
    );
  }

  void _saveAttendanceAndGrades() async {
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    final attendanceData = {
      'date': widget.sessionDate.toIso8601String(),
      'students': attendance.entries.map((entry) {
        final studentId = entry.key;
        return {
          'id': studentId,
          'present': entry.value,
          'grade1': ratings[studentId]!['grade1']!.round(),
          'grade2': ratings[studentId]!['grade2']!.round(),
          'grade3': ratings[studentId]!['grade3']!.round(),
          'grade4': ratings[studentId]!['grade4']!.round(),
        };
      }).toList(),
    };

    try {
      await apiProvider.setAttendance(widget.sessionId, attendanceData);
      showReusableToast(
        context: context,
        message: 'Présence et notes enregistrées avec succès',
        duration: Duration(seconds: 5),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Échec de l\'enregistrement des présences et des notes: $e', style: hsRegular),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}