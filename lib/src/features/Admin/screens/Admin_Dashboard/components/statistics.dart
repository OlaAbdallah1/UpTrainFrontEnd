import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uptrain/src/constants/connections.dart';
import 'package:uptrain/src/features/Mobile/authentication/models/user.dart';
import 'package:uptrain/src/features/Mobile/user/models/company.dart';
import 'package:http/http.dart' as http;

import '../../../../../constants/colors.dart';
import '../../../../Mobile/authentication/models/field.dart';
import '../../../models/Employee.dart';
import 'storage_info_card.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  List companiesList = [];
  List<Company> companiesData = [];
  late Future<List<Company>> companies;
  Future<List<Company>> getCompanies() async {
    String url = "http://$ip/api/getCompanies";
    final response = await http.get(Uri.parse(url));
    var responseData = jsonDecode(response.body);
    // json.decode(response.body);

    if (response.statusCode == 201) {
      for (Map company in responseData) {
        companiesData.add(Company.fromJson(company));
      }

      return companiesData;
    } else {
      return companiesData;
    }
  }

  List employeesList = [];
  List<Employee> employeesData = [];
  late Future<List<Employee>> employees;
  Future<List<Employee>> getEmployees() async {
    String url = "http://$ip/api/getEmployees";
    final response = await http.get(Uri.parse(url));
    var responseData = jsonDecode(response.body);
    // json.decode(response.body);
    if (response.statusCode == 201) {
      for (Map employee in responseData) {
        employeesData.add(Employee.fromJson(employee));
      }

      return employeesData;
    } else {
      return employeesData;
    }
  }

  List fieldsList = [];
  List<Field> fieldsData = [];
  late Future<List<Field>> fields;
  Future<List<Field>> getFields() async {
    String url = "http://$ip/api/getFields";
    final response = await http.get(Uri.parse(url));
    var responseData = jsonDecode(response.body);
    // json.decode(response.body);
    if (response.statusCode == 201) {
      for (Map field in responseData) {
        fieldsData.add(Field.fromJson(field));
      }

      return fieldsData;
    } else {
      return fieldsData;
    }
  }

  List studentsList = [];
  List<User> studentsData = [];
  late Future<List<User>> students;
  Future<List<User>> getStudents() async {
    String url = "http://$ip/api/getStudents";
    final response = await http.get(Uri.parse(url));
    var responseData = jsonDecode(response.body);
    // json.decode(response.body);
    if (response.statusCode == 201) {
      for (Map student in responseData) {
        studentsData.add(User.fromJson(student));
      }

      return studentsData;
    } else {
      return studentsData;
    }
  }

  @override
  void initState() {
    companies = getCompanies();
    employees = getEmployees();
    students = getStudents();
    fields = getFields();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: tLightColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Statistics",
            style: TextStyle(
                fontSize: 22,
                fontFamily: 'Ubuntu',
                fontWeight: FontWeight.bold,
                color: tPrimaryColor),
          ),
          SizedBox(height: defaultPadding),
          FutureBuilder(
              future: companies,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  companiesList = snapshot.data!;
                  print(companiesList.length);
                  return StorageInfoCard(
                    svgSrc: "assets/icons/menu_store.svg",
                    title:
                        "We have partnerships with ${companiesList.length} Company",
                    // numOfFiles: companiesList.length,
                  );
                }
                print("No companies");
                return const CircleAvatar();
              }),
          FutureBuilder(
              future: employees,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  employeesList = snapshot.data!;
                  print(employeesList.length);
                  return StorageInfoCard(
                    svgSrc: "assets/icons/User.svg",
                    title:
                        "We have ${employeesList.length} Employees to supervise on students",
                    // numOfFiles: employeesList.length,
                  );
                }
                print("No employees");
                return const CircleAvatar();
              }),
          FutureBuilder(
              future: fields,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  fieldsList = snapshot.data!;
                  print(fieldsList.length);
                  return StorageInfoCard(
                    svgSrc: "assets/icons/menu_task.svg",
                    title:
                        "We help to find training programs within ${fieldsList.length} Fields",
                    // numOfFiles: fieldsList.length,
                  );
                }
                print("No fields");
                return const CircleAvatar();
              }),
          FutureBuilder(
              future: students,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  studentsList = snapshot.data!;
                  print(studentsList.length);
                  return StorageInfoCard(
                    svgSrc: "assets/icons/User Icon.svg",
                    title:
                        "We help up to ${studentsList.length} Students to find their perfect chances",
                    // numOfFiles: studentsList.length,
                  );
                }
                print("No students");
                return const CircleAvatar();
              }),
        ],
      ),
    );
  }
}
