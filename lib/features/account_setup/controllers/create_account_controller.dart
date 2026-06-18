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
    StepItem(stepNumber: 'Step 1', description: 'Open Facebook.'),
    StepItem(stepNumber: 'Step 2', description: 'Tap the Menu icon (☰).'),
    StepItem(stepNumber: 'Step 3', description: 'Tap the dropdown arrow beside your account.'),
    StepItem(stepNumber: 'Step 4', description: 'Select Create New Page.'),
    StepItem(
      stepNumber: 'Step 5',
      description: 'Enter a Page Name.'
    ),
    StepItem(
      stepNumber: 'Step 6',
      subLabel: 'Choose:',
      bulletPoints: ['Education', ' Personal Blog'],
    ),
    StepItem(
      stepNumber: 'Step 7',
      subLabel: 'Tap Create.',
    ),
    StepItem(
      stepNumber: 'Step 8',
      subLabel: 'Select Creator as the Page Type.',
    ),

    StepItem(
      stepNumber: 'Step 9',
      subLabel: 'Add a profile picture and customize your page.',
    ),
    StepItem(
      stepNumber: 'Step 10',
      subLabel: 'Invite friends if you wish.',
    ),
    StepItem(
      stepNumber: 'Step 11',
      subLabel: 'Choose whether to enable or disable notifications.',
    ),
  ];

  // Pure data list for Instagram instructions
  final List<StepItem> instagramSteps = [
    StepItem(stepNumber: 'Step 1', description: 'Open Instagram.'),
    StepItem(stepNumber: 'Step 2', description: 'Go to your Profile.'),
    StepItem(stepNumber: 'Step 3', description: 'Edit Profile.'),
    StepItem(stepNumber: 'Step 4', subLabel: 'Select Switch to Professional Account.'),

    StepItem(
      stepNumber: 'Step 6',
      subLabel: 'Choose the category::',
      bulletPoints: [' Personal Blog'],
    ),

    StepItem(stepNumber: 'Step 7', subLabel: 'Continue and confirm.'),
    StepItem(stepNumber: 'Step 8', subLabel: 'Select Creator.'),
    StepItem(stepNumber: 'Step 9', subLabel: 'Complete your profile information.'),
  ];

  void completeSetup() {
    if (selectedTab.value == 0) {
      selectedTab.value = 1;
    } else {
      Get.to(SocialSetupScreen());
    }
  }
}