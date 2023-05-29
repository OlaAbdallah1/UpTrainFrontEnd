import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/constants/connections.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/size_config.dart';
import '../../../Mobile/user/models/program.dart';

class ProgramsPage extends StatefulWidget {
  const ProgramsPage({super.key});

  @override
  State<ProgramsPage> createState() => _ProgramsPageState();
}

class _ProgramsPageState extends State<ProgramsPage> {
  Future<List<Program>> fetchPrograms() async {
    final response =
        await http.get(Uri.parse('http://$ip/api/getPrograms'));
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
                return DataTable(
                  columns: const [
                    DataColumn(label: Text('Program',style: TextStyle(fontFamily: 'Ubuntu',fontWeight: FontWeight.bold,fontSize: 18,color: tPrimaryColor))),
                    DataColumn(label: Text('Branch',style: TextStyle(fontFamily: 'Ubuntu',fontWeight: FontWeight.bold,fontSize: 18,color: tPrimaryColor))),
                    DataColumn(label: Text('Company',style: TextStyle(fontFamily: 'Ubuntu',fontWeight: FontWeight.bold,fontSize: 18,color: tPrimaryColor))),
                    DataColumn(label: Text('Description',style: TextStyle(fontFamily: 'Ubuntu',fontWeight: FontWeight.bold,fontSize: 18,color: tPrimaryColor))),
                    // DataColumn(label: Text('Details')),
                    DataColumn(label: Text('Start Date',style: TextStyle(fontFamily: 'Ubuntu',fontWeight: FontWeight.bold,fontSize: 16,color: tPrimaryColor))),
                    DataColumn(label: Text('End Date',style: TextStyle(fontFamily: 'Ubuntu',fontWeight: FontWeight.bold,fontSize: 16,color: tPrimaryColor))),
                    DataColumn(label: Text(' ')),
                    DataColumn(label: Text(' ')),
                  ],
                  rows: snapshot.data!
                      .map((data) => DataRow(
                            cells: [
                              DataCell(Text(data.title,style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 16,color: Colors.black))),
                              DataCell(Text(data.branch,style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 16,color: Colors.black))),
                              // DataCell(Text(data.company,style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 16,color: Colors.black))),
                              // DataCell(Text(data.description,style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 16,color: Colors.black))),
                              // DataCell(Text(data.details)),
                              DataCell(Text(data.start_date,style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 16,color: Colors.black))),
                              DataCell(Text(data.end_date,style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 16,color: Colors.black))),
                            DataCell(IconButton(
                                icon: const Icon(Icons.edit),color: tPrimaryColor,
                                onPressed: () => {},
                              )),
                              DataCell(IconButton(
                                icon: const Icon(Icons.delete),color: tPrimaryColor,
                                onPressed: () => {},
                              )),
                            ],
                          ))
                      .toList(),
                );
                // ListView.builder(
                //   shrinkWrap: true,
                //   physics: const NeverScrollableScrollPhysics(),
                //   // itemCount: snapshot.data!.length,
                //   itemBuilder: (context, index) {
                //     return Padding(
                //       padding: EdgeInsets.symmetric(
                //           horizontal: getProportionateScreenWidth(5),
                //           vertical: getProportionateScreenHeight(5)),
                //       child: Container(
                //           padding: const EdgeInsets.all(8.0),
                //           child: DataTable(
                //             columns: const [
                //               DataColumn(label: Text('Title')),
                //               DataColumn(label: Text('Branch')),
                //               DataColumn(label: Text('Company')),
                //               DataColumn(label: Text('Description')),
                //               DataColumn(label: Text('Details')),
                //               DataColumn(label: Text('Start Date')),
                //               DataColumn(label: Text('End Date')),
                //             ],
                //             rows: snapshot.data!.map((data) => DataRow(
                //                       cells: [
                //                         DataCell(Text(data.title)),
                //                         DataCell(Text(data.branch)),
                //                         DataCell(Text(data.company)),
                //                         DataCell(Text(data.description)),
                //                         DataCell(Text(data.description)),
                //                         DataCell(Text(data.start_date)),
                //                         DataCell(Text(data.end_date)),
                //                       ],
                //                     ))
                //                 .toList(),
                //           )

                //           // Card(
                //           //   child: Column(
                //           //     crossAxisAlignment: CrossAxisAlignment.start,
                //           //     mainAxisAlignment: MainAxisAlignment.center,
                //           //     children: [
                //           //       SizedBox(
                //           //         height: SizeConfig.screenHeight * 0.01,
                //           //       ),
                //           //       Row(
                //           //         mainAxisAlignment: MainAxisAlignment.center,
                //           //         mainAxisSize: MainAxisSize.min,
                //           //         children: [
                //           //           Image.asset(
                //           //             // snapshot.data![index].image,
                //           //             "assets/images/${snapshot.data![index].image}",
                //           //             fit: BoxFit.contain,
                //           //             height: getProportionateScreenHeight(60),
                //           //           ),
                //           //           Expanded(
                //           //             child: Column(
                //           //               children: [
                //           //                 ListTile(
                //           //                   title: Text(
                //           //                     snapshot.data![index].title,
                //           //                     overflow: TextOverflow.ellipsis,
                //           //                   ),
                //           //                   subtitle: Text(snapshot
                //           //                       .data![index].description),
                //           //                 ),
                //           //                 ListTile(
                //           //                   title: Text(
                //           //                     snapshot.data![index].branch,
                //           //                     overflow: TextOverflow.ellipsis,
                //           //                   ),
                //           //                   subtitle: Text(
                //           //                       snapshot.data![index].company),
                //           //                 ),
                //           //                 ListTile(
                //           //                   title: Text(
                //           //                     snapshot.data![index].description,
                //           //                     overflow: TextOverflow.ellipsis,
                //           //                   ),
                //           //                 ),
                //           //               ],
                //           //             ),
                //           //           ),
                //           //         ],
                //           //       ),
                //           //       SizedBox(
                //           //         height: SizeConfig.screenHeight * 0.02,
                //           //       ),
                //           //     ],
                //           //   ),
                //           // ),
                //           ),
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
