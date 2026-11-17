import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  final initial = await decideInitialLocation(container);
  runApp(UncontrolledProviderScope(
    container: container,
    child: OverviewApp(initialLocation: initial),
  ));
}
