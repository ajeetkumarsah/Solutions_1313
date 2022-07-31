import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:solutions_1313/app/model/data_model.dart';

class Repository {
  getData() async {
    var client = http.Client();
    debugPrint('===>Calling API');
    try {
      var response = await client.get(
        Uri.parse(
            'https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=RELIANCE.BSE&outputsize=full&apikey=demo'),
      );
      if (response.statusCode == 401) {
        return debugPrint('==>Error');
      }

      print('==>API Response~~~~~~~~~~~~~~~~~~~~' + response.body.toString());
      return compute(parseData, response.body);
    } catch (exception) {
      debugPrint('==>Exception');
      return "";
    } finally {
      client.close();
    }
  }

  parseData(String responseBody) {
    var data = json.decode(responseBody);

    return Company.fromJson(data);
  }
}
