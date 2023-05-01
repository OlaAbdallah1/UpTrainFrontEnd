import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:uptrain/src/constants/text.dart';
import 'package:uptrain/src/features/Mobile/user/models/program.dart';
import 'package:uptrain/src/utils/theme/widget_themes/button_theme.dart';
import '../../models/trainer.dart';
import 'branches.dart';
import '../Program/Program_Details/program_screen.dart';

class ProgramPage extends StatefulWidget {
  const ProgramPage({super.key});

  @override
  _ProgramPageState createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> {
  Future<List<Program>> fetchProgramData() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.48:3000/programs'));
    final List<dynamic> data = json.decode(response.body);
    return data
        .map((json) => Program.fromJson(json))
        // .where((item) => item.branch == _selectedBranch)
        .toList();
  }

  late Future<List<Program>> _futureProgramData = fetchProgramData();
  late Future<List<Trainer>> _futureTrainerData = fetchTrainerData();

  final Trainer _trainer = Trainer(
      email: '',
      password: '',
      first_name: '',
      last_name: '',
      phone: '',
      photo: '',
      company_id: 0);

Future<List<Trainer>> fetchTrainerData() async {
  final response = await  http.get(Uri.parse('http://192.168.1.48:3000/trainers'));
    final List<dynamic> data = json.decode(response.body);
    return data
        .map((json) => Trainer.fromJson(json))
        // .where((item) => item.email == )
        .toList();
}

  @override
  void initState() {
    super.initState();
    _futureProgramData = fetchProgramData();
    _futureTrainerData = fetchTrainerData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          FutureBuilder(
            future: _futureProgramData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(5),
                          vertical: getProportionateScreenHeight(2)),
                      child: Container(
                        height: getProportionateScreenHeight(150),
                        child: Card(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            side: BorderSide(
                              color: tPrimaryColor,
                              width: 1.0,
                            ),
                          ),
                          shadowColor: tPrimaryColor,
                          color: tLightColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: SizeConfig.screenHeight * 0.01,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    // snapshot.data![index].image,
                                    "assets/images/${snapshot.data![index].image}",
                                    fit: BoxFit.contain,
                                    height: getProportionateScreenHeight(50),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            "${snapshot.data![index].company} - ${snapshot.data![index].title}",
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Text(
                                              "${snapshot.data![index].description} \n ${snapshot.data![index].start_date} \t-\t ${snapshot.data![index].end_date}"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                      onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProgramDetailsScreen(
                                                    title: snapshot
                                                        .data![index].title,
                                                    description: snapshot
                                                        .data![index]
                                                        .description,
                                                    details: snapshot
                                                        .data![index].details,
                                                    image:
                                                        'assets/images/${snapshot.data![index].image}',
                                                    company: snapshot
                                                        .data![index].company,
                                                    startDate: snapshot
                                                        .data![index]
                                                        .start_date,
                                                    endDate: snapshot
                                                        .data![index].end_date,
                                                    trainer: _trainer.last_name,
                                                  ))),
                                      child: const Text(
                                        "Show Details ",
                                        style: TextStyle(color: tPrimaryColor),
                                      )),
                                  OutlinedButton(
                                    onPressed: () {},
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: tPrimaryColor,
                                      side: const BorderSide(
                                        width: 1.5,
                                        color: Colors.white,
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                    ),
                                    child: const Text(
                                      "Apply Now",
                                      style: TextStyle(color: tLightColor),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
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
