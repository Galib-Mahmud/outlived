import 'package:get/get.dart';

class PostDetailController extends GetxController {
  // Reactive mock data models matching image_f2c782.png exactly
  var postTitle = 'Prayer is the key to peace'.obs;
  var scheduledTimeText = 'Scheduled : 11 May, 9:00 PM'.obs;
  var savedCount = 3.obs;
  var sharedCount = 8.obs;

  var postContent = (
      'Prayer is not just a ritual; it is a connection with Allah, a source of peace, and a light for the heart. 🤲🏼✨\n\n'
          'No matter how difficult life becomes, return to your prayer — because true peace begins there.\n\n'
          '#IslamicReminder #Prayer #Salah #Peace #Islam #Muslim #Quran #Deen #Allah #IslamicPost'
  ).obs;

  // Edit button action pipeline hook
  void navigateToEditPost() {
    // Get.to(() => const SocialPostScreen());
  }
}