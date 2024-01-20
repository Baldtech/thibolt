import 'package:sqlite_schema_upgrader/sqlite_schema_upgrader.dart';
import 'package:thibolt/common_libs.dart';
import 'package:thibolt/data/migrations/202401201538_categories.dart';
import 'package:thibolt/pages/list.dart';

void main() {

  var sqliteSchema = SQLiteSchema();
  sqliteSchema.setCommand(1, Categories202401201538());
  
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
      home: const ListPage(),
    );
  }
}
