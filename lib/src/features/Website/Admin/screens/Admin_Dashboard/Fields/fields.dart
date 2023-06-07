import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:uptrain/src/constants/connections.dart';
import 'package:uptrain/src/features/Website/Admin/screens/Admin_Dashboard/Fields/fields_screen.dart';
import 'package:uptrain/src/utils/theme/widget_themes/image_from_url.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../Mobile/authentication/models/field.dart';

class FieldPage extends StatefulWidget {
  const FieldPage({super.key});

  @override
  State<FieldPage> createState() => _FieldPageState();
}

List<Field> filteredFields = [];
List<Field> fields = [];
final controller = TextEditingController();

class _FieldPageState extends State<FieldPage> {
  Future<List<Field>> fetchFields(String search) async {
    final response = await http.get(Uri.parse('http://$ip/api/getFields'));
    final List<dynamic> data = json.decode(response.body);
    setState(() {
      fields = data.map((json) => Field.fromJson(json)).toList();
    });

    if (search.isEmpty) {
      return data.map((json) => Field.fromJson(json)).toList();
    } else {
      return data
          .map((json) => Field.fromJson(json))
          .where((element) => element.name.contains(search.toLowerCase()))
          .toList();
    }
  }

  void filterFields(String query) {
    setState(() {
      // Filter the companies based on the search query
      filteredFields = fields.where((field) {
        final fieldName = field.name.toLowerCase();
        return fieldName.contains(query.toLowerCase());
      }).toList();
    });
  }

  late Future<List<Field>> _futureFields = fetchFields(controller.text);

  @override
  void initState() {
    super.initState();
    _futureFields = fetchFields(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              alignment: AlignmentDirectional.centerStart,
              width: 250,
              child: fieldsSearchField()),
          DataTable(
            // border: TableBorder.all(width: 1.5),
            columns: const [
              DataColumn(
                  label: Text(
                'Field',
                style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: tPrimaryColor),
              )),
              DataColumn(
                  label: Text(
                'Collage',
                style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: tPrimaryColor),
              )),
              DataColumn(
                  label: Text(
                'Supervisor',
                style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: tPrimaryColor),
              )),
              DataColumn(label: Text(' ')),
            ],
            rows: filteredFields
                .map((data) => DataRow(
                      cells: [
                        DataCell(Text('${data.name} ',
                            style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: Colors.black))),
                        DataCell(Text('${data.collage} ',
                            style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: Colors.black))),
                        DataCell(TextButton(
                            onPressed: () {},
                            child: Text('${data.employee}',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    color: Colors.blue)))),
                        DataCell(IconButton(
                          icon: const Icon(Icons.delete),
                          color: tPrimaryColor,
                          onPressed: () async {
                            final response = await http.delete(Uri.parse(
                                'http://$ip/api/admin/deleteField/${data.id}'));
                            print(response.body);
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const FieldsScreen()));

                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('${data.name} Field deleted')));
                          },
                        )),
                      ],
                    ))
                .toList(),
          )
        ],
      ),
    );
  }

  TextField fieldsSearchField() {
    return TextField(
        controller: controller,
        onChanged: filterFields,
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
