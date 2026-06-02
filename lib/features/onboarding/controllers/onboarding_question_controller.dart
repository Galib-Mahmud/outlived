import 'package:get/get.dart';

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
      // Handle completion of onboarding questions, e.g., navigate to next screen
      Get.toNamed('/welcome'); // Update with your actual target route
    }
  }

}