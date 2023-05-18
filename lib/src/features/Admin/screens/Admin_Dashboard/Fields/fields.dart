import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/constants/connections.dart';
import 'package:uptrain/src/features/Admin/screens/Admin_Dashboard/Fields/fields_screen.dart';
import 'package:uptrain/src/utils/theme/widget_themes/image_from_url.dart';

import '../../../../../constants/colors.dart';
import '../../../../Mobile/authentication/models/field.dart';

class FieldPage extends StatefulWidget {
  const FieldPage({super.key});

  @override
  State<FieldPage> createState() => _FieldPageState();
}

class _FieldPageState extends State<FieldPage> {
  Future<List<Field>> fetchFields() async {
    final response = await http.get(Uri.parse('http://$ip/api/getFields'));
    final List<dynamic> data = json.decode(response.body);
    return data
        .map((json) => Field.fromJson(json))
        // .where((item) => item.branch == _selectedBranch)
        .toList();
  }

  late Future<List<Field>> _futureFields = fetchFields();

  @override
  void initState() {
    super.initState();
    _futureFields = fetchFields();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          FutureBuilder(
            future: _futureFields,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return DataTable(
                  // border: TableBorder.all(width: 1.5),
                  columns: const [
                  
                    DataColumn(
                        label: Text(
                      'Field',
                      style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: tPrimaryColor),
                    )),
                    DataColumn(
                        label: Text(
                      'Collage',
                      style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: tPrimaryColor),
                    )),
                    DataColumn(
                        label: Text(
                      'Supervisor',
                      style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: tPrimaryColor),
                    )),
                    DataColumn(label: Text(' ')),
                  ],
                  rows: snapshot.data!
                      .map((data) => DataRow(
                            cells: [
                             
                              DataCell(Text('${data.name} ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      color: Colors.black))),
                             
                              DataCell(Text('${data.collage} ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      color: Colors.black))),
                              DataCell(TextButton(
                                  onPressed: () {},
                                  child: const Text('Select Supervisor',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16,
                                          color: Colors.blue)))),
                              DataCell(IconButton(
                                icon: const Icon(Icons.delete),
                                color: tPrimaryColor,
                                onPressed: ()  async {
                                  final response = await http.delete(Uri.parse(
                                      'http://$ip/api/admin/deleteField/${data.id}'));
                                  print(response.body);
                                  // ignore: use_build_context_synchronously
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const FieldsScreen()));

                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              '${data.name} Field deleted')));
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
