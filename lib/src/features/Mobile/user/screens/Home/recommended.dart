import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uptrain/global.dart';
import 'package:uptrain/src/constants/text.dart';
import 'package:uptrain/src/features/Mobile/user/screens/Program/Program_Details/program_screen.dart';

import '../../../../../constants/colors.dart';
import '../../../../../constants/size_config.dart';
import '../../models/program.dart';
import 'programs.dart';
import 'package:http/http.dart' as http;

class Recommended extends StatefulWidget {
  const Recommended({super.key});

  @override
  _RecommendedState createState() => _RecommendedState();
}

class _RecommendedState extends State<Recommended> {
  Future<List<Program>> fetchProgramData() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.48:3000/programs'));
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Program.fromJson(json)).toList();
  }

  late Future<List<Program>> _futureProgramData = fetchProgramData();
  @override
  void initState() {
    super.initState();
    _futureProgramData = fetchProgramData();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenHeight(170),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Card(
            child: FutureBuilder(
              future: _futureProgramData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(5),
                            vertical: getProportionateScreenHeight(5)),
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(50),
                              left: Radius.circular(20),
                            ),

                            // gradient: LinearGradient(

                            //     colors: [
                            //       tPrimaryColor,
                            //       tOnBoardingPage2Color
                            //     ],
                            //     begin: Alignment.topLeft,
                            //     end: Alignment.bottomRight),

                            // boxShadow: [
                            //   BoxShadow(
                            //     color: tOnBoardingPage3Color,
                            //     offset: Offset(-2, 1),
                            //     blurRadius: 12,
                            //   )
                            // ],
                          ),
                          // height: getProportionateScreenHeight(200),
                          width: getProportionateScreenWidth(220),
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
                                    // SvgPicture.asset(
                                    //     "assets/images/${snapshot.data![index].image}", fit: BoxFit.fitHeight,),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          ListTile(
                                            title: Text(
                                              "${snapshot.data![index].company} - ${snapshot.data![index].title}",
                                              // style: TextStyle(color: tPrimaryColor),
                                            ),
                                            subtitle: Text(
                                                "${snapshot.data![index].description}"),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: getProportionateScreenHeight(10),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    OutlinedButton(
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
                                                    trainer: snapshot
                                                        .data![index].trainer,
                                                  ))),
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
                                        "Show Details",
                                        style: TextStyle(color: tLightColor),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: SizeConfig.screenHeight * 0.01,
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
          ),
        ],
      ),
    );

    // return SingleChildScrollView(
    //   // scrollDirection: Axis.vertical,
    //   child: Column(
    //     children: [
    //       FutureBuilder(
    //         future: _futureProgramData,
    //         builder: (context, snapshot) {
    //           if (snapshot.hasData) {
    //             return ListView.builder(
    //               scrollDirection: Axis.horizontal,
    //               shrinkWrap: true,
    //               physics: const NeverScrollableScrollPhysics(),
    //               itemCount: snapshot.data!.length,
    //               itemBuilder: (context, index) {
    //                 return Padding(
    //                   padding: EdgeInsets.symmetric(
    //                       horizontal: getProportionateScreenWidth(5),
    //                       vertical: getProportionateScreenHeight(5)),
    //                   child: Container(
    //                     height: getProportionateScreenHeight(150),
    //                     width: 200,
    //                     child: Card(
    //                       shape: RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.circular(15.0),
    //                         side: const BorderSide(
    //                           color: tPrimaryColor,
    //                           width: 1.0,
    //                         ),
    //                       ),
    //                       shadowColor: tPrimaryColor,
    //                       color: tLightColor,
    //                       child: Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         children: [
    //                           SizedBox(
    //                             height: SizeConfig.screenHeight * 0.01,
    //                           ),
    //                           Row(
    //                             mainAxisAlignment: MainAxisAlignment.center,
    //                             mainAxisSize: MainAxisSize.min,
    //                             children: [
    //                               // SvgPicture.asset(
    //                               //   // snapshot.data![index].image,
    //                               //   "assets/images/${snapshot.data![index].image}",
    //                               //   fit: BoxFit.cover,
    //                               //   height: getProportionateScreenHeight(50),
    //                               // ),
    //                               Expanded(
    //                                 child: Column(
    //                                   children: [
    //                                     ListTile(
    //                                       title: Text(
    //                                         "${snapshot.data![index].company} - ${snapshot.data![index].title}",
    //                                       ),
    //                                       subtitle: Text(
    //                                           "${snapshot.data![index].description} \n ${snapshot.data![index].start_date} \t-\t ${snapshot.data![index].end_date}"),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                           const SizedBox(
    //                             height: 20,
    //                           ),
    //                           Row(
    //                             mainAxisAlignment: MainAxisAlignment.start,
    //                             children: [
    //                               TextButton(
    //                                   onPressed: () {},
    //                                   child: const Text(
    //                                     "Show Details",
    //                                     style: TextStyle(color: tPrimaryColor),
    //                                   )),
    //                               OutlinedButton(
    //                                 onPressed: () {},
    //                                 style: OutlinedButton.styleFrom(
    //                                   backgroundColor: tPrimaryColor,
    //                                   side: const BorderSide(
    //                                     width: 1.5,
    //                                     color: Colors.white,
    //                                   ),
    //                                   shape: RoundedRectangleBorder(
    //                                       borderRadius:
    //                                           BorderRadius.circular(20)),
    //                                 ),
    //                                 child: const Text(
    //                                   "Apply Now",
    //                                   style: TextStyle(color: tLightColor),
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                           SizedBox(
    //                             height: SizeConfig.screenHeight * 0.01,
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                 );
    //               },
    //             );
    //           } else if (snapshot.hasError) {
    //             return Text('${snapshot.error}');
    //           }

    //           // By default, show a loading spinner
    //           return const Center(
    //             child: CircularProgressIndicator(),
    //           );
    //         },
    //       ),
    //     ],
    //   ),
    // );
  }
}
