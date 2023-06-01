import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/constants/connections.dart';
import 'package:uptrain/src/features/Mobile/user/models/company.dart';
import 'package:uptrain/src/utils/theme/widget_themes/image_from_url.dart';
import '../../../../constants/colors.dart';
import '../../../Mobile/user/models/trainer.dart';

class TrainerPage extends StatefulWidget {
  Company company;
  TrainerPage({super.key, required this.company});

  @override
  State<TrainerPage> createState() => _TrainerPageState();
}

class _TrainerPageState extends State<TrainerPage> {
  List<Trainer> trainers = [];
  Future<List<Trainer>> fetchTrainers() async {
    final response = await http.get(
        Uri.parse('http://$ip/api/getCompanyTrainers/${widget.company.id}'));
    final List<dynamic> data = json.decode(response.body);
    setState(() {
      trainers = data.map((json) => Trainer.fromJson(json)).toList();
    });
    print(trainers);
    return data.map((json) => Trainer.fromJson(json)).toList();
  }

  @override
  void initState() {
    super.initState();
    fetchTrainers();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          DataTable(
            columns: const [
              DataColumn(
                  label: Text('Photo',
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
                  label: Text('Phone',
                      style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: tPrimaryColor))),
              DataColumn(label: Text(' ')),
              DataColumn(label: Text(' ')),
            ],
            rows: trainers
                .map((data) => DataRow(
                      cells: [
                        DataCell(ClipOval(
                          child: Image.network(
                              "https://res.cloudinary.com/dsmn9brrg/image/upload/v1673876307/dngdfphruvhmu7cie95a.jpg"),
                        )),
                      
                      DataCell(Container(width: 100,
                        child: Text('${data.first_name} ${data.last_name}',
                            style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: Colors.black)))),
                        DataCell(Text(data.email,
                            style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: Colors.black))),
                        DataCell(Text(data.phone,
                            style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: Colors.black))),
                        DataCell(IconButton(
                          icon: const Icon(Icons.edit),
                          color: tPrimaryColor,
                          onPressed: () => {},
                        )),
                        DataCell(IconButton(
                          icon: const Icon(Icons.delete),
                          color: tPrimaryColor,
                          onPressed: () => {},
                        )),
                      ],
                    ))
                .toList(),
          )
        ],
      ),
    );
  }
}
