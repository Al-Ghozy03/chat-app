import 'package:get/get.dart';

class Controller extends GetxController {
  RxInt totalFriend = 0.obs;
  increment(f) => totalFriend + f;
  toDefault() => totalFriend - totalFriend.toInt();
}
