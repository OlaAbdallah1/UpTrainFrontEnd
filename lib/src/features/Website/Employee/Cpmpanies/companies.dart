import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/constants/connections.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:uptrain/src/features/Mobile/user/models/company.dart';
import 'package:uptrain/src/features/Website/Admin/models/Employee.dart';
import 'package:uptrain/src/features/Website/Admin/screens/Admin_Dashboard/Companies/companies_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyPage extends StatefulWidget {
  Employee employee;
  CompanyPage({super.key, required this.employee});

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

List<Company> filteredCompanies = [];
List<Company> companies = [];
final controller = TextEditingController();

class _CompanyPageState extends State<CompanyPage> {
  Future<List<Company>> fetchCompanies(String search) async {
    final response = await http.get(Uri.parse('http://$ip/api/getCompanies'));
    final List<dynamic> data = json.decode(response.body);
    setState(() {
      companies = data.map((json) => Company.fromJson(json)).toList();
    });

    if (search.isEmpty) {
      return data.map((json) => Company.fromJson(json)).toList();
    } else {
      return data
          .map((json) => Company.fromJson(json))
          .where((element) =>
              element.name.contains(search.toLowerCase()) ||
              element.location.contains(search.toLowerCase()))
          .toList();
    }
  }

  late Future<List<Company>> _futureCompanies = fetchCompanies(controller.text);

  void filterCompanies(String query) {
    setState(() {
      // Filter the companies based on the search query
      filteredCompanies = companies.where((company) {
        final companyName = '${company.name} ${company.location}'.toLowerCase();

        return companyName.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCompanies(controller.text);
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
                      label: Text('Location',
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
                  DataColumn(
                      label: Text('Website',
                          style: TextStyle(
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: tPrimaryColor))),
                
                ],
                rows: companies
                    .map((data) => DataRow(
                          cells: [
                            DataCell(Container(
                                // padding: EdgeInsets.all(10),
                                height: 100,
                                width: 200,
                                alignment: Alignment.centerLeft,
                                child: Text(data.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                        color: Colors.black)))),
                            DataCell(Container(
                                height: 100,
                                padding: const EdgeInsets.all(10),
                                child: Text(data.email,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                        color: Colors.black)))),
                            DataCell(Container(
                                height: 100,
                                padding: const EdgeInsets.all(10),
                                child: Text(data.location,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                        color: Colors.black)))),
                            DataCell(Container(
                                height: 100,
                                padding: const EdgeInsets.all(10),
                                child: Text(data.phone,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                        color: Colors.black)))),
                            DataCell(Container(
                              width: 150,
                              child: TextButton(
                                onPressed: () async {
                                  var url = data.website;
                                  final uri = Uri.parse(url);
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                                child: Text(
                                  data.website,
                                  style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue,
                                      fontSize: 18),
                                ),
                              ),
                            )),
                           
                          ],
                        ))
                    .toList(),
              )
            ]));
  }
}
