import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app.dart';
import 'app_repositories.dart';
import 'core/debug_flags.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  runApp(
    LibraryApp(
      repositories: AppRepositories.connect(debugFlags: readDebugFlags(Uri.base)),
    ),
  );
}
