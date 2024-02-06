import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:water_intake/model/water_mode.dart';
import 'package:http/http.dart' as http;

class WaterData extends ChangeNotifier {
  List<WaterModel> waterDataList = [];

  // add water
  void addWater(WaterModel water) async {
    final url =
        Uri.https('water-intaker-default-rtdb.firebaseio.com', 'water.json');

    var response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'amount': double.parse(water.amount.toString()),
          'unit': 'ml',
          'dateTime': DateTime.now().toString()
        }));

    notifyListeners();
  }

  Future<List<WaterModel>> getWater() async {
    final url =
        Uri.https('water-intaker-default-rtdb.firebaseio.com', 'water.json');

    final response = await http.get(url);
    if (response.statusCode == 200 && response.body != 'null') {
      // we are good to go
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      for (var element in extractedData.entries) {
        waterDataList.add(WaterModel(
            amount: element.value['amount'],
            dateTime: DateTime.parse(element.value['dateTime']),
            unit: element.value['unit']));
      }
    }
    notifyListeners();
    return waterDataList;
  }
}
