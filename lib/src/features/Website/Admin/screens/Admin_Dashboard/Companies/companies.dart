import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/features/Website/Admin/screens/Admin_Dashboard/Companies/companies_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../constants/connections.dart';
import '../../../../../../constants/size_config.dart';
import '../../../../../Mobile/user/models/company.dart';
import 'AddCompany/add_company_screen.dart';

class CompanyPage extends StatefulWidget {
  CompanyPage({
    super.key,
  });

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

List<Company> filteredCompanies = [];
List<Company> companies = [];
final controller = TextEditingController();

class _CompanyPageState extends State<CompanyPage> {
  Future<List<Company>> fetchCompanies(String search) async {
    final response = await http.get(Uri.parse('http://$ip/api/getCompanies'));
    final List<dynamic> data = json.decode(response.body);
    setState(() {
      companies = data.map((json) => Company.fromJson(json)).toList();
    });

    if (search.isEmpty) {
      return data.map((json) => Company.fromJson(json)).toList();
    } else {
      return data
          .map((json) => Company.fromJson(json))
          .where((element) =>
              element.name.contains(search.toLowerCase()) ||
              element.location.contains(search.toLowerCase()))
          .toList();
    }
  }

  late Future<List<Company>> _futureCompanies = fetchCompanies(controller.text);

  void filterCompanies(String query) {
    setState(() {
      // Filter the companies based on the search query
      filteredCompanies = companies.where((company) {
        final companyName = '${company.name} ${company.location}'.toLowerCase();

        return companyName.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCompanies(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                  alignment: AlignmentDirectional.centerStart,
                  width: 250,
                  child: companiesSearchField()),
              SizedBox(
                width: getProportionateScreenWidth(10),
              ),
              SizedBox(
                height: getProportionateScreenHeight(45),
                width: getProportionateScreenWidth(50),
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    // shape: RoundedRectangleBorder(
                    // borderRadius: BorderRadius.circular(15)),
                    backgroundColor: tPrimaryColor,
                    side: const BorderSide(
                      width: 1.5,
                      color: tLightColor,
                    ),
                  ),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddCompanyScreen())),
                  child: const Text(
                    "Add Company",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'Ubuntu'),
                  ),
                ),
              )
            ],
          ),
          DataTable(
            columns: const [
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
                  label: Text('Location',
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
              DataColumn(
                  label: Text('Website',
                      style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: tPrimaryColor))),
              DataColumn(label: Text(' ')),
              DataColumn(label: Text(' ')),
            ],
            rows: filteredCompanies
                .map((data) => DataRow(
                      cells: [
                        DataCell(Container(
                            // padding: EdgeInsets.all(10),
                            height: 100,
                            width: 200,
                            alignment: Alignment.centerLeft,
                            child: Text(data.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    color: Colors.black)))),
                        DataCell(Container(
                            height: 100,
                            padding: const EdgeInsets.all(10),
                            child: Text(data.email,
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    color: Colors.black)))),
                        DataCell(Container(
                            height: 100,
                            padding: const EdgeInsets.all(10),
                            child: Text(data.location,
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    color: Colors.black)))),
                        DataCell(Container(
                            height: 100,
                            padding: const EdgeInsets.all(10),
                            child: Text(data.phone,
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    color: Colors.black)))),
                        DataCell(Container(
                          width: 150,
                          child: TextButton(
                            onPressed: () async {
                              var url = data.website;
                              final uri = Uri.parse(url);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Text(
                              data.website,
                              style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue,
                                  fontSize: 18),
                            ),
                          ),
                        )),
                        DataCell(Container(
                            width: 35,
                            child: IconButton(
                              icon: const Icon(Icons.edit),
                              color: tPrimaryColor,
                              onPressed: () => {},
                            ))),
                        DataCell(Container(
                            width: 35,
                            child: IconButton(
                              icon: const Icon(Icons.delete),
                              color: tPrimaryColor,
                              onPressed: () async {
                                final response = await http.delete(Uri.parse(
                                    'http://$ip/api/admin/deleteCompany/${data.name}'));
                                print(response.body);
                                if (response.statusCode == 201) {
                                  // ignore: use_build_context_synchronously

                                  setState(() {});
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Row(
                                    children: [
                                      Text('${data.name} Company deleted'),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        CompaniesScreen()));
                                          },
                                          child: Text('Companies'))
                                    ],
                                  )));
                                }
                              },
                            ))),
                      ],
                    ))
                .toList(),
          )
        ],
      ),
    );
  }

  TextField companiesSearchField() {
    return TextField(
        controller: controller,
        onChanged: filterCompanies,
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
