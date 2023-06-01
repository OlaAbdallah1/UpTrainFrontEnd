import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/constants/connections.dart';
import 'package:uptrain/src/features/Mobile/user/models/application.dart';
import 'package:uptrain/src/features/Mobile/user/models/company.dart';
import 'package:uptrain/src/features/Website/Company/Applications/StudentProfile/profile_screen.dart';
import 'package:uptrain/src/features/Website/Company/Applications/programApplications/program_app_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../constants/colors.dart';
import '../../../../../constants/size_config.dart';
import '../../../../Mobile/user/models/program.dart';

class ProgramApplicationsPage extends StatefulWidget {
  Program program;
  Company company;
  ProgramApplicationsPage(
      {super.key, required this.program, required this.company});

  @override
  State<ProgramApplicationsPage> createState() =>
      _ProgramApplicationsPageState();
}

class _ProgramApplicationsPageState extends State<ProgramApplicationsPage> {
  List<Application> applications = [];
  List<Application> acceptedApplications = [];
  List<Application> declinedApplications = [];
  List<Application> inProccesApplications = [];

  Future<List<Application>> fetchApplications() async {
    final response = await http
        .get(Uri.parse('http://$ip/api/getApplications/${widget.program.id}'));
    final data = json.decode(response.body).cast<Map<String, dynamic>>();

    setState(() {
      applications = data
          .map<Application>((json) => Application.fromJson(json['application']))
          .toList();
      for (var application in applications) {
        if (application.status == 2) {
          inProccesApplications.add(application);
        } else if (application.status == 3) {
          acceptedApplications.add(application);
        } else if (application.status == 4) {
          declinedApplications.add(application);
        }
      }
    });
    return data
        .map<Application>((json) => Application.fromJson(json['application']))
        .toList();
  }

  late Future<List<Application>> _futureApplications = fetchApplications();

  @override
  void initState() {
    super.initState();
    _futureApplications = fetchApplications();
  }

  List<String> statusOptions = ['All', 'Accepted', 'In Process', 'Declined'];
  String selectedStatus = 'All';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.program.title} Applications',
                style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: tPrimaryColor),
              ),
              SizedBox(
                width: getProportionateScreenWidth(10),
              ),
              DropdownButton<String>(
                value: selectedStatus,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedStatus = newValue!;
                    // Perform filtering based on the selected status
                    // Call the API or manipulate the data accordingly
                  });
                },
                items:
                    statusOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          if (selectedStatus == 'All')
            Column(
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(5),
                        vertical: getProportionateScreenHeight(5)),
                    child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: DataTable(
                          columns: const [
                            DataColumn(
                                label: Text('Resume',
                                    style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: tPrimaryColor))),
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
                                label: Text('Field',
                                    style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: tPrimaryColor))),
                            DataColumn(
                                label: Text('Accept',
                                    style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: tPrimaryColor))),
                            DataColumn(
                                label: Text('Decline',
                                    style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: tPrimaryColor))),
                          ],
                          rows: applications
                              .map((data) => DataRow(
                                    cells: [
                                      DataCell(TextButton(
                                          child: Text(data.cv,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16,
                                                  color: Colors.blue[900])),
                                          onPressed: () async {
                                            final String url =
                                                'http://$ip/api/downloadFile/${data.id}'; // Replace with your API endpoint

                                            // ignore: deprecated_member_use
                                            if (await canLaunch(url)) {
                                              // ignore: deprecated_member_use
                                              await launch(url);
                                              // ignore: use_build_context_synchronously
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          ProgramApplicationsScreen(
                                                            program:
                                                                widget.program,
                                                            company:
                                                                widget.company,
                                                          )));

                                              // ignore: use_build_context_synchronously
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          '${data.cv} Application In Process')));
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          })),
                                      DataCell(TextButton(
                                        onPressed: () { Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          StudentProfilePage(
                                                            company: widget.company,
                                                          student_id: data.user_id
                                                          )));}, //user Profile
                                        child: Text(
                                            '${data.user.firstName} ${data.user.lastName}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16,
                                                color: Colors.blue[900])),
                                      )),
                                      DataCell(TextButton(
                                          child: Text(data.user.email,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16,
                                                  color: Colors.blue[900])),
                                          onPressed: () async {
                                            final Uri params = Uri(
                                              scheme: 'mailto',
                                              path: data.user.email,
                                              query:
                                                  'subject=Hello&body=Body%20of%20the%20email',
                                            );

                                            final String url =
                                                params.toString();

                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          })),
                                      DataCell(
                                        Text(data.user.field,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16,
                                                color: Colors.black)),
                                      ),
                                      DataCell(IconButton(
                                        onPressed: () async {
                                          final response = await http.post(
                                              Uri.parse(
                                                  'http://$ip/api/acceptApplication/${data.id}'));

                                          if (response.statusCode == 201) {
                                            // ignore: use_build_context_synchronously
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        ProgramApplicationsScreen(
                                                          program:
                                                              widget.program,
                                                          company:
                                                              widget.company,
                                                        )));

                                            // ignore: use_build_context_synchronously
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        '${data.cv} Application Accepted')));
                                            print('Application Accepted');
                                          }
                                        },
                                        color: Colors.green,
                                        icon: Icon(Icons.done),
                                      )),
                                      DataCell(IconButton(
                                          onPressed: () async {
                                            final response = await http.post(
                                                Uri.parse(
                                                    'http://$ip/api/declineApplication/${data.id}'));

                                            if (response.statusCode == 201) {
                                              // ignore: use_build_context_synchronously
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          ProgramApplicationsScreen(
                                                            program:
                                                                widget.program,
                                                            company:
                                                                widget.company,
                                                          )));

                                              // ignore: use_build_context_synchronously
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          '${data.cv} Application Declined')));
                                              print('Application Declined');
                                            }
                                          },
                                          color: Colors.red,
                                          icon: Icon(Icons.cancel))),
                                    ],
                                  ))
                              .toList(),
                        )))
              ],
            ),
          if (selectedStatus == 'In Process')
            Column(
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(5),
                        vertical: getProportionateScreenHeight(5)),
                    child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: DataTable(
                          columns: const [
                            DataColumn(
                                label: Text('Resume',
                                    style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: tPrimaryColor))),
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
                                label: Text('Field',
                                    style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: tPrimaryColor))),
                            DataColumn(
                                label: Text('Accept',
                                    style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: tPrimaryColor))),
                            DataColumn(
                                label: Text('Decline',
                                    style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: tPrimaryColor))),
                          ],
                          rows: inProccesApplications
                              .map((data) => DataRow(
                                    cells: [
                                      DataCell(TextButton(
                                          child: Text(data.cv,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16,
                                                  color: Colors.black)),
                                          onPressed: () async {
                                            final String url =
                                                'http://$ip/api/downloadFile/${data.id}'; // Replace with your API endpoint

                                            // ignore: deprecated_member_use
                                            if (await canLaunch(url)) {
                                              // ignore: deprecated_member_use
                                              await launch(url);
                                              // ignore: use_build_context_synchronously
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          ProgramApplicationsScreen(
                                                            program:
                                                                widget.program,
                                                            company:
                                                                widget.company,
                                                          )));

                                              // ignore: use_build_context_synchronously
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          '${data.cv} Application In process')));
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          })),
                                      DataCell(TextButton(
                                        onPressed: () {}, //user Profile
                                        child: Text(
                                            '${data.user.firstName} ${data.user.lastName}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16,
                                                color: Colors.blue[900])),
                                      )),
                                      DataCell(TextButton(
                                          child: Text(data.user.email,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16,
                                                  color: Colors.blue[900])),
                                          onPressed: () async {
                                            final Uri params = Uri(
                                              scheme: 'mailto',
                                              path: data.user.email,
                                              query:
                                                  'subject=Hello&body=Body%20of%20the%20email',
                                            );

                                            final String url =
                                                params.toString();

                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          })),
                                      DataCell(
                                        Text(data.user.field,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16,
                                                color: Colors.black)),
                                      ),
                                      DataCell(IconButton(
                                        onPressed: () async {
                                          final response = await http.post(
                                              Uri.parse(
                                                  'http://$ip/api/acceptApplication/${data.id}'));

                                          if (response.statusCode == 201) {
                                            // ignore: use_build_context_synchronously
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        ProgramApplicationsScreen(
                                                          program:
                                                              widget.program,
                                                          company:
                                                              widget.company,
                                                        )));

                                            // ignore: use_build_context_synchronously
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        '${data.cv} Application Accepted')));
                                            print('Application Accepted');
                                          }
                                        },
                                        color: Colors.green,
                                        icon: Icon(Icons.done),
                                      )),
                                      DataCell(IconButton(
                                          onPressed: () async {
                                            final response = await http.post(
                                                Uri.parse(
                                                    'http://$ip/api/declineApplication/${data.id}'));

                                            if (response.statusCode == 201) {
                                              // ignore: use_build_context_synchronously
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          ProgramApplicationsScreen(
                                                            program:
                                                                widget.program,
                                                            company:
                                                                widget.company,
                                                          )));

                                              // ignore: use_build_context_synchronously
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          '${data.cv} Application Declined')));
                                              print('Application Declined');
                                            }
                                          },
                                          color: Colors.red,
                                          icon: Icon(Icons.cancel))),
                                    ],
                                  ))
                              .toList(),
                        )))
              ],
            ),
          if (selectedStatus == 'Accepted')
            Column(
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(5),
                        vertical: getProportionateScreenHeight(5)),
                    child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: DataTable(
                          columns: const [
                            DataColumn(
                                label: Text('Resume',
                                    style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: tPrimaryColor))),
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
                                label: Text('Field',
                                    style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: tPrimaryColor))),
                            DataColumn(
                                label: Text('Decline',
                                    style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: tPrimaryColor))),
                          ],
                          rows: acceptedApplications
                              .map((data) => DataRow(
                                    cells: [
                                      DataCell(TextButton(
                                          child: Text(data.cv,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16,
                                                  color: Colors.black)),
                                          onPressed: () async {
                                            final String url =
                                                'http://$ip/api/downloadFile/${data.id}'; // Replace with your API endpoint

                                            // ignore: deprecated_member_use
                                            if (await canLaunch(url)) {
                                              // ignore: deprecated_member_use
                                              await launch(url);
                                              // ignore: use_build_context_synchronously
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          ProgramApplicationsScreen(
                                                            program:
                                                                widget.program,
                                                            company:
                                                                widget.company,
                                                          )));

                                              // ignore: use_build_context_synchronously
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          '${data.cv} Application In process')));
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          })),
                                           DataCell(TextButton(
                                        onPressed: () {}, //user Profile
                                        child: Text(
                                            '${data.user.firstName} ${data.user.lastName}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16,
                                                color: Colors.blue[900])),
                                      )),
                                      DataCell(TextButton(
                                          child: Text(data.user.email,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16,
                                                  color: Colors.blue[900])),
                                          onPressed: () async {
                                            final Uri params = Uri(
                                              scheme: 'mailto',
                                              path: data.user.email,
                                              query:
                                                  'subject=Hello&body=Body%20of%20the%20email',
                                            );

                                            final String url =
                                                params.toString();

                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          })),
                                      DataCell(
                                        Text(data.user.field,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16,
                                                color: Colors.black)),
                                      ),
                                      DataCell(IconButton(
                                          onPressed: () async {
                                            final response = await http.post(
                                                Uri.parse(
                                                    'http://$ip/api/declineApplication/${data.id}'));

                                            if (response.statusCode == 201) {
                                              // ignore: use_build_context_synchronously
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          ProgramApplicationsScreen(
                                                            program:
                                                                widget.program,
                                                            company:
                                                                widget.company,
                                                          )));

                                              // ignore: use_build_context_synchronously
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          '${data.cv} Application Declined')));
                                              print('Application Declined');
                                            }
                                          },
                                          color: Colors.red,
                                          icon: Icon(Icons.cancel))),
                                    ],
                                  ))
                              .toList(),
                        )))
              ],
            ),
          if (selectedStatus == 'Declined')
            Column(
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(5),
                        vertical: getProportionateScreenHeight(5)),
                    child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: DataTable(
                          columns: const [
                            DataColumn(
                                label: Text('Resume',
                                    style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: tPrimaryColor))),
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
                                label: Text('Field',
                                    style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: tPrimaryColor))),
                            DataColumn(
                                label: Text('Accept',
                                    style: TextStyle(
                                        fontFamily: 'Ubuntu',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: tPrimaryColor))),
                          ],
                          rows: declinedApplications
                              .map((data) => DataRow(
                                    cells: [
                                      DataCell(TextButton(
                                          child: Text(data.cv,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16,
                                                  color: Colors.black)),
                                          onPressed: () async {
                                            final String url =
                                                'http://$ip/api/downloadFile/${data.id}'; // Replace with your API endpoint

                                            // ignore: deprecated_member_use
                                            if (await canLaunch(url)) {
                                              // ignore: deprecated_member_use
                                              await launch(url);
                                              // ignore: use_build_context_synchronously
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          ProgramApplicationsScreen(
                                                            program:
                                                                widget.program,
                                                            company:
                                                                widget.company,
                                                          )));

                                              // ignore: use_build_context_synchronously
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          '${data.cv} Application In process')));
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          })),
                                           DataCell(TextButton(
                                        onPressed: () {}, //user Profile
                                        child: Text(
                                            '${data.user.firstName} ${data.user.lastName}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16,
                                                color: Colors.blue[900])),
                                      )),
                                      DataCell(TextButton(
                                          child: Text(data.user.email,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16,
                                                  color: Colors.blue[900])),
                                          onPressed: () async {
                                            final Uri params = Uri(
                                              scheme: 'mailto',
                                              path: data.user.email,
                                              query:
                                                  'subject=Hello&body=Body%20of%20the%20email',
                                            );

                                            final String url =
                                                params.toString();

                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          })),
                                      DataCell(
                                        Text(data.user.field,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16,
                                                color: Colors.black)),
                                      ),
                                      DataCell(IconButton(
                                        onPressed: () async {
                                          final response = await http.post(
                                              Uri.parse(
                                                  'http://$ip/api/acceptApplication/${data.id}'));
                                          if (response.statusCode == 201) {
                                            // ignore: use_build_context_synchronously
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        ProgramApplicationsScreen(
                                                          program:
                                                              widget.program,
                                                          company:
                                                              widget.company,
                                                        )));

                                            // ignore: use_build_context_synchronously
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        '${data.cv} Application Accepted')));
                                            print('Application Accepted');
                                          }
                                        },
                                        color: Colors.green,
                                        icon: Icon(Icons.done),
                                      )),
                                    ],
                                  ))
                              .toList(),
                        )))
              ],
            ),
        ],
      ),
    );
  }
}
