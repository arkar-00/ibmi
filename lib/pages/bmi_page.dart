import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ibmi/widgets/infor_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BmiPage extends StatefulWidget {
  @override
  State<BmiPage> createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> {
  late double deviceWidth, deviceHeight;

  int _age = 21;
  int _weight = 120; // lbs
  int _height = 70; // inches
  int _selectedGender = 0; // 0 = Male, 1 = Female

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    deviceWidth = size.width;
    deviceHeight = size.height;

    return CupertinoPageScaffold(
      child: SafeArea(
        child: SizedBox(
          height: deviceHeight * 0.85,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAgeWeightSection(),
              _buildHeightSlider(),
              _buildGenderSelector(),
              _buildCalculateButton(),
            ],
          ),
        ),
      ),
    );
  }

  //========================= UI Sections ==========================//

  Widget _buildAgeWeightSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStepperCard(
          label: 'Age yr',
          value: _age,
          onIncrement: () => _updateAge(1),
          onDecrement: () => _updateAge(-1),
        ),
        _buildStepperCard(
          label: 'Weight lb',
          value: _weight,
          onIncrement: () => _updateWeight(1),
          onDecrement: () => _updateWeight(-1),
        ),
      ],
    );
  }

  Widget _buildStepperCard({
    required String label,
    required int value,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return InforCard(
      width: deviceWidth * 0.45,
      height: deviceHeight * 0.20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          ),
          Text(
            '$value',
            style: const TextStyle(fontSize: 45, fontWeight: FontWeight.w700),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIconButton(Icons.remove, Colors.red, onDecrement),
              _buildIconButton(Icons.add, Colors.green, onIncrement),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(width: 50, child: Icon(icon, size: 30, color: color)),
    );
  }

  Widget _buildHeightSlider() {
    return InforCard(
      width: deviceWidth * 0.90,
      height: deviceHeight * 0.15,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'Height in',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          ),
          Text(
            '$_height',
            style: const TextStyle(fontSize: 45, fontWeight: FontWeight.w700),
          ),
          CupertinoSlider(
            min: 24,
            max: 96,
            value: _height.toDouble(),
            onChanged: (value) => setState(() => _height = value.toInt()),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelector() {
    return InforCard(
      width: deviceWidth * 0.90,
      height: deviceHeight * 0.11,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'Gender',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          ),
          CupertinoSlidingSegmentedControl<int>(
            groupValue: _selectedGender,
            children: const {0: Text("Male"), 1: Text('Female')},
            onValueChanged:
                (value) => setState(() {
                  if (value != null) _selectedGender = value;
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculateButton() {
    return SizedBox(
      height: deviceHeight * 0.07,
      child: CupertinoButton.filled(
        onPressed: _calculateBMI,
        child: const Text(
          'Calculate BMI',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  //========================= Logic ==========================//

  void _updateAge(int delta) {
    setState(() {
      _age = max(1, _age + delta);
    });
  }

  void _updateWeight(int delta) {
    setState(() {
      _weight = max(1, _weight + delta);
    });
  }

  void _calculateBMI() {
    if (_height > 0 && _weight > 0 && _age > 0) {
      final bmi = 703 * (_weight / pow(_height, 2));
      _showResultDialog(bmi);
      // You can push to result page or show CupertinoDialog here
    }
  }

  void _showResultDialog(double bmi) {
    String? status;
    if (bmi < 18.5) {
      status = "Underweight";
    } else if (bmi < 24.9) {
      status = "Normal weight";
    } else if (bmi < 29.9) {
      status = "Overweight";
    } else {
      status = "Obesity";
    }
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('BMI Result'),
          content: Text(
            'Your BMI is ${bmi.toStringAsFixed(2)}\nStatus: $status',
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                _saveResult(bmi.toStringAsFixed(2), status!);
              },
            ),
          ],
        );
      },
    );
  }

  void _saveResult(String bmi, String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bmi_date', DateTime.now().toString());
    await prefs.setStringList('bmi_data', <String>[bmi, status]);
  }
}
