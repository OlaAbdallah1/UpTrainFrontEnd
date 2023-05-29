import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/constants/connections.dart';
import 'package:uptrain/src/features/Mobile/user/models/application.dart';
import 'package:uptrain/src/features/Mobile/user/models/company.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/size_config.dart';
import '../../../Mobile/user/models/program.dart';

class ProgramApplicationsPage extends StatefulWidget {
  Program program;
  ProgramApplicationsPage({super.key, required this.program});

  @override
  State<ProgramApplicationsPage> createState() =>
      _ProgramApplicationsPageState();
}

class _ProgramApplicationsPageState extends State<ProgramApplicationsPage> {
  Future<List<Application>> fetchPrograms() async {
    final response = await http.get(Uri.parse(
        'http://$ip/api/getProgramApplications/${widget.program.id}'));
    final List<dynamic> data = json.decode(response.body);
    return data
        .map((json) => Application.fromJson(json))
        // .where((item) => item.branch == _selectedBranch)
        .toList();
  }

  late Future<List<Application>> _futurePrograms = fetchPrograms();

  @override
  void initState() {
    super.initState();
    _futurePrograms = fetchPrograms();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          FutureBuilder(
            future: _futurePrograms,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        // itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getProportionateScreenWidth(5),
                                  vertical: getProportionateScreenHeight(5)),
                              child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DataTable(
                                    columns: const [
                                      DataColumn(
                                          label: Text('Program',
                                              style: TextStyle(
                                                  fontFamily: 'Ubuntu',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: tPrimaryColor))),
                                    ],
                                    rows: snapshot.data!
                                        .map((data) => DataRow(
                                              cells: [
                                                DataCell(Text(widget.program.title,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 16,
                                                        color: Colors.black))),
                                              ],
                                            ))
                                        .toList(),
                                  )));
                        }),
                  ],
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
