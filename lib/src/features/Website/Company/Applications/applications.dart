import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/constants/connections.dart';
import 'package:uptrain/src/features/Mobile/user/models/company.dart';
import 'package:uptrain/src/features/Website/Company/Applications/programApplications/program_app_screen.dart';
import 'package:uptrain/src/features/Website/Company/Applications/programApplications/program_applications.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/size_config.dart';
import '../../../Mobile/user/models/program.dart';

class ApplicationsPage extends StatefulWidget {
  Company company;
  ApplicationsPage({super.key, required this.company});

  @override
  State<ApplicationsPage> createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {
  Future<List<Program>> fetchPrograms() async {
    final response = await http.get(
        Uri.parse('http://$ip/api/getCompanyPrograms/${widget.company.name}'));
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Program.fromJson(json)).toList();
  }

  late Future<List<Program>> _futurePrograms = fetchPrograms();

  @override
  void initState() {
    super.initState();
    _futurePrograms = fetchPrograms();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: _futurePrograms,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextButton(
                                    onPressed: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProgramApplicationsScreen(
                                                  program:
                                                      snapshot.data![index],
                                                  company: widget.company,
                                                ))),
                                    child: Text(
                                      '${index+1}. ${snapshot.data![index].title} Program Applications ☞',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        
                                      ),
                                    ))
                              ],
                            ));
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
    );
  }
}
