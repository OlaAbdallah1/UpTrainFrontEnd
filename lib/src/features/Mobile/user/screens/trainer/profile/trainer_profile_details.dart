import 'dart:convert';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_mail_app/open_mail_app.dart';
import 'package:uptrain/src/constants/connections.dart';
import 'package:uptrain/src/constants/text.dart';
import 'package:uptrain/src/utils/theme/widget_themes/image_from_url.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../constants/size_config.dart';
import '../../../../authentication/models/skills.dart';
import '../../../models/program.dart';
import '../../../models/trainer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Program/Apply/application_screen.dart';
import '../../Program/Program_Details/program_screen.dart';
import '../../company/profile/company_profile_screen.dart';

class TrainerDetails extends StatefulWidget {
  final Trainer trainer;
  final Map<String, dynamic> user;
  final Map<String, dynamic> student;
  final List<Skill> skillsO;
  const TrainerDetails(
      {super.key,
      required this.trainer,
      required this.user,
      required this.student,
      required this.skillsO});

  @override
  State<TrainerDetails> createState() => _TrainerDetailsState();
}

class _TrainerDetailsState extends State<TrainerDetails> {
  @override
  void initState() {
    fetchTrainerPrograms(widget.trainer.id);
    super.initState();
  }

  List<Program> trainerPrograms = [];

  Future<List<Program>> fetchTrainerPrograms(int trainerId) async {
    final response = await http
        .get(Uri.parse('http://$ip/api/getTrainerPrograms/$trainerId'));

    var responseData = json.decode(response.body);
    print(responseData);
    if (response.statusCode == 201) {
      for (Map program in responseData) {
        trainerPrograms.add(Program.fromJson(program));
      }
      return trainerPrograms;
    } else {
      return trainerPrograms;
    }
  }

  String chatRoomId(String user1, String user2) {
    if (user1.toLowerCase().codeUnits[0] > user2.toLowerCase().codeUnits[0]) {
      return "$user1 $user2";
    } else {
      return "$user2 $user1";
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.trainer.photo);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: widget.trainer == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ClipOval(child: ImageFromUrl(imageUrl: "https://ibb.co/8DCYH1P"))
                    SizedBox(
                      width: getProportionateScreenWidth(150),
                      child: ClipOval(
                        child: Image.network(
                            "https://res.cloudinary.com/dsmn9brrg/image/upload/v1673876307/dngdfphruvhmu7cie95a.jpg"),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                Text(
                  "Email:",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: getProportionateScreenHeight(22),
                    color: tPrimaryColor,
                    fontFamily: 'Ubuntu',
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                TextButton(
                    onPressed: () async {
                      EmailContent email = EmailContent(
                        to: [
                          widget.trainer.email,
                        ],
                      );

                      OpenMailAppResult result =
                          await OpenMailApp.composeNewEmailInMailApp(
                              nativePickerTitle: 'Select email app to compose',
                              emailContent: email);
                      if (!result.didOpen && !result.canOpen) {
                        showNoMailAppsDialog(context);
                      } else if (!result.didOpen && result.canOpen) {
                        showDialog(
                          context: context,
                          builder: (_) => MailAppPickerDialog(
                            mailApps: result.options,
                            emailContent: email,
                          ),
                        );
                      }
                    },
                    child: Text(
                      widget.trainer.email,
                      style: TextStyle(
                          fontSize: getProportionateScreenHeight(18),
                          color: tSecondaryColor),
                    )),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                Text(
                  "Phone number:",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: getProportionateScreenHeight(22),
                      fontFamily: 'Ubuntu',
                      color: tPrimaryColor),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                TextButton(
                    onPressed: () => _launchPhoneDialer(widget.trainer.phone),
                    child: Text(
                      widget.trainer.phone,
                      style: TextStyle(
                          fontSize: getProportionateScreenHeight(18),
                          color: tSecondaryColor),
                    )),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                Text(
                  "Working on:",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: getProportionateScreenHeight(22),
                      fontFamily: 'Ubuntu',
                      color: tPrimaryColor),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CompanyAccount(
                                  companyName: widget.trainer.company,
                                  user: widget.user,
                                  student: widget.student,
                                  skillsO: widget.skillsO,
                                )));
                  },
                  child: Text(
                    widget.trainer.company,
                    style: TextStyle(
                        fontSize: getProportionateScreenHeight(20),
                        decoration: TextDecoration.underline,
                        color: tSecondaryColor),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                // Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                //   Text(
                //     "Programs",
                //     style: TextStyle(
                //         fontSize: getProportionateScreenHeight(22),
                //         decoration: TextDecoration.underline,
                //         fontFamily: 'Ubuntu',
                //         color: tPrimaryColor),
                //   ),
                // ]),
                // SizedBox(
                //     height: getProportionateScreenHeight(160),
                //     child:
                //         ListView(scrollDirection: Axis.horizontal, children: [
                //       Card(
                //         child: FutureBuilder(
                //           future: fetchTrainerPrograms(widget.trainer.id),
                //           builder: (context, snapshot) {
                //             if (snapshot.hasData) {
                //               return ListView.builder(
                //                   scrollDirection: Axis.horizontal,
                //                   shrinkWrap: true,
                //                   physics: const NeverScrollableScrollPhysics(),
                //                   itemCount: snapshot.data!.length,
                //                   itemBuilder: (context, index) {
                //                     return Padding(
                //                       padding: EdgeInsets.symmetric(
                //                           horizontal:
                //                               getProportionateScreenWidth(2),
                //                           vertical:
                //                               getProportionateScreenHeight(2)),
                //                       child: Container(
                //                         decoration: const BoxDecoration(
                //                           borderRadius: BorderRadius.horizontal(
                //                             right: Radius.circular(50),
                //                             left: Radius.circular(20),
                //                           ),
                //                         ),
                //                         width: getProportionateScreenWidth(250),
                //                         child: Card(
                //                           shape: const RoundedRectangleBorder(
                //                             borderRadius: BorderRadius.only(
                //                                 topLeft: Radius.circular(20),
                //                                 topRight: Radius.circular(20),
                //                                 bottomLeft: Radius.circular(20),
                //                                 bottomRight:
                //                                     Radius.circular(20)),
                //                             side: BorderSide(
                //                               color: tPrimaryColor,
                //                               width: 1.0,
                //                             ),
                //                           ),
                //                           shadowColor: tPrimaryColor,
                //                           color: tLightColor,
                //                           child: Column(
                //                             crossAxisAlignment:
                //                                 CrossAxisAlignment.start,
                //                             mainAxisAlignment:
                //                                 MainAxisAlignment.center,
                //                             children: [
                //                               SizedBox(
                //                                 height:
                //                                     SizeConfig.screenHeight *
                //                                         0.01,
                //                               ),
                //                               Row(
                //                                 mainAxisAlignment:
                //                                     MainAxisAlignment.center,
                //                                 mainAxisSize: MainAxisSize.min,
                //                                 children: [
                //                                   Expanded(
                //                                     child: Column(
                //                                       children: [
                //                                         ListTile(
                //                                             title: Text(
                //                                               "${snapshot.data![index].title}",
                //                                               overflow:
                //                                                   TextOverflow
                //                                                       .ellipsis,
                //                                               style: TextStyle(
                //                                                   fontSize:
                //                                                       getProportionateScreenHeight(
                //                                                           16),
                //                                                   color:
                //                                                       tPrimaryColor,
                //                                                   // fontFamily: 'Ubuntu',
                //                                                   fontWeight:
                //                                                       FontWeight
                //                                                           .bold),
                //                                             ),
                //                                             subtitle: Column(
                //                                                 mainAxisAlignment:
                //                                                     MainAxisAlignment
                //                                                         .start,
                //                                                 crossAxisAlignment:
                //                                                     CrossAxisAlignment
                //                                                         .start,
                //                                                 children: [
                //                                                   Text(snapshot
                //                                                       .data![
                //                                                           index]
                //                                                       .branch
                //                                                       .name),
                //                                                   SizedBox(
                //                                                     height:
                //                                                         getProportionateScreenHeight(
                //                                                             10),
                //                                                   ),
                //                                                   Text(
                //                                                     " ${snapshot.data![index].start_date} \t-\t ${snapshot.data![index].end_date}",
                //                                                     style: TextStyle(
                //                                                         fontSize:
                //                                                             getProportionateScreenHeight(
                //                                                                 13),
                //                                                         color: Colors
                //                                                             .black87,
                //                                                         fontFamily:
                //                                                             'Ubuntu',
                //                                                         fontWeight:
                //                                                             FontWeight.normal),
                //                                                   ),
                //                                                 ])),
                //                                       ],
                //                                     ),
                //                                   ),
                //                                 ],
                //                               ),
                //                               // const SizedBox(
                //                               //   height: 10,
                //                               // ),
                //                               Row(
                //                                 mainAxisAlignment:
                //                                     MainAxisAlignment
                //                                         .spaceAround,
                //                                 children: [
                //                                   TextButton(
                //                                       onPressed: () =>
                //                                           Navigator.push(
                //                                               context,
                //                                               MaterialPageRoute(
                //                                                   builder:
                //                                                       (context) =>
                //                                                           ProgramDetailsScreen(
                //                                                             programId:
                //                                                                 snapshot.data![index].id,
                //                                                             title:
                //                                                                 snapshot.data![index].title,
                //                                                             details:
                //                                                                 snapshot.data![index].details,
                //                                                             image:
                //                                                                 snapshot.data![index].image,
                //                                                             company:
                //                                                                 snapshot.data![index].company,
                //                                                             startDate:
                //                                                                 snapshot.data![index].start_date,
                //                                                             endDate:
                //                                                                 snapshot.data![index].end_date,
                //                                                             trainer:
                //                                                                 widget.trainer,
                //                                                             programSkills: [],
                //                                                             student:
                //                                                                 widget.student,
                //                                                             user:
                //                                                                 widget.user,
                //                                                             skillsO:
                //                                                                 widget.skillsO,
                //                                                           ))),
                //                                       child: Text(
                //                                         "Show Details ",
                //                                         style: TextStyle(
                //                                             color:
                //                                                 tPrimaryColor,
                //                                             decoration:
                //                                                 TextDecoration
                //                                                     .underline),
                //                                       )),
                //                                   OutlinedButton(
                //                                     onPressed: () =>
                //                                         Navigator.push(
                //                                             context,
                //                                             MaterialPageRoute(
                //                                                 builder:
                //                                                     (context) =>
                //                                                         ApplicationScreen(
                //                                                           programId: snapshot
                //                                                               .data![index]
                //                                                               .id,
                //                                                           title: snapshot
                //                                                               .data![index]
                //                                                               .title,
                //                                                           student:
                //                                                               widget.student,
                //                                                           user:
                //                                                               widget.user,
                //                                                           skillsO:
                //                                                               widget.skillsO,
                //                                                         ))),
                //                                     style: OutlinedButton
                //                                         .styleFrom(
                //                                       backgroundColor:
                //                                           tPrimaryColor,
                //                                       side: const BorderSide(
                //                                         width: 1,
                //                                         color: Colors.white,
                //                                       ),
                //                                       shape:
                //                                           RoundedRectangleBorder(
                //                                               borderRadius:
                //                                                   BorderRadius
                //                                                       .circular(
                //                                                           20)),
                //                                     ),
                //                                     child: Text(
                //                                       "Apply Now",
                //                                       style: TextStyle(
                //                                         color: tLightColor,
                //                                       ),
                //                                     ),
                //                                   ),
                //                                 ],
                //                               ),
                //                             ],
                //                           ),
                //                         ),
                //                       ),
                //                     );
                //                   });
                //             } else if (snapshot.hasError) {
                //               print(snapshot.error);
                //               return Text('${snapshot.error}');
                //             }

                //             // By default, show a loading spinner
                //             return const Center(
                //               child: CircularProgressIndicator(),
                //             );
                //           },
                //         ),
                //       )
                //     ])),
              ],
            ),
    );
  }

  _launchPhoneDialer(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Open Mail App"),
          content: Text("No mail apps installed"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
