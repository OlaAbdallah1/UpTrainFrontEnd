import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uptrain/global.dart';
import 'package:uptrain/src/constants/connections.dart';
import 'package:uptrain/src/constants/text.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:uptrain/src/features/Mobile/user/models/branch.dart';
import 'package:uptrain/src/features/Mobile/user/models/company.dart';
import 'package:uptrain/src/features/Mobile/user/models/program.dart';
import 'package:uptrain/src/features/Mobile/user/models/program_skills.dart';
import 'package:uptrain/src/features/Mobile/user/models/trainer.dart';
import 'package:uptrain/src/features/Website/Company/Programs/programs.dart';
import 'package:uptrain/src/features/Website/Company/Programs/programs_screen.dart';

import '../../../../../constants/colors.dart';
import '../../../../../constants/size_config.dart';
import '../../../../../utils/theme/widget_themes/button_theme.dart';
import '../../../../Mobile/authentication/models/skills.dart';

class AddProgramForm extends StatefulWidget {
  Company company;
  AddProgramForm({super.key, required this.company});

  @override
  State<AddProgramForm> createState() => _AddProgramFormState();
}

class _AddProgramFormState extends State<AddProgramForm> {
  final _formKey = GlobalKey<FormState>();

  void save() async {
    try {
      var response = await http.post(
          Uri.parse("http://$ip/api/company/addProgram"),
          headers: <String, String>{
            'Context-Type': 'application/json;charset=UTF-8'
          },
          body: {
            'title': programSkills.program.title,
            'start_date': _selectedDateRange?.start.toString().split(' ')[0],
            'end_date': _selectedDateRange?.end.toString().split(' ')[0],
            'photo': widget.company.photo,
            'details': programSkills.program.details,
            'branch_id': programSkills.program.branch.id.toString(),
            'company_id': widget.company.id.toString(),
            'trainer_id': programSkills.program.trainer.id.toString(),
            'skills': selectedSkillsId.join(',')
          });

      print(response.statusCode);
      // print(response.headers);

      print("final error : jaym " + response.body);

      print(json.encode(programSkills.program.toJson()));
      print(response.statusCode);
      if (response.statusCode == 201) {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Company'),
            content: Text("${programSkills.program.title} Added Successfully"),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: tPrimaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () => {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => ProgramsScreen(
                                company: widget.company,
                              ))),

                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          '${programSkills.program.title} Program Added'))),
                },
                child: Text('Ok',
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(8),
                      color: Colors.white,
                    )),
              ),
            ],
          ),
        );
      }
      // ignore: use_build_context_synchronously
    } catch (error) {
      print("error : ${error}");
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    trainers = getTrainers();
    branches = getBranches();
    skills = getSkills();

    super.initState();
  }

  ProgramSkills programSkills = ProgramSkills(
      program: Program(
        id: 0,
        // user_id: 0,
        title: '',
        image: '',
        company: '',
        start_date: '',
        end_date: '',
        branch: Branch(id: 0, name: ''),
        details: '',
        trainer: Trainer(
            id: 0,
            email: '',
            first_name: '',
            last_name: '',
            phone: '',
            photo: '',
            company: ''),
      ),
      skills: []);

  Branch branch = Branch(id: 0, name: '');
  String name = '';
  String errorImg = '';
  String titledata = '';
  String detailsdata = '';

  String trainerLastName = '';
  String trainerFirstName = '';
  List trainersList = [];

  List<Trainer> trainersData = [];
  late Future<List<Trainer>> trainers = getTrainers();
  Future<List<Trainer>> getTrainers() async {
    String url = "http://$ip/api/getCompanyTrainers/${widget.company.id}";
    final response = await http.get(Uri.parse(url));
    var responseData = jsonDecode(response.body);
    if (response.statusCode == 201) {
      for (Map trainer in responseData) {
        trainersData.add(Trainer.fromJson(trainer));
      }
      return trainersData;
    } else {
      return trainersData;
    }
  }

  String branchChoosed = '';
  List branchesList = [];

  List<Branch> branchesData = [];
  late Future<List<Branch>> branches;
  Future<List<Branch>> getBranches() async {
    String url = "http://$ip/api/getAllBranches";
    final response = await http.get(Uri.parse(url));
    var responseData = jsonDecode(response.body);

    if (response.statusCode == 201) {
      for (Map branch in responseData) {
        branchesData.add(Branch.fromJson(branch));
      }
      return branchesData;
    } else {
      return branchesData;
    }
  }

  List skillsList = [];
  List filteredSkills = [];
  Set selectedSkills = {};
  Set selectedSkillsId = {};

  TextEditingController skillsSearchController = TextEditingController();
  TextEditingController skillsController = TextEditingController();

  List<Skill> skillsData = [];
  late Future<List<Skill>> skills;
  Future<List<Skill>> getSkills() async {
    String url = "http://$ip/api/getSkills";
    final response = await http.get(Uri.parse(url));
    var responseData = jsonDecode(response.body);

    if (response.statusCode == 201) {
      for (Map skill in responseData) {
        skillsData.add(Skill.fromJson(skill));
      }
      return skillsData;
    } else {
      return skillsData;
    }
  }

  void removeSkill(String skill) {
    print(skill);
    print('removed');
    setState(() {
      selectedSkills.remove(skill);
    });
  }

  DateTimeRange? _selectedDateRange;
  // This function will be triggered when the floating button is pressed
  void _show() async {
    final DateTimeRange? result = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2022, 1, 1),
        lastDate: DateTime(2030, 12, 31),
        currentDate: DateTime.now(),
        saveText: 'Done',
        builder: (context, child) {
          return Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 400.0,
                ),
                child: child,
              )
            ],
          );
        });

    if (result != null) {
      // Rebuild the UI
      print(result.start.toString());
      setState(() {
        _selectedDateRange = result;
      });
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
              "New Program",
              style: TextStyle(
                  fontFamily: 'Ubintu',
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
                SizedBox(
                  width: SizeConfig.screenWidth * 0.25,
                  child: Row(children: [
                    FloatingActionButton(
                      backgroundColor: Colors.white,
                      onPressed: _show,
                      child: const Icon(
                        Icons.date_range_rounded,
                        color: tPrimaryColor,
                        size: 30,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    _selectedDateRange == null
                        ? const Text(
                            'Program duration',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          )
                        : Text(
                            "From ${_selectedDateRange?.start.toString().split(' ')[0]} to ${_selectedDateRange?.end.toString().split(' ')[0]}",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                  ]),
                ),
                SizedBox(
                  width: SizeConfig.screenWidth * 0.25,
                  child: FutureBuilder(
                      future: trainers,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          trainersList = snapshot.data!;
                          return FormBuilder(
                            child: FormBuilderDropdown<dynamic>(
                              decoration: const InputDecoration(
                                labelText: 'Select Trainer',
                                labelStyle: TextStyle(color: Colors.black),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: tPrimaryColor,
                                ),
                              ),
                              onChanged: (dynamic trainer) {
                                setState(() {
                                  // trainerFirstName = '${trainer.first_name} ';
                                  // trainerLastName = '${trainer.last_name}';
                                  // program.trainer.last_name = trainerLastName;
                                  // program.trainer.first_name = trainerFirstName;
                                  programSkills.program.trainer.id =
                                      trainer.id.toInt();
                                  programSkills.program.trainer.email =
                                      '${trainer.email}';
                                  // print("trainer selected");
                                  print(trainer.id);
                                  print('trainer');
                                  print(programSkills.program.trainer.id);
                                });
                              },
                              valueTransformer: (dynamic value) => value.id,
                              items: trainersList
                                  .map((trainer) => DropdownMenuItem(
                                      value: trainer,
                                      child: Text(
                                          '${trainer.first_name} ${trainer.last_name}')))
                                  .toList(),
                              name: '',
                            ),
                          );
                        }
                        print("No trainers");
                        return const CircleAvatar();
                      }),
                ),
                SizedBox(
                  width: SizeConfig.screenWidth * 0.25,
                  child: FutureBuilder(
                      future: branches,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          branchesList = snapshot.data!;
                          return FormBuilder(
                            child: FormBuilderDropdown<dynamic>(
                              decoration: const InputDecoration(
                                labelText: 'Select Branch',
                                labelStyle: TextStyle(color: Colors.black),
                                prefixIcon: Icon(
                                  Icons.pattern,
                                  color: tPrimaryColor,
                                ),
                              ),
                              onChanged: (dynamic branch) {
                                setState(() {
                                  programSkills.program.branch.id =
                                      branch.id.toInt();
                                  print('branch');
                                  print(branch.id);
                                  print(programSkills.program.branch.name);
                                  print(programSkills.program.branch.id);
                                });
                              },
                              valueTransformer: (dynamic value) => value.id,
                              items: branchesList
                                  .map((branch) => DropdownMenuItem(
                                      value: branch, child: Text(branch.name)))
                                  .toList(),
                              name: '',
                            ),
                          );
                        }
                        print("No branches");
                        return const CircleAvatar();
                      }),
                ),
                SizedBox(
                  width: SizeConfig.screenWidth * 0.25,
                  child: FutureBuilder(
                      future: skills,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          skillsList = snapshot.data!;
                          return Column(
                            children: [
                              TextField(
                                controller: skillsSearchController,
                                decoration: const InputDecoration(
                                  hintText: 'Add Requirment Skills',
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: tPrimaryColor,
                                  ),
                                  hintStyle: TextStyle(color: Colors.black),
                                ),
                                style: const TextStyle(color: Colors.black),
                                onChanged: (value) {
                                  setState(() {
                                    filteredSkills = skillsList
                                        .where((skill) => skill.name
                                            .toLowerCase()
                                            .contains(value.toLowerCase()))
                                        .toList();
                                  });
                                },
                              ),
                              if (skillsSearchController.text
                                  .isNotEmpty) // Only show when search text exists
                                const SizedBox(height: 16.0),
                              if (skillsSearchController.text
                                  .isNotEmpty) // Only show when search text exists
                                SizedBox(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: filteredSkills.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final skill = filteredSkills[index];
                                      final skillId = filteredSkills[index].id;
                                      final bool isSelected =
                                          selectedSkills.contains(skill.name);
                                      return CheckboxListTile(
                                        title: Text(skill.name),
                                        value: isSelected,
                                        onChanged: (value) {
                                          setState(() {
                                            // if (isSelected) {
                                            //   selectedSkills.remove(skill);
                                            // } else {
                                            // user.sKills = sKill;
                                            selectedSkills.add(skill.name);
                                            selectedSkillsId.add(skillId);
                                            programSkills.skills.add(skill);
                                            print(selectedSkillsId.join(','));
                                            print(programSkills.skills);
                                            // }
                                          });
                                        },
                                      );
                                    },
                                  ),
                                )
                            ],
                          );
                        }
                        print("No skills");
                        return const CircleAvatar();
                      }),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                SizedBox(
                  width: SizeConfig.screenWidth * 0.25,
                  child: Wrap(
                    // spacing: 6,
                    children: selectedSkills
                        .map((skill) => Chip(
                              label: Text(
                                skill,
                                style: TextStyle(fontSize: 16),
                              ),
                              backgroundColor: Colors.grey[300],
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              deleteIconColor: tPrimaryColor,
                              onDeleted: () => removeSkill(skill),
                            ))
                        .toList(),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(30),
                ),
                DefaultButton(
                  text: "Add Program",
                  press: () {
                    if (_formKey.currentState!.validate()) {
                      save();
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
        programSkills.program.title = value;
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
        programSkills.program.details = value;
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
