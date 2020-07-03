import 'package:flutter/material.dart';
import 'package:phishtesterflutter/helper/httpHelper.dart';


Future<dynamic> checkUrl({BuildContext context, String url}) async {
  Object body = {
    'url': url,
    'format': 'json',
    'app_key': '05059fd0069a205a91b5672f38a8f930ff38f1bb45d33eef7928203d97099aed'
  };

  var result = await httpPostRequest(context: context, url: 'https://checkurl.phishtank.com/checkurl/', body: body);
  return Future.value(result);
}