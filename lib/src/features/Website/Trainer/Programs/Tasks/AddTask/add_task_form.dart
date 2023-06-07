import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uptrain/global.dart';
import 'package:uptrain/src/constants/connections.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/features/Mobile/user/models/branch.dart';
import 'package:uptrain/src/features/Mobile/user/models/program.dart';
import 'package:uptrain/src/features/Mobile/user/models/program_skills.dart';
import 'package:uptrain/src/features/Mobile/user/models/trainer.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../constants/size_config.dart';
import '../../../../../../utils/theme/widget_themes/button_theme.dart';

class AddTaskForm extends StatefulWidget {
  int programId;
  int trainerId;
  AddTaskForm({super.key, required this.programId, required this.trainerId});

  @override
  State<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final _formKey = GlobalKey<FormState>();

  void save() async {
    try {
      var response = await http.post(
          Uri.parse("http://$ip/api/trainer/addTask"),
          headers: <String, String>{
            'Context-Type': 'application/json;charset=UTF-8'
          },
          body: {
            'title': titleController.text,
            'description': detailsController.text,
            'deadline': _deadlineController.text,
            'program_id': widget.programId.toString(),
            'trainer_id': widget.trainerId.toString()
          });

      print(response.statusCode);
      print("final error : jaym " + response.body);
    } catch (error) {
      print("error : ${error}");
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendTaskNotification(
      String taTitle,
      // String taDetails,
      String taDeadline,
      int program_id,
      int trainer_id,
      List<String> tokens) async {
    const url = 'http://$ip/api/sendTaskNotification';

    final body = {
      'title': taTitle,
      // 'details': taDetails,
      'deadline': taDeadline,
      'program_id': program_id,
      'trainer_id': trainer_id,
      'tokens': tokens,
    };

    final response = await http.post(
      Uri.parse(url),
      body: json.encode(body),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  String name = '';
  String errorImg = '';
  String titledata = '';
  String detailsdata = '';

  TextEditingController _deadlineController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        _deadlineController.text = selectedDateTime.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: getProportionateScreenHeight(15),
            ),
            const Text(
              "New Task",
              style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: tPrimaryColor),
            ),
            SizedBox(
              height: getProportionateScreenHeight(15),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(titledata),
                  ],
                ),
                SizedBox(
                  width: SizeConfig.screenWidth * 0.25,
                  child: buildTitleFormField(),
                ),
                Row(
                  children: [
                    Text(detailsdata),
                  ],
                ),
                SizedBox(
                  width: SizeConfig.screenWidth * 0.25,
                  child: buildDetailsFormField(),
                ),
                Row(
                  children: [
                    Text(detailsdata),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    _selectDateTime(context);
                  },
                  child: Text('Select Deadline'),
                  style: TextButton.styleFrom(backgroundColor: tPrimaryColor),
                ),
                SizedBox(
                  width: SizeConfig.screenWidth * 0.25,
                  child: TextFormField(
                    controller: _deadlineController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Deadline',
                      hintText: 'Select Deadline',
                    ),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(30),
                ),
                DefaultButton(
                  text: "Add Task",
                  press: () {
                    if (_formKey.currentState!.validate()) {
                      save();
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Task'),
                          content: Text("Task Added Successfully"),
                          actions: [
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: tPrimaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                              onPressed: () => {Navigator.pop(context)},
                              child: Text('Ok',
                                  style: TextStyle(
                                    fontSize: getProportionateScreenWidth(8),
                                    color: Colors.white,
                                  )),
                            ),
                          ],
                        ),
                      );
                    } else {
                      print("not oky");
                    }
                  },
                ),
              ],
            ),
          ]),
    );
  }

  TextFormField buildTitleFormField() {
    return TextFormField(
      controller: titleController,
      validator: (Title) {
        if (Title == null || Title.isEmpty) {
          setState(() {
            errorImg = "assets/icons/Error.svg";
            titledata = 'Please enter Program title';
          });
          return "";
        } else if (Title.isNotEmpty) {
          setState(() {
            errorImg = "assets/icons/white.svg";
            titledata = '';
          });
        }
        return null;
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            errorImg = 'assets/icons/white.svg';
            titledata = '';
          });
        }
      },
      // onSaved: (savedValue) {
      //   programSkills.program.email = savedValue!;
      // },
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.drive_file_rename_outline,
          color: tPrimaryColor,
        ),
        labelText: 'Title',
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
    );
  }

  TextFormField buildDetailsFormField() {
    return TextFormField(
      controller: detailsController,

      maxLines: 3,
      validator: (Details) {
        if (Details == null || Details.isEmpty) {
          setState(() {
            errorImg = "assets/icons/Error.svg";
            detailsdata = 'Please enter Program Details';
          });
          return "";
        } else if (Details.isNotEmpty) {
          setState(() {
            errorImg = "assets/icons/white.svg";
            detailsdata = '';
          });
        }
        return null;
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            errorImg = 'assets/icons/white.svg';
            detailsdata = '';
          });
        }
      },
      // onSaved: (savedValue) {
      //   programSkills.program.email = savedValue!;
      // },
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.drive_file_rename_outline,
          color: tPrimaryColor,
        ),
        labelText: 'Details',
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      ),
    );
  }
}
