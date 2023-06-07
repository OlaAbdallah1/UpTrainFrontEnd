import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/constants/connections.dart';
import 'package:uptrain/src/features/Mobile/authentication/models/fieldsusers.dart';
import 'package:uptrain/src/features/Website/Admin/models/Employee.dart';
import 'package:uptrain/src/utils/theme/widget_themes/image_from_url.dart';

import '../../../../constants/colors.dart';
import '../../../Mobile/authentication/models/user.dart';
import 'training_students_screen.dart';

class TrainingStudentsPage extends StatefulWidget {
  Employee employee;
  TrainingStudentsPage({super.key, required this.employee});

  @override
  State<TrainingStudentsPage> createState() => _TrainingStudentsPageState();
}

List<FieldUsers> filteredStudents = [];
List<FieldUsers> students = [];
final controller = TextEditingController();

class _TrainingStudentsPageState extends State<TrainingStudentsPage> {
  Future<List<FieldUsers>> fetchStudents() async {
    final response = await http.get(Uri.parse(
        'http://$ip/api/getTrainingStudents/${widget.employee.field_id}'));
    final List<dynamic> data = json.decode(response.body);
    setState(() {
      students = data.map((json) => FieldUsers.fromJson(json)).toList();
    });

    return data
        .map((json) => FieldUsers.fromJson(json))
        .where((element) => element.program != " ")
        .toList();
  }

  late Future<List<FieldUsers>> _futureStudents = fetchStudents();

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DataTable(
              columns: const [
                DataColumn(
                    label: Text(
                  'Photo',
                  style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: tPrimaryColor),
                )),
                DataColumn(
                    label: Text('Name',
                        style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: tPrimaryColor))),
                DataColumn(
                    label: Text('Email',
                        style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: tPrimaryColor))),
                DataColumn(
                    label: Text('Company',
                        style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: tPrimaryColor))),
                DataColumn(
                    label: Text('Program',
                        style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: tPrimaryColor))),
                DataColumn(
                    label: Text('Phone',
                        style: TextStyle(
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: tPrimaryColor))),
                DataColumn(label: Text(' ')),
              ],
              rows: students
                  .map((data) => DataRow(
                        cells: [
                          DataCell(Container(
                              width: 80,
                              child: ClipOval(
                                  child: Image.asset(
                                      'assets/images/${data.photo}')))),
                          DataCell(Text('${data.firstName} ${data.lastName}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Colors.black))),
                          DataCell(Text(data.email,
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Colors.black))),
                          DataCell(Text(data.company,
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Colors.black))),
                          DataCell(Text(data.program,
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Colors.black))),
                          DataCell(Text(data.phone,
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Colors.black))),
                          DataCell(IconButton(
                            icon: const Icon(Icons.delete),
                            color: tPrimaryColor,
                            onPressed: () async {
                              final response = await http.post(Uri.parse(
                                  'http://$ip/api/admin/deleteStudent/${data.email}'));
                              print(response.body);
                              // setState(() {
                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          TrainingStudentsScreen(
                                            employee: widget.employee,
                                          )));
                              // });

                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      '${data.firstName} ${data.lastName} deleted')));
                            },
                          )),
                        ],
                      ))
                  .toList(),
            )
          ]),
    );
  }
}
