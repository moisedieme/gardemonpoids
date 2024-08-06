// lib/weight_chart.dart

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:garde_mon_poids/services/secure_storage.dart';
//import 'package:garde_mon_poids/services/secure_storage.dart';

class WeightChart extends StatefulWidget {
  @override
  _WeightChartState createState() => _WeightChartState();
}

class _WeightChartState extends State<WeightChart> {
  final SecureStorage _secureStorage = SecureStorage();
  List<charts.Series<WeightData, DateTime>> _seriesList = [];
  bool _loading = true;
  //final TextEditingController _weightController = TextEditingController();
  //final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    List<String> weightEntries = await _secureStorage.getWeights();
    List<WeightData> data = weightEntries.map((entry) {
      List<String> parts = entry.split('|');
      DateTime date = DateTime.parse(parts[0]);
      double weight = double.parse(parts[1]);
      return WeightData(date, weight);
    }).toList();

    setState(() {
      _seriesList = [
        charts.Series<WeightData, DateTime>(
          id: 'Poids',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (WeightData weight, _) => weight.date,
          measureFn: (WeightData weight, _) => weight.weight,
          data: data,
          labelAccessorFn: (WeightData row, _) => '${row.date.toLocal().day}/${row.date.toLocal().month}: ${row.weight.toString()}kg',
        )
      ];
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : charts.TimeSeriesChart(
      _seriesList,
      animate: true,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      behaviors: [
        charts.ChartTitle('Date',
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
        charts.ChartTitle('Poids (kg)',
            behaviorPosition: charts.BehaviorPosition.start,
            titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
        charts.LinePointHighlighter(
          showHorizontalFollowLine: charts.LinePointHighlighterFollowLineType.nearest,
          showVerticalFollowLine: charts.LinePointHighlighterFollowLineType.nearest,
        ),
      ],
      selectionModels: [
        charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          changedListener: (charts.SelectionModel model) {
            if (model.hasDatumSelection)
              print(model.selectedSeries[0].measureFn(model.selectedDatum[0].index));
          },
        ),
      ],
    );
  }
}

class WeightData {
  final DateTime date;
  final double weight;

  WeightData(this.date, this.weight);
}
