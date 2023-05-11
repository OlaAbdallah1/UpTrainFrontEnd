import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

import 'package:uptrain/src/constants/size_config.dart';

class ImageFromUrl extends StatefulWidget {
  final String imageUrl;

  ImageFromUrl({required this.imageUrl});

  @override
  _ImageFromUrlState createState() => _ImageFromUrlState();
}

class _ImageFromUrlState extends State<ImageFromUrl> {
  late Uint8List imageBytes= Uint8List(0);

  @override
  void initState() {
    super.initState();
    loadImageFromNetwork();
  }

Future<void> loadImageFromNetwork() async {
  try {
    final http.Response response = await http.get(Uri.parse(widget.imageUrl));
    final document = parse(response.body);
    final metaTags = document.getElementsByTagName('meta');
    for (var tag in metaTags) {
      if (tag.attributes['property'] == 'og:image') {
        final imageUrl = tag.attributes['content'];
        final http.Response imageResponse = await http.get(Uri.parse(imageUrl!));
        setState(() {
          imageBytes = imageResponse.bodyBytes;
        });
        break;
      }
    }
  } catch (e) {
    print(e);
  }
}


  @override
  Widget build(BuildContext context) {
    return Container(
      child: imageBytes != null
          ? Image.memory(
              imageBytes,
              fit: BoxFit.contain,
              height: getProportionateScreenHeight(170),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
