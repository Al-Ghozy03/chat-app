import 'package:get/get.dart';

class Controller extends GetxController {
  RxInt totalFriend = 0.obs;
  setFriend(total) => totalFriend.value = total;
}
