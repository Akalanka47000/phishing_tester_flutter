import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:phishtesterflutter/widgets/customDialog.dart';
import 'dart:convert';

import 'package:phishtesterflutter/widgets/loadingScreen.dart';

Future<dynamic> httpPostRequest(
    {required BuildContext context,
      required String url,
      required Object body}) async {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => LoadingScreen());
  try {
    var response = await http.post(Uri.parse(url), body: body);
    var result = json.decode(response.body);
    Navigator.pop(context); //pop loading
    return result;
  } on SocketException catch (_) {
    Navigator.pop(context); //pop dialog
    msgDialog(context, 'No Internet!!',
        'Internet not available. Please try again later.');
    return null;
  } on Exception catch (_) {
    Navigator.pop(context); //pop dialog
    msgDialog(context, 'Error', 'An error occurred. Please try again later');
    return null;
  }
}
