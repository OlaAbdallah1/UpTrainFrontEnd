import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/constants/connections.dart';
import 'package:uptrain/src/features/Mobile/user/models/company.dart';
import 'package:uptrain/src/features/Website/Company/Applications/program_applications.dart';
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
    return data
        .map((json) => Program.fromJson(json))
        // .where((item) => item.branch == _selectedBranch)
        .toList();
  }

  late Future<List<Program>> _futurePrograms = fetchPrograms();

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
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getProportionateScreenWidth(5),
                                  vertical: getProportionateScreenHeight(5)),
                              child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextButton(
                                      onPressed: () => Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  ProgramApplicationsPage(
                                                      program: snapshot
                                                          .data![index]))),
                                      child: Text(
                                          '${snapshot.data![index].title} Program Applications'))));
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
