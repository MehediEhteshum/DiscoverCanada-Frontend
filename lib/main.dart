import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:provider/provider.dart';

import 'screens/chapters_overview_screen.dart';
import 'screens/topics_overview_screen.dart';
import './models and providers/selected_topic_provider.dart';
import './models and providers/selected_province_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext _) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => SelectedTopic(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SelectedProvince(),
        ),
      ],
      child: MaterialApp(
        title: 'Discover Canada',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: "/",
        routes: {
          "/": (ctx) => TopicsOverviewScreen(),
          ChaptersOverviewScreen.routeName: (ctx) => ChaptersOverviewScreen(),
        },
      ),
    );
  }
}
