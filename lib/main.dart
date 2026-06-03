import 'package:flutter/widgets.dart';
import 'package:pdfrx/pdfrx.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await pdfrxFlutterInitialize();
  runApp(const ColorWeaknessHelperApp());
}
