import 'package:get/get.dart';
import 'package:outlive/features/account_setup/screens/social_setup_screen.dart';
import 'package:outlive/features/home/screens/home_screen.dart';

class StepItem {
  final String stepNumber;
  final String? titleSuffix;
  final String? description;
  final String? subLabel;
  final List<String>? bulletPoints;

  StepItem({
    required this.stepNumber,
    this.titleSuffix,
    this.description,
    this.subLabel,
    this.bulletPoints,
  });
}

class CreateAccountController extends GetxController {
  var selectedTab = 0.obs; // 0 for Facebook, 1 for Instagram

  void changeTab(int index) {
    selectedTab.value = index;
  }

  // Pure data list for Facebook instructions
  final List<StepItem> facebookSteps = [
    StepItem(stepNumber: 'Step 1', description: 'Open your Facebook profile'),
    StepItem(stepNumber: 'Step 2', description: 'Tap Profile Menu (... / Options)'),
    StepItem(stepNumber: 'Step 3', description: 'Select Turn On Professional Mode'),
    StepItem(stepNumber: 'Step 4', description: 'Tap Turn On'),
    StepItem(
      stepNumber: 'Step 5',
      titleSuffix: ' — Creator Category Setup',
      subLabel: 'Select category:',
      bulletPoints: ['Digital Creator', 'Blogger', 'Public Figure', 'Video Creator', 'Education', 'Religious Organization', 'Community'],
    ),
    StepItem(
      stepNumber: 'Step 6',
      titleSuffix: ' — Profile Setup',
      subLabel: 'Fill:',
      bulletPoints: ['Profile Photo', 'Cover Photo', 'Bio', 'Category', 'Website (Optional)'],
    ),
    StepItem(
      stepNumber: 'Step 7',
      titleSuffix: ' — Audience Settings',
      subLabel: 'Choose:',
      bulletPoints: ['Public followers ON', 'Friend requests', 'Message settings'],
    ),
    StepItem(
      stepNumber: 'Step 8',
      titleSuffix: ' — Creator Tools',
      subLabel: 'Enable:',
      bulletPoints: ['Professional Dashboard', 'Insights', 'Content Monetization (If eligible)', 'Audience Analytics'],
    ),
    StepItem(stepNumber: 'Step 9', description: 'Finish → Start posting content'),
  ];

  // Pure data list for Instagram instructions
  final List<StepItem> instagramSteps = [
    StepItem(stepNumber: 'Step 1', description: 'Open Instagram'),
    StepItem(stepNumber: 'Step 2', description: 'Go to Profile'),
    StepItem(stepNumber: 'Step 3', description: 'Tap ☰ Menu'),
    StepItem(stepNumber: 'Step 4', subLabel: 'Open:\nSettings & Privacy'),
    StepItem(stepNumber: 'Step 5', subLabel: 'Select:\nAccount Type & Tools / Account'),
    StepItem(stepNumber: 'Step 6', subLabel: 'Tap:\nSwitch To Professional Account'),
    StepItem(stepNumber: 'Step 7', subLabel: 'Choose:\nCreator (NOT Business)'),
    StepItem(
      stepNumber: 'Step 8',
      subLabel: 'Examples:',
      bulletPoints: ['Digital Creator', 'Influencer', 'Public Figure', 'Education', 'Blogger', 'Artist', 'Religious Figure'],
    ),
    StepItem(
      stepNumber: 'Step 9',
      subLabel: 'Fill:',
      bulletPoints: ['Email', 'Phone Number (optional)', 'Location (optional)'],
    ),
    StepItem(
      stepNumber: 'Step 10',
      titleSuffix: ' — Display Options',
      subLabel: 'Toggle:',
      bulletPoints: ['Show Category Label → ON/OFF', 'Show Contact Info → ON/OFF'],
    ),
  ];

  void completeSetup() {
    if (selectedTab.value == 0) {
      selectedTab.value = 1;
    } else {
      Get.to(SocialSetupScreen());
    }
  }
}