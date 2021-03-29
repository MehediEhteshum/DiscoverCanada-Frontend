import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:provider/provider.dart';

import 'screens/chapters_overview_screen.dart';
import 'screens/topics_overview_screen.dart';
import './models and providers/selected_topic_provider.dart';
import './models and providers/selected_province_provider.dart';
import './models and providers/specific_chapters_provider.dart';
import './models and providers/internet_connectivity_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext _) {
    print("Memeory leaks? build main");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => SelectedTopic(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SelectedProvince(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SpecificChapters(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => InternetConnectivity(),
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
