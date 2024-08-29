// import 'package:footballproject/models/studentProfile.dart';
// import 'package:footballproject/models/teacherProfile.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ApiService {
//   final String baseUrl;

//   ApiService({required this.baseUrl});

//   Future<List<StudentProfile>> fetchStudents() async {
//     try {
//       final response = await http.get(Uri.parse('$baseUrl/users/students'));

//       if (response.statusCode == 200) {
//         List<dynamic> data = jsonDecode(response.body);
//         return data.map((json) => StudentProfile.fromJson(json)).toList();
//       } else {
//         throw Exception('Failed to load students: ${response.statusCode}');
//       }
//     } catch (error) {
//       throw Exception('Error fetching students: $error');
//     }
//   }

//   Future<List<TeacherProfile>> fetchTeachers() async {
//     try {
//       final response = await http.get(Uri.parse('$baseUrl/users/teachers'));

//       if (response.statusCode == 200) {
//         List<dynamic> data = jsonDecode(response.body);
//         return data.map((json) => TeacherProfile.fromJson(json)).toList();
//       } else {
//         throw Exception('Failed to load teachers: ${response.statusCode}');
//       }
//     } catch (error) {
//       throw Exception('Error fetching teachers: $error');
//     }
//   }
// }



// // import 'package:footballproject/models/studentProfile.dart';
// // import 'package:footballproject/models/teacherProfile.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';

// // class ApiService {
// //   final String baseUrl;
// //   final String? authToken;
// //   final http.Client httpClient = http.Client();

// //   ApiService(
// //       {required this.baseUrl,
// //       required this.authToken}); // Modify constructor to accept the token

// //   Future<List<TeacherProfile>> fetchTeachers() async {
// //     final url = '$baseUrl/users/teachers';
// //     final headers = {
// //       'Authorization': 'Bearer $authToken', // Add the token to the headers
// //       'Content-Type': 'application/json',
// //     };

// //     try {
// //       final response = await http.get(Uri.parse(url), headers: headers);
// //       print('Response status: ${response.statusCode}');
// //       print('Response body: ${response.body}');

// //       if (response.statusCode == 200) {
// //         final List<dynamic> data = json.decode(response.body);
// //         return data.map((item) => TeacherProfile.fromJson(item)).toList();
// //       } else {
// //         throw Exception(
// //             'Failed to load teachers. Status code: ${response.statusCode}, Response body: ${response.body}');
// //       }
// //     } catch (e) {
// //       print('Error fetching data: $e');
// //       return [];
// //     }
// //   }

// //   Future<List<StudentProfile>> fetchStudents() async {
// //     final response = await httpClient.get(
// //       Uri.parse('$baseUrl/students'),
// //       headers: {
// //         'Authorization': 'Bearer $authToken',
// //         'Content-Type': 'application/json',
// //       },
// //     );

// //     if (response.statusCode == 200) {
// //       final List<dynamic> data = jsonDecode(response.body);
// //       return data.map((json) => StudentProfile.fromJson(json)).toList();
// //     } else {
// //       throw Exception('Failed to load students');
// //     }
// //   }
// // }
