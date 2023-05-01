import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/constants/text.dart';

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

Future<List<Company>> getCompany(String companyName) async {
  final response = await http
      .get(Uri.parse('http://192.168.1.48:3000/companies/?name=$companyName'));

  final List<dynamic> data = json.decode(response.body);
  print(data);
  return data.map((json) => Company.fromJson(json)).toList();
}

class _CompanyDetailsState extends State<CompanyDetails> {
  late Company _company = Company(
    password: '',
    phone: '',
      id: 0,
      name: '',
      description: '',
      email: '',
      photo: '',
      website: '',
      location: '');
  @override
  void initState() {
    super.initState();
    _loadCompany();
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
                    Image(
                      image: AssetImage("assets/images/${_company.photo}"),
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
                  _company.description,
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
                Text(
                  _company.location,
                  style: bodyTextStyle,
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                const Text(
                  "Website:",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 22,
                    fontFamily: 'Ubuntu',
                  ),
                ),
                // SizedBox(
                //   height: getProportionateScreenHeight(10),
                // ),
                TextButton(
                 onPressed: _launchURL,
                 child: Text(_company.website,
                  style:const TextStyle(decoration: TextDecoration.underline,
                  color: Colors.blue,
                  fontSize: 18),
                 ) ,
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
