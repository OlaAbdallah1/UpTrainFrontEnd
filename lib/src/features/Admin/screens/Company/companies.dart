import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/connections.dart';
import '../../../../constants/size_config.dart';
import '../../../Mobile/user/models/company.dart';

class CompanyPage extends StatefulWidget {
  const CompanyPage({super.key});

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  Future<List<Company>> fetchCompanies() async {
    final response =
        await http.get(Uri.parse('http://$ip/api/getCompanies'));
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
                    DataColumn(label: Text('Name',style: TextStyle(fontFamily: 'Ubuntu',fontWeight: FontWeight.bold,fontSize: 18,color: tPrimaryColor))),
                    DataColumn(label: Text('Email',style: TextStyle(fontFamily: 'Ubuntu',fontWeight: FontWeight.bold,fontSize: 18,color: tPrimaryColor))),
                    DataColumn(label: Text('Location',style: TextStyle(fontFamily: 'Ubuntu',fontWeight: FontWeight.bold,fontSize: 18,color: tPrimaryColor))),
                    DataColumn(label: Text('Phone',style: TextStyle(fontFamily: 'Ubuntu',fontWeight: FontWeight.bold,fontSize: 18,color: tPrimaryColor))),
                    // DataColumn(label: Text('Description')),
                    DataColumn(label: Text('Website',style: TextStyle(fontFamily: 'Ubuntu',fontWeight: FontWeight.bold,fontSize: 18,color: tPrimaryColor))),
                    DataColumn(label: Text(' ')),
                    DataColumn(label: Text(' ')),
                  ],
                  rows: snapshot.data!
                      .map((data) => DataRow(
                            cells: [
                              // DataCell(
                              //   CircleAvatar(
                              //     backgroundImage:
                              //         AssetImage("assets/images/${data.photo}"),
                              //   ),
                              // ),
                              DataCell(Text(data.name,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 16,color: Colors.black))),
                              DataCell(Text(data.email,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 16,color: Colors.black))),
                              DataCell(Text(data.location,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 16,color: Colors.black))),
                              // DataCell(Text(data.phone,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 16,color: Colors.black))),
                              // DataCell(Text(data.description)),
                              DataCell(
                                TextButton(
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
                              ),
                              DataCell(IconButton(
                                icon: Icon(Icons.edit),color: tPrimaryColor,
                                onPressed: () => {},
                              )),
                              DataCell(IconButton(
                                icon: Icon(Icons.delete),color: tPrimaryColor,
                                onPressed: () => {},
                              )),
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
