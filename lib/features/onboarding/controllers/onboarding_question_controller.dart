import 'package:get/get.dart';
import 'package:outlive/features/auth/controllers/login_controller.dart';
import 'package:outlive/features/auth/screens/login_screen.dart';

class OnboardingQuestionController extends GetxController {

  final List<String> questions = [
    '“In the Name of Allah the Most Gracious the Most Merciful. Assalamu Alaykum. Automate Islamic reminders so good deeds keep flowing.”',
    '“Please follow all steps, everything will be automated thereafter and you will never need to do anything.”',
  ];

  RxInt currentQuestionIndex = 0.obs;

  void goToNextQuestion() {
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
    } else {
      final LoginController loginController = Get.put(LoginController());
      loginController.selectedTab.value = 1;
      Get.to(LoginScreen());
    }
  }

}