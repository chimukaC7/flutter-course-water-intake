import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:water_intake/model/water_model.dart';
import 'package:http/http.dart' as http;
import 'package:water_intake/utils/date_helper.dart';

class WaterData extends ChangeNotifier {
  List<WaterModel> waterDataList = [];

  // add water
  void addWater(WaterModel water) async {
    final url = Uri.https('water-intaker-default-rtdb.firebaseio.com', 'water.json');

    var response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'amount': double.parse(water.amount.toString()),
          'unit': 'ml',
          'dateTime': DateTime.now().toString()
        }));

    if (response.statusCode == 200) {

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      var model = WaterModel(
          id: extractedData['name'],
          amount: water.amount,
          dateTime: water.dateTime,
          unit: 'ml');

      print("Object: $model");

      waterDataList.add(model);

    } else {
      print('Error: ${response.statusCode}');
    }

    notifyListeners();
  }

  Future<List<WaterModel>> getWater() async {
    final url =   Uri.https('water-intaker-default-rtdb.firebaseio.com', 'water.json');

    var response = await http.get(url);

    if (response.statusCode == 200 && response.body != 'null') {

      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      for (var element in extractedData.entries) {
        waterDataList.add(WaterModel(
          id: element.key,
          // must add this so we can delete the item, but also be able to show the id
          amount: element.value['amount'],
          dateTime: DateTime.parse(element.value['dateTime']),
          unit: element.value['unit'],
        ));
      }

    }

    notifyListeners();
    return waterDataList;
  }

  // get weekday from a dateTime object
  String getWeekday(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tues';
      case 3:
        return 'Wed';
      case 4:
        return 'Thur';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';

      default:
        return '';
    }
  }

  DateTime getStartOfWeek() {
    DateTime? startOfWeek;

    //get the current date
    DateTime dateTime = DateTime.now();

    for (int i = 0; i < 7; i++) {
      if (getWeekday(dateTime.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = dateTime.subtract(Duration(days: i));
      }
    }
    return startOfWeek!;
  }

  void delete(WaterModel waterModel) {
    final url = Uri.https('water-intaker-default-rtdb.firebaseio.com',
        'water/${waterModel.id}.json');
    http.delete(url);

    //remove the item from our list
    waterDataList.removeWhere((element) => element.id == waterModel.id!);

    notifyListeners();
  }

  // calculate the weekly water intake
  String calculateWeeklyWaterIntake(WaterData value) {
    double weeklyWaterIntake = 0;

    // loop through the water data list
    for (var water in value.waterDataList) {
      weeklyWaterIntake += double.parse(water.amount.toString());
    }
    return weeklyWaterIntake.toStringAsFixed(2);
  }

  // calculate the daily water intake
  Map<String, double> calculateDailyWaterSummary() {
    Map<String, double> dailyWaterSummary = {};

    // loop through the water data list
    for (var water in waterDataList) {
      String date = convertDateTimeToString(water.dateTime);
      double amount = double.parse(water.amount.toString());

      if (dailyWaterSummary.containsKey(date)) {
        double currentAmount = dailyWaterSummary[date]!;
        currentAmount += amount;
        dailyWaterSummary[date] = currentAmount;
      } else {
        dailyWaterSummary.addAll({date: amount});
      }
    }
    return dailyWaterSummary;
  }
}
