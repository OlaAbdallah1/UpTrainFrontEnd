import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:uptrain/src/features/Mobile/user/models/studentApplication.dart';
import 'package:uptrain/src/features/Mobile/user/screens/profile/MyApplications/program_app_details.dart';
import 'package:url_launcher/url_launcher.dart';
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
    futureApplications = fetchApplications();
    super.dispose();
  }

  List<StudentApplication> studentApp = [];
  late Future<List<StudentApplication>> futureApplications =
      fetchApplications();
  Future<List<StudentApplication>> fetchApplications() async {
    String url = "http://$ip/api/getStudentApplications/${_user.id}";
    final response = await http.get(Uri.parse(url));
    var responseData = json.decode(response.body);

    if (response.statusCode == 201) {
      for (Map application in responseData) {
        studentApp.add(StudentApplication.fromJson(application));
      }
      return studentApp;
    } else {
      return studentApp;
    }
  }

  String status = '';
  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: FutureBuilder(
              future: futureApplications,
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
                        if (snapshot.data![index].status == 0) {
                          status = 'Waiting';
                        } else if (snapshot.data![index].status == 2) {
                          status = 'In Process';
                        } else if (snapshot.data![index].status == 3) {
                          status = 'Accepted';
                        } else if (snapshot.data![index].status == 4) {
                          status = 'Declined';
                        }
                        return Column(
                          children: [
                            Row(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextButton(
                                    child: Text(snapshot.data![index].cv,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18,
                                            color: Colors.blue[900])),
                                    onPressed: () async {
                                      final String url =
                                          'http://$ip/api/downloadFile/${snapshot.data![index].id}'; // Replace with your API endpoint

                                      // ignore: deprecated_member_use
                                      if (await canLaunch(url)) {
                                        // ignore: deprecated_member_use
                                        await launch(url);
                                      }
                                    }),
                                    SizedBox(width: getProportionateScreenWidth(50),),
                                    Text(status ,style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.blue[900])),
                              ],
                            ),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextButton(
                                      child: Text(
                                          snapshot.data![index].program_name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 20,
                                              color: tPrimaryColor)),
                                      onPressed: () => {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProgramAppDetails(
                                                            program_id: snapshot
                                                                .data![index]
                                                                .id)))
                                          }),
                                ]),
                            Divider(
                              color: tLightColor,
                              thickness: 1,
                            )
                          ],
                        );
                      });
                } else {
                  // No data available
                  return Center(child: Text('No application files found'));
                }
              },
            )));
  }
}
