import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'model/app_state_model.dart';                 // NEW

void main() {
  return runApp(
    ChangeNotifierProvider<AppStateModel>(            // NEW
      create: (__) => AppStateModel()..loadProducts(), // NEW
      /// unused parameter: use __ to replace
      child: CupertinoStoreApp(),                     // NEW
    ),
  );
}