import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/constants/colors.dart';
import 'package:uptrain/src/constants/connections.dart';
import 'package:uptrain/src/constants/text.dart';
import 'package:uptrain/src/utils/theme/widget_themes/image_from_url.dart';

import '../../../../../../constants/size_config.dart';
import '../../../models/company.dart';
import 'company_details.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyDetails extends StatefulWidget {
  final String companyName;
  const CompanyDetails({super.key, required this.companyName});

  @override
  State<CompanyDetails> createState() => _CompanyDetailsState();
}

class _CompanyDetailsState extends State<CompanyDetails> {
  late Company _company = Company(
    id: 0,
      name: '',
      description: '',
      email: '',
      photo: '',
      website: '',
      location: '',
      phone: '');

  @override
  void initState() {
    super.initState();
    _loadCompany();
  }

  Future<List<Company>> getCompany(String companyName) async {
    final response = await http
        .get(Uri.parse('http://$ip/api/getProgramCompany/$companyName'));

    final List<dynamic> data = json.decode(response.body);
    print(data);
    return data.map((json) => Company.fromJson(json)).toList();
  }

  void _loadCompany() async {
    try {
      final company = await getCompany(widget.companyName);
      setState(() {
        _company = company.first;
      });
    } catch (e) {
      print('Error loading company: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: _company == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: getProportionateScreenWidth(120),
                      child: Image.asset("assets/images/${_company.photo}"),
                    ),
                    Expanded(
                      child: Text(
                        _company.name,
                        style: const TextStyle(
                            color: tPrimaryColor,
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                    )
                  ],
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: []),
                SizedBox(height: getProportionateScreenHeight(20)),
                Text(
                  "About:",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: getProportionateScreenHeight(22),
                      fontFamily: 'Ubuntu',
                      color: tPrimaryColor),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Text(
                  _company.description,
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(16),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                Text(
                  "Location:",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: getProportionateScreenHeight(22),
                      fontFamily: 'Ubuntu',
                      color: tPrimaryColor),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Text(
                  _company.location,
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(16),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                Text(
                  "Website:",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: getProportionateScreenHeight(22),
                      fontFamily: 'Ubuntu',
                      color: tPrimaryColor),
                ),
                TextButton(
                  onPressed: _launchURL,
                  child: Text(
                    _company.website,
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                        fontSize: getProportionateScreenHeight(16)),
                  ),
                ),
              ],
            ),
    );
  }

  _launchURL() async {
    var url = _company.website;

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
