import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/constants/connections.dart';
import 'package:uptrain/src/features/Admin/screens/Admin_Dashboard/Employees/employees_screen.dart';
import 'package:uptrain/src/utils/theme/widget_themes/image_from_url.dart';

import '../../../../../constants/colors.dart';
import '../../../models/Employee.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

List<Employee> filteredEmployees = [];
List<Employee> employees = [];
final controller = TextEditingController();

class _EmployeePageState extends State<EmployeePage> {
  
  Future<List<Employee>> fetchEmployees(String search) async {
    final response = await http.get(Uri.parse('http://$ip/api/getEmployees'));
    final List<dynamic> data = json.decode(response.body);
    setState(() {
      employees = data.map((json) => Employee.fromJson(json)).toList();
    });

    if (search.isEmpty) {
      return data.map((json) => Employee.fromJson(json)).toList();
    } else {
      return data
          .map((json) => Employee.fromJson(json))
          .where((element) =>
              element.first_name.contains(search.toLowerCase()) ||
              element.last_name.contains(search.toLowerCase()))
          .toList();
    }
  }

  late Future<List<Employee>> _futureEmployees =
      fetchEmployees(controller.text);

  void filterEmployees(String query) {
    setState(() {
      // Filter the companies based on the search query
      filteredEmployees = employees.where((employee) {
        final employeeName =
            '${employee.first_name} ${employee.last_name}'.toLowerCase();

        return employeeName.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _futureEmployees = fetchEmployees(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column( mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(alignment:AlignmentDirectional.centerStart, width: 250, child: employeesSearchField()),
        DataTable(
          columns: const [
            DataColumn(
                label: Text(
              'Photo',
              style: TextStyle(
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: tPrimaryColor),
            )),
            DataColumn(
                label: Text('Name',
                    style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: tPrimaryColor))),
            DataColumn(
                label: Text('Email',
                    style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: tPrimaryColor))),
            DataColumn(
                label: Text('Field',
                    style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: tPrimaryColor))),
            DataColumn(
                label: Text('Phone',
                    style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: tPrimaryColor))),
            DataColumn(label: Text(' ')),
            DataColumn(label: Text(' '))
          ],
          rows: filteredEmployees
              .map((data) => DataRow(
                    cells: [
                      DataCell(Container(
                        width: 80,
                        child: ClipOval(
                          child: Image.network(
                              "https://res.cloudinary.com/dsmn9brrg/image/upload/v1673876307/dngdfphruvhmu7cie95a.jpg"),
                        ),
                      )),
                      DataCell(Text('${data.first_name} ${data.last_name}',
                          style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: Colors.black))),
                      DataCell(Text(data.email,
                          style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: Colors.black))),
                      DataCell(Text(data.field,
                          style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: Colors.black))),
                      DataCell(Text(data.phone,
                          style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: Colors.black))),
                      DataCell(IconButton(
                        icon: const Icon(Icons.edit),
                        color: tPrimaryColor,
                        onPressed: () => {},
                      )),
                      DataCell(IconButton(
                        icon: const Icon(Icons.delete),
                        color: tPrimaryColor,
                        onPressed: () async {
                          final response = await http.delete(Uri.parse(
                              'http://$ip/api/admin/deleteEmployee/${data.email}'));
                          print(response.body);
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const EmployeesScreen()));

                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  '${data.first_name} ${data.last_name} deleted')));
                        },
                      )),
                    ],
                  ))
              .toList(),
        )
      ]),
    );
  }

  TextField employeesSearchField() {
    return TextField(
        controller: controller,
        onChanged: filterEmployees,
        decoration: InputDecoration(
          hintText: "Search",
          fillColor: tSecondaryColor,
          // filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: tPrimaryColor, width: 2.5),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          suffixIcon: InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(defaultPadding * 0.75),
              margin:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              decoration: const BoxDecoration(
                color: tSecondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: SvgPicture.asset("assets/icons/Search.svg"),
            ),
          ),
        ));
  }
}
