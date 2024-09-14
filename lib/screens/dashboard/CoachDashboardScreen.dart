import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:footballproject/Provider/TrainingSchedule/CoachDashboardProvider.dart';

class CoachDashboardScreen extends StatefulWidget {
  static String id = 'Coach_Dashboard_Screen';

  final DateTime sessionDate;
  final String sessionId;

  const CoachDashboardScreen({
    Key? key,
    required this.sessionDate,
    required this.sessionId,
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
        students = loadedStudents;
        for (var student in students) {
          final studentId = student['id'];
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
        SnackBar(content: Text('Failed to load students: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        shadowColor: Colors.grey.withOpacity(0.3),
        elevation: 5,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.blue[900],
        title: Text(
          'Session ${widget.sessionDate.toString().split(' ')[0]}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                final studentId = student['id'];

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                          backgroundImage:
                              student['profile']['profilePicture'] != null
                                  ? NetworkImage(
                                      student['profile']['profilePicture'])
                                  : null,
                          backgroundColor: Colors.blue[900],
                          child: student['profile']['profilePicture'] == null
                              ? Text(
                                  student['profile']['firstName'][0],
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.white),
                                )
                              : null,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${student['profile']['firstName']} ${student['profile']['lastName']}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900],
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'Present:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue[700],
                                    ),
                                  ),
                                  Switch(
                                    value: attendance[studentId]!,
                                    onChanged: (value) {
                                      setState(() {
                                        attendance[studentId] = value;
                                      });
                                    },
                                    activeColor: Colors.blue[900],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          child: Text('Grade'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[900],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () =>
                              _showGradingDialog(context, studentId),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.save,color: Colors.white,),
        label: const Text(
          'Valider',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: _saveAttendanceAndGrades,
        backgroundColor: Colors.blue[900],
      ),
    );
  }

  void _showGradingDialog(BuildContext context, String studentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Grade Student',
                  style: TextStyle(color: Colors.blue[900])),
              content: Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildGradeSlider('Grade 1', studentId, 'grade1', setState),
                    _buildGradeSlider('Grade 2', studentId, 'grade2', setState),
                    _buildGradeSlider('Grade 3', studentId, 'grade3', setState),
                    _buildGradeSlider('Grade 4', studentId, 'grade4', setState),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Annuler',
                      style: TextStyle(color: Colors.blue[700])),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  child: Text('Enregistrer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    this.setState(() {}); // Refresh the main UI
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildGradeSlider(
      String label, String studentId, String gradeKey, Function setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label',
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900]),
        ),
        Row(
          children: [
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.blue[700],
                  inactiveTrackColor: Colors.blue[100],
                  thumbColor: Colors.blue[900],
                  overlayColor: Colors.blue.withAlpha(32),
                  valueIndicatorColor: Colors.blue[900],
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
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blue[900]),
              ),
            ),
          ],
        ),
      ],
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Attendance and grades saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save attendance and grades: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
