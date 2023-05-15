import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/features/Admin/screens/Admin_Dashboard/Companies/companies_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../constants/colors.dart';
import '../../../../../constants/connections.dart';
import '../../../../../constants/size_config.dart';
import '../../../../Mobile/user/models/company.dart';

class CompanyPage extends StatefulWidget {
  const CompanyPage({super.key});

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  Future<List<Company>> fetchCompanies() async {
    final response = await http.get(Uri.parse('http://$ip/api/getCompanies'));
    final List<dynamic> data = json.decode(response.body);
    return data
        .map((json) => Company.fromJson(json))
        // .where((item) => item.branch == _selectedBranch)
        .toList();
  }

  late Future<List<Company>> _futureCompanies = fetchCompanies();

  @override
  void initState() {
    super.initState();
    _futureCompanies = fetchCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          FutureBuilder(
            future: _futureCompanies,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return DataTable(
                  columns: const [
                    // DataColumn(
                    //     label: Text(
                    //   'Photo',
                    // )),
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
                    DataColumn(label: Text(' ')),
                    DataColumn(label: Text(' ')),
                  ],
                  rows: snapshot.data!
                      .map((data) => DataRow(
                            cells: [
                              DataCell(Container(
                                  // padding: EdgeInsets.all(10),
                                  height: 100,
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
                              DataCell(Container(
                                  width: 35,
                                  child: IconButton(
                                    icon: const Icon(Icons.edit),
                                    color: tPrimaryColor,
                                    onPressed: () => {},
                                  ))),
                              DataCell(Container(
                                  width: 35,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: tPrimaryColor,
                                    onPressed: () async {
                                      final response = await http.delete(Uri.parse(
                                          'http://$ip/api/admin/deleteCompany/${data.name}'));
                                      print(response.body);
                                      // ignore: use_build_context_synchronously
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  const CompaniesScreen()));
                                                  
                                      // ignore: use_build_context_synchronously
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  '${data.name} Company deleted')));
                                    },
                                  ))),
                            ],
                          ))
                      .toList(),
                );
                // ListView.builder(
                //   shrinkWrap: true,
                //   physics: const NeverScrollableScrollPhysics(),
                //   itemCount: snapshot.data!.length,
                //   itemBuilder: (context, index) {
                //     return Padding(
                //       padding: EdgeInsets.symmetric(
                //           horizontal: getProportionateScreenWidth(5),
                //           vertical: getProportionateScreenHeight(5)),
                //       child: Container(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Card(
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               SizedBox(
                //                 height: SizeConfig.screenHeight * 0.01,
                //               ),
                //               Row(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 mainAxisSize: MainAxisSize.min,
                //                 children: [
                //                   Image.asset(
                //                     // snapshot.data![index].image,
                //                     "assets/images/${snapshot.data![index].photo}",
                //                     fit: BoxFit.contain,
                //                     height: getProportionateScreenHeight(60),
                //                   ),
                //                   Expanded(
                //                     child: Column(
                //                       children: [
                //                         ListTile(
                //                           title: Text(
                //                             snapshot.data![index].name,
                //                             overflow: TextOverflow.ellipsis,
                //                           ),
                //                           subtitle: Text(snapshot
                //                               .data![index].description),
                //                         ),
                //                         ListTile(
                //                           title: Text(
                //                             snapshot.data![index].email,
                //                             overflow: TextOverflow.ellipsis,
                //                           ),
                //                           subtitle: Text(
                //                               snapshot.data![index].website),
                //                         ),
                //                         ListTile(
                //                           title: Text(
                //                             snapshot.data![index].location,
                //                             overflow: TextOverflow.ellipsis,
                //                           ),
                //                         ),
                //                       ],
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //               SizedBox(
                //                 height: SizeConfig.screenHeight * 0.02,
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     );
                //   },
                // );
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
