import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/features/Mobile/user/models/application.dart';
import '../../../../../../constants/connections.dart';
import 'dart:convert';

import '../../../../authentication/models/user.dart';

class Applications extends StatefulWidget {
  // Applications({Key? key}) : super(key: key);
  final Map<String, dynamic> user;
  final Map<String, dynamic> student;

  const Applications({
    super.key,
    required this.user,
    required this.student,
  });

  @override
  State<Applications> createState() => _ApplicationsState();
}

class _ApplicationsState extends State<Applications> {
  late Map<String, dynamic> combined = {};

  late User _user = User(
      id: 0,
      email: '',
      firstName: '',
      lastName: '',
      phone: '',
      field: '',
      photo: '',
      location: '',
      field_id: 0,
      location_id: 0);

  void combineData() {
    combined.addAll(widget.user);
    combined.addAll(widget.student);
    // print(combined);
    _user = User.fromJson(combined);
  }

  @override
  void initState() {
    combineData();

    super.initState();
  }

  @override
  void dispose() {
    fetchApplications();
    super.dispose();
  }

  List<Application> studentApp = [];
  Future<List<Application>> fetchApplications() async {
    String url = "http://$ip/api/getStudentApplications/${_user.id}";
    final response = await http.get(Uri.parse(url));
    var responseData = json.decode(response.body);

    if (response.statusCode == 201) {
      for (Map application in responseData) {
        studentApp.add(Application.fromJson(application));
      }
      return studentApp;
    } else {
      return studentApp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: FutureBuilder(
              future: fetchApplications(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Display a loading indicator while fetching the files
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Handle error if fetching the files fails
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  // Display the list of application files
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: TextButton(
                            child: Text(snapshot.data![index].cv),
                            onPressed: () async {
                              await http.get(Uri.parse(
                                  'http://$ip/api/downloadFile/${snapshot.data![index].id}'));
                            },
                          ),
                          subtitle: Text(snapshot.data![index].program_name),
                        );
                      });
                } else {
                  // No data available
                  return Center(child: Text('No application files found'));
                }
              },
            )
            // future: fetchApplications(),
            // builder: (context, snapshot) {
            //   if (snapshot.hasData) {
            //     print(studentApp);
            //     if (snapshot.data!.isEmpty) {
            //       return Padding(
            //           padding: EdgeInsets.symmetric(
            //               horizontal: getProportionateScreenWidth(2),
            //               vertical: getProportionateScreenHeight(2)),
            //           child: Container(
            //               height: getProportionateScreenHeight(120),
            //               child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   children: [
            //                     ListView.builder(
            //                         shrinkWrap: true,
            //                         physics:
            //                             const NeverScrollableScrollPhysics(),
            //                         scrollDirection: Axis.horizontal,
            //                         itemCount: snapshot.data!.length,
            //                         itemBuilder:
            //                             (BuildContext context, int index) {
            //                           return ListTile(
            //                             title: Text(snapshot.data![index].cv),
            //                           );
            //                         })
            //                   ])));
            //     }
            //     print("No Applications");
            //   }
            //   return const Center(
            //     child: CircularProgressIndicator(),
            //   );
            // })
            ));
  }
}
