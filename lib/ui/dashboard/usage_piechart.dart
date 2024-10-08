import 'package:assignment/widgets/pie_chart.dart';
import 'package:assignment/providers/websocket_provider.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//pie chart to show the data from websocket cpu and ram memory
class UsagePieChart extends StatefulWidget {
  const UsagePieChart({super.key});

  @override
  State<UsagePieChart> createState() => _UsagePieChartState();
}

class _UsagePieChartState extends State<UsagePieChart> {
  String _username = 'User';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

 //retrieve the username from shared preferences
  void _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'User';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            WindowTitleBarBox(
              child: Row(
                children: [
                  Expanded(child: MoveWindow()),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, right: 8),
                    child: Row(
                      children: [
                        MinimizeWindowButton(),
                        MaximizeWindowButton(),
                        CloseWindowButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Analytics',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF161639),
                      fontSize: 32,
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Hello',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            _username,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF161639),
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Image.asset(
                          'assets/images/user_image.png',
                          fit: BoxFit.contain,
                          height: 80,
                          width: 150,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 120),
            Consumer<WebSocketProvider>(
              builder: (context, usageProvider, child) {
                final usageModel = usageProvider.usageModel;
                if (usageModel == null) {
                  return const CircularProgressIndicator();
                } else {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      double spacing = constraints.maxWidth < 600 ? 30 : 120;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          UsgaePieChartWidget(
                            percentage: usageModel.cpuUsage / 100,
                            text: "CPU",
                          ),
                          SizedBox(width: spacing),
                          UsgaePieChartWidget(
                            percentage: usageModel.ramUsage / 100,
                            text: "RAM",
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
