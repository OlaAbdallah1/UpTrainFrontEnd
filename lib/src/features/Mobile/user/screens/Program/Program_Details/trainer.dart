import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/constants/size_config.dart';
import 'package:uptrain/src/features/Mobile/user/models/trainer.dart';

class TrainerPage extends StatefulWidget {
  const TrainerPage({super.key});

  @override
  _TrainerPageState createState() => _TrainerPageState();
}

class _TrainerPageState extends State<TrainerPage> {
  Future<List<Trainer>> fetchProgramData() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.48:3000/trainers'));
    final List<dynamic> data = json.decode(response.body);
    return data
        .map((json) => Trainer.fromJson(json))
        // .where((item) => item.branch == _selectedBranch)
        .toList();
  }

  late Future<List<Trainer>> _futureProgramData = fetchProgramData();

  @override
  void initState() {
    super.initState();
    _futureProgramData = fetchProgramData();
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
                                    "assets/images/${snapshot.data![index].photo}",
                                    fit: BoxFit.contain,
                                    height: getProportionateScreenHeight(50),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            "${snapshot.data![index].first_name} ${snapshot.data![index].last_name}",
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Text(
                                              snapshot.data![index].email),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
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
