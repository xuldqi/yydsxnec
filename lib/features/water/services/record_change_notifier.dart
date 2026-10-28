import 'package:flutter/foundation.dart';

class RecordChangeNotifier {
  RecordChangeNotifier._();

  static final ValueNotifier<int> changes = ValueNotifier<int>(0);

  static void notifyChanged() {
    changes.value++;
  }
}
