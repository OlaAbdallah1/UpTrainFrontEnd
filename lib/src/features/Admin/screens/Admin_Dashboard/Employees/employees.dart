import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/constants/connections.dart';
import 'package:uptrain/src/features/Admin/screens/Admin_Dashboard/Employees/employees_screen.dart';
import 'package:uptrain/src/utils/theme/widget_themes/image_from_url.dart';

import '../../../../../constants/colors.dart';
import '../../../models/Employee.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  Future<List<Employee>> fetchAdmins() async {
    final response = await http.get(Uri.parse('http://$ip/api/getEmployees'));
    final List<dynamic> data = json.decode(response.body);
    return data
        .map((json) => Employee.fromJson(json))
        // .where((item) => item.branch == _selectedBranch)
        .toList();
  }

  late Future<List<Employee>> _futureAdmins = fetchAdmins();

  @override
  void initState() {
    super.initState();
    _futureAdmins = fetchAdmins();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          FutureBuilder(
            future: _futureAdmins,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return DataTable(
                  // border: TableBorder.all(width: 1.5),

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
                        label: Text('Field',
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
                    DataColumn(label: Text(' '))
                  ],
                  rows: snapshot.data!
                      .map((data) => DataRow(
                            cells: [
                              DataCell(Container(
                                width: 80,
                                child: ClipOval(
                                  child: Image.network(
                                      "https://res.cloudinary.com/dsmn9brrg/image/upload/v1673876307/dngdfphruvhmu7cie95a.jpg"),
                                ),
                              )),
                              DataCell(Text(
                                  '${data.first_name} ${data.last_name}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      color: Colors.black))),
                              DataCell(Text(data.email,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      color: Colors.black))),
                              DataCell(Text(data.field,
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
                                icon: const Icon(Icons.edit),
                                color: tPrimaryColor,
                                onPressed: () => {},
                              )),
                              DataCell(IconButton(
                                icon: const Icon(Icons.delete),
                                color: tPrimaryColor,
                                onPressed: () async {
                                  final response = await http.delete(Uri.parse(
                                      'http://$ip/api/admin/deleteEmployee/${data.email}'));
                                  print(response.body);
                                  // ignore: use_build_context_synchronously
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const EmployeesScreen()));

                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              '${data.first_name} ${data.last_name} deleted')));
                                },
                              )),
                            ],
                          ))
                      .toList(),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}
