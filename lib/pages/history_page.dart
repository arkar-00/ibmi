import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ibmi/widgets/infor_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<void> _refreshFuture;

  List<String> _bmiData = [];
  String _bmiDate = '';

  @override
  void initState() {
    super.initState();
    _refreshFuture = _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final bmiData = prefs.getStringList('bmi_data') ?? [];
    final date = prefs.getString('bmi_date') ?? 'No date found';

    setState(() {
      _bmiData = bmiData;
      _bmiDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: _loadData),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: FutureBuilder<void>(
                future: _refreshFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CupertinoActivityIndicator();
                  }

                  if (_bmiData.length < 2) {
                    return const Text("No history available");
                  }

                  final bmiValue = _bmiData[0];
                  final status = _bmiData[1];

                  return InforCard(
                    width: deviceWidth * 0.75,
                    height: deviceHeight * 0.25,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatusText(status),
                        _buildDateText(_bmiDate),
                        _buildBmiText(bmiValue),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusText(String status) {
    return Text(
      status,
      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
    );
  }

  Widget _buildDateText(String date) {
    DateTime parsedDate = DateTime.parse(date);
    String formattedDate =
        "${parsedDate.day} / ${parsedDate.month} / ${parsedDate.year}";
    return Text(
      formattedDate,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
    );
  }

  Widget _buildBmiText(String bmi) {
    return Text(
      bmi,
      style: const TextStyle(fontSize: 60, fontWeight: FontWeight.w600),
    );
  }
}
