import 'package:thibolt/common_libs.dart';
import 'package:thibolt/pages/workout_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: lightTheme,
      home: const ListPage(),
    );
  }
}
