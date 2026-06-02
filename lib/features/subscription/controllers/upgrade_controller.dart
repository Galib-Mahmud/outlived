import 'package:get/get.dart';

class SubscriptionTier {
  final String id;
  final String title;
  final String description;
  final String price;
  final String iconPath;
  final String? badgeText;

  SubscriptionTier({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.iconPath,
    this.badgeText,
  });
}

class UpgradeController extends GetxController {
  // Reactive variable to track the currently selected subscription plan ID
  var selectedTierId = 'annually'.obs;
  var isLoading = false.obs;

  final List<SubscriptionTier> tiers = [
    SubscriptionTier(
      id: 'quarterly',
      title: 'Quarterly',
      description: 'Perfect for short-term users',
      price: '\$4.99',
      iconPath: 'assets/icons/star.png',
    ),
    SubscriptionTier(
      id: 'annually',
      title: 'Annually',
      description: 'Save more with 12-month access',
      price: '\$13.99',
      iconPath: 'assets/icons/trophy.png',
    ),
    SubscriptionTier(
      id: 'lifetime',
      title: 'Lifetime',
      description: 'Lifetime access with premium benefits',
      price: '\$49.99',
      iconPath: 'assets/icons/crown.png',
      badgeText: 'Save \$9.99',
    ),
  ];

  void selectTier(String id) {
    selectedTierId.value = id;
  }

  void processUpgrade() {
    isLoading.value = true;
    // Implement In-App Purchase logic here using selectedTierId.value
  }
}