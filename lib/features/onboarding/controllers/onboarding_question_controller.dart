import 'package:get/get.dart';
import 'package:outlive/features/auth/controllers/login_controller.dart';
import 'package:outlive/features/auth/screens/login_screen.dart';

class OnboardingQuestionController extends GetxController {

  final List<String> questions = [
    '“What will remain from you?”',
    '“Build ongoing reward through beneficial reminders and knowledge.”',
    '“Create deeds that continue beyond your lifetime.”'
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