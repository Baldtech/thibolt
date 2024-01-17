import 'package:thibolt/common/app_bar.dart';
import 'package:thibolt/common_libs.dart';
import 'package:thibolt/pages/details.dart';
import 'package:thibolt/pages/list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: lightTheme,
      home: Scaffold(
        appBar: const NavBar(),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: const ListPage(),
        ),
      ),
    );
  }
}
