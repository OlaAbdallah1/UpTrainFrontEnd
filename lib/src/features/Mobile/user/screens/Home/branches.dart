import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uptrain/src/features/Mobile/user/models/branch.dart';
import 'package:uptrain/src/features/Mobile/user/models/program.dart';
import 'package:uptrain/src/features/Mobile/user/models/trainer.dart';

import '../../../../../constants/colors.dart';
import '../../../../../constants/size_config.dart';
import 'package:http/http.dart' as http;
// Our Category List need StateFullWidget
// I can use Provider on it, Then we dont need StatefulWidget

class Branches extends StatefulWidget {
  @override
  _BranchesState createState() => _BranchesState();
}

class _BranchesState extends State<Branches> {
  late Future<List<Branch>> _futureBranches;

  @override
  void initState() {
    _futureBranches = fetchBranches();
    // _programs = fetchPrograms() as List<Program>;
    fetchPrograms().then((programs) {
      setState(() {
        _programs = programs;
      });
    });
    super.initState();
  }

  Future<List<Branch>> fetchBranches() async {
    List<Branch> branchesDate = [
      Branch(title: 'All'),
    ];

    String url = "http://172.19.243.190:3000/branches";
    final response = await http.get(Uri.parse(url));
    var responseData = jsonDecode(response.body);
    json.decode(response.body);

    if (response.statusCode == 200) {
      for (Map branch in responseData) {
        branchesDate.add(Branch.fromJson(branch));
      }

      print("object");
      print(branchesDate);
      return branchesDate;
    } else {
      return branchesDate;
    }
    // final List<dynamic> data = json.decode(response.body);
    // return data.map((json) => Branch.fromJson(json)).toList();
  }

  Trainer _trainer = new Trainer(
      email: '',
      password: '',
      first_name: '',
      last_name: '',
      phone: '',
      photo: '',
      company_id: 0);
  Future<List<Program>> fetchPrograms() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.48:3000/programs'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List<dynamic>;
      final programs = jsonData.map((itemData) {
        return Program(
            title: itemData['title'],
            branch: itemData['branch'],
            company: '',
            description: '',
            end_date: '',
            start_date: '',
            image: '',
            details: '',
            trainer: '');
      }).toList();
      return programs;
    }
    throw Exception('Failed to fetch items');
  }

  List<Program> _programs = [];
  String _selectedBranch = 'All';
  List<Program> get _categorizedPrograms {
    if (_selectedBranch == 'All') {
      return _programs;
    } else {
      return _programs.where((item) => item.branch == _selectedBranch).toList();
    }
  }

  Future<void> sendBranchToApi(String branch) async {
    final url = 'https://example.com/api';
    final response =
        await http.post(url as Uri, body: {'branch': _selectedBranch});
    if (response.statusCode == 200) {
      // API request successful
    } else {
      // API request failed
    }
  }

  // By default first one is selected
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: FutureBuilder(
            future: fetchBranches(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(_categorizedPrograms.toString());
                return SizedBox(
                    height: getProportionateScreenHeight(30),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          print(snapshot.data!.length);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                                _selectedBranch = snapshot.data![index].title;
                                sendBranchToApi(_selectedBranch);
                              });
                            },
                            child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                  left: getProportionateScreenWidth(2)),
                              padding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenHeight(18),
                                vertical: getProportionateScreenWidth(4),
                              ),
                              decoration: BoxDecoration(
                                  color: selectedIndex == index
                                      ? Color(0xFFEFF3EE)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text(
                                snapshot.data![index].title,
                                style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  fontWeight: FontWeight.bold,
                                  color: selectedIndex == index
                                      ? tPrimaryColor
                                      : Color(0xFFC2C2B5),
                                ),
                              ),
                            ),
                          );
                        }));
              }
              print("No branches");
              return const CircleAvatar();
            }));
  }
}
