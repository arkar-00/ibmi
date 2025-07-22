import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

double calculateBMI(int weight, int height) {
  if (height <= 0) {
    throw ArgumentError("Height must be greater than zero.");
  }
  return (weight / pow(height, 2)) * 703; // BMI formula for lbs and inches
}

String getBMICategory(double bmi) {
  if (bmi < 18.5) {
    return "Underweight";
  } else if (bmi < 24.9) {
    return "Normal weight";
  } else if (bmi < 29.9) {
    return "Overweight";
  } else {
    return "Obesity";
  }
}

Future<double> calculateBMIAsync(Dio dio) async {
  var result = await dio.get('https://www.jsonkeeper.com/b/UXIJ');
  var data = result.data;
  var bmi = calculateBMI(data['Sergio Ramos'][0], data['Sergio Ramos'][1]);
  return bmi;
}
