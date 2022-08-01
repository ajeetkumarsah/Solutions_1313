import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:solutions_1313/app/data/repository.dart';
import 'package:solutions_1313/app/model/data_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

class _GraphScreenState extends State<GraphScreen> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
    calldata();
  }

  Company? data;
  calldata() async {
    data = await Repository().getData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return data == null
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              child: Center(
                child: CircularProgressIndicator(
                    strokeWidth: 0.4, color: Colors.black),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.grey)),
              title: const Text(
                'Solutions 1313',
                style: TextStyle(color: Colors.black),
              ),
              elevation: 0,
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  Neumorphic(
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(24),
                        ),
                        depth: 4,
                        lightSource: LightSource.topLeft,
                        color: Colors.white),
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        // Chart title
                        // title: ChartTitle(text: ''),
                        // Enable legend
                        legend: Legend(isVisible: true),
                        // Enable tooltip
                        tooltipBehavior: _tooltipBehavior,
                        series: <LineSeries<Company, String>>[
                          LineSeries<Company, String>(
                              dataSource: <Company>[
                                Company(
                                    metaData: data!.metaData,
                                    timeSeriesDaily: data!.timeSeriesDaily),
                                Company(
                                    metaData: data!.metaData,
                                    timeSeriesDaily: data!.timeSeriesDaily),
                                Company(
                                    metaData: data!.metaData,
                                    timeSeriesDaily: data!.timeSeriesDaily),
                              ],
                              xValueMapper: (Company series, _) =>
                                  series.timeSeriesDaily.keys.first,
                              yValueMapper: (Company series, _) => int.parse(
                                  series.timeSeriesDaily.entries.first.value
                                      .the6Volume
                                      .toString()),
                              // Enable data label
                              dataLabelSettings:
                                  const DataLabelSettings(isVisible: true))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
