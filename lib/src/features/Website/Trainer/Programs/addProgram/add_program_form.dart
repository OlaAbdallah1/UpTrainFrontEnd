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

  // File? image = File('');
  // String imageUrl = '';

  // Future pickImage(ImageSource source) async {
  //   try {
  //     final img = await ImagePicker().pickImage(source: source);
  //     if (img == null) return;
  //     final imgTemp = File(img.path);

  //     setState(() {
  //       image = imgTemp;
  //     });
  //   } on PlatformException catch (e) {
  //     print('Failed to pick image: $e');
  //   }
  // }

  // void myAlert() {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           shape:
  //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //           title: const Text('Please choose your profile photo'),
  //           content: SizedBox(
  //             height: MediaQuery.of(context).size.height / 6,
  //             child: Column(
  //               children: [
  //                 ElevatedButton(
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: tPrimaryColor,
  //                   ),
  //                   onPressed: () {
  //                     pickImage(ImageSource.gallery);
  //                     Navigator.pop(context);
  //                   },
  //                   child: Row(
  //                     children: [
  //                       const Icon(Icons.image),
  //                       Text(
  //                         ' From Gallery',
  //                         style: TextStyle(
  //                           fontSize: getProportionateScreenWidth(18),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 ElevatedButton(
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: tPrimaryColor,
  //                   ),
  //                   //if Program click this button. Program can upload image from camera
  //                   onPressed: () {
  //                     pickImage(ImageSource.camera);
  //                     Navigator.pop(context);
  //                   },
  //                   child: Row(
  //                     children: [
  //                       const Icon(Icons.camera),
  //                       Text(
  //                         ' From Camera',
  //                         style: TextStyle(
  //                           fontSize: getProportionateScreenWidth(18),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
            // ),
          // );
        // });

  

  void save() async {
    try {
      // if (image != null) {
      //   final cloudinary = CloudinaryPublic('dsmn9brrg', 'ul29zf8l');

      //   CloudinaryResponse resImage = await cloudinary.uploadFile(
      //     CloudinaryFile.fromFile(image!.path,
      //         folder: programSkills.program.title),
      //   );
      //   String basename = path.basename(image!.path);

      //   setState(() {
      //     imageUrl = resImage.secureUrl;
      //     programSkills.program.image = imageUrl;
      //     print(imageUrl);
      //     print(programSkills.program.image);
      //   });
      // } else {
      //   setState(() {
      //     programSkills.program.image =
      //         path.basename("assets/images/profile.png");
      //     print(programSkills.program.image);

      //     // const Image(image: AssetImage("assets/images/profile.png"))
      //     //     as String;
      //   });
      //   print("Picture ${programSkills.program.image}");
      // }
      var response = await http.post(Uri.parse("http://$ip/api/company/addProgram"),
          headers: <String, String>{
            'Context-Type': 'application/json;charset=UTF-8'
          },
          body: {
            'title': programSkills.program.title,
            'start_date': _selectedDateRange?.start.toString().split(' ')[0],
            'end_date': _selectedDateRange?.end.toString().split(' ')[0],
            'photo': widget.company.photo,
            'details': programSkills.program.details,
            'branch_id': programSkills.program.branch.id,
            'company_id': widget.company.id,
            'trainer_id': programSkills.program.trainer.id,
            'skills': selectedSkillsId.join(',')
          });
      print(response.statusCode);
      // print(response.headers);

      print("final error : jaym " + response.body);

      print(json.encode(programSkills.program.toJson()));
      print(response.statusCode);
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
            SizedBox(
              height: 115,
              width: 115,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  // image != null
                  //     ? CircleAvatar(
                  //         backgroundImage: FileImage(image!), radius: 200.0)
                  //     : const CircleAvatar(
                  //         backgroundImage:
                  //             AssetImage("assets/images/profile.png"),
                  //       ),
                  Positioned(
                    right: -16,
                    bottom: 0,
                    child: SizedBox(
                      height: 46,
                      width: 46,
                      child: TextButton(
                        onPressed: () {
                          // myAlert();
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: const BorderSide(color: Colors.white),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
                      ),
                    ),
                  )
                ],
              ),
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
                                  programSkills.program.trainer.email =
                                      '${trainer.email}';
                                  // print("trainer selected");
                                  // print(program.trainer);
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
                                  programSkills.program.branch.id = branch.id;

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
                      print(
                          "${programSkills.program.title} added successfully");
                      print("${programSkills.program.company}");
                      print("${widget.company.id}");
                      print("${programSkills.program.branch.id}");
                      print("${programSkills.program.trainer.email}");
                      print("${programSkills.skills.join(',')}");
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
