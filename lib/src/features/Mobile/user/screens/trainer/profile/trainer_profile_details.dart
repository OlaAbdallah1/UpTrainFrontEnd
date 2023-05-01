import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/constants/text.dart';

import '../../../../../../constants/size_config.dart';
import '../../../models/trainer.dart';
import 'package:url_launcher/url_launcher.dart';

class TrainerDetails extends StatefulWidget {
  final String trainer;
  const TrainerDetails({super.key, required this.trainer});

  @override
  State<TrainerDetails> createState() => _TrainerDetailsState();
}

// Future<List<Trainer>> getTrainer() async {
//   final response = await http
//       .get(Uri.parse('http://192.168.1.48:3000/trainers/?id=$trainerId'));

//   final List<dynamic> data = json.decode(response.body);
//   print(data);
//   return data.map((json) => Trainer.fromJson(json)).toList();
// }

class _TrainerDetailsState extends State<TrainerDetails> {
  late Trainer _trainer = Trainer(
      email: "",
      password: '',
      first_name: '',
      last_name: '',
      phone: '',
      photo: '',
      company_id: 0);

  @override
  void initState() {
    super.initState();
    // _loadTrainer();
  }

  // void _loadTrainer() async {
  //   try {
  //     final trainer = await getTrainer(widget.trainer);
  //     setState(() {
  //       _trainer = trainer.first;
  //     });
  //   } catch (e) {
  //     print('Error loading trainer: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: _trainer == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage("assets/images/${_trainer.photo}"),
                    ),
                  ],
                ),
                const Text(
                  "About:",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 22,
                    fontFamily: 'Ubuntu',
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Text(
                  _trainer.first_name,
                  style: bodyTextStyle,
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                const Text(
                  "Location:",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 22,
                    fontFamily: 'Ubuntu',
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
             
              ],
            ),
    );
  }


}
