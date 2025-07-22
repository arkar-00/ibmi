import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ibmi/utils/calculator.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  test("Give height and weight when calculateBMI function invoked ", () {
    const height = 70; // inches
    const weight = 160; // lbs
    final bmi = calculateBMI(weight, height);
    expect(bmi, 22.955102040816328);
  });

  test(
    "Given up url when calculateBMIAsync function invoked Then correct BMI returned",
    () async {
      final _movkDio = MockDio();

      when(() => _movkDio.get("https://www.jsonkeeper.com/b/UXIJ")).thenAnswer(
        (_) async => Future.value(
          Response(
            data: {
              "Sergio Ramos": [72, 165],
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        ),
      );

      var bmi = await calculateBMIAsync(_movkDio);
      expect(bmi, 1.8591735537190084);
    },
  );
}
