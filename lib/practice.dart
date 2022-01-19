import 'package:flutter/cupertino.dart';

void main() {
  // try {
  //   int result = 4 ~/ 0;
  //   debugPrint("$result");
  // } catch (e) {
  //   debugPrint("$e");
  // }

  try {
    int result = 4 ~/ 0;
    debugPrint("$result");
  } catch (e, s) {
    debugPrint("$e ");
    debugPrint("$s ");
  } finally {
    debugPrint("finally i got executed");
  }
}
