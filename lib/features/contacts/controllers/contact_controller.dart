import 'package:get/get.dart';

class ContactModel {
  final String name;
  final String phone;
  final String category; // 'Muslim', 'Invite To Islam', or 'Legacy Recipient'

  ContactModel({required this.name, required this.phone, required this.category});
}

class ContactController extends GetxController {
  // Active search query stream
  var searchQuery = ''.obs;

  // Selected category filter stream (null means "Show All")
  var selectedCategory = RxnString();

  // Raw Master Contact List Data
  final List<ContactModel> masterContacts = [
    ContactModel(name: 'Adnan', phone: '+880123456789', category: 'Muslim'),
    ContactModel(name: 'Adnan', phone: '+880123456789', category: 'Muslim'),
    ContactModel(name: 'Adnan', phone: '+880123456789', category: 'Muslim'),
    ContactModel(name: 'Asif', phone: '+880198765432', category: 'Invite To Islam'),
    ContactModel(name: 'Bodna', phone: '+880123456789', category: 'Invite To Islam'),
    ContactModel(name: 'Bodna', phone: '+880123456789', category: 'Invite To Islam'),
    ContactModel(name: 'Bilal', phone: '+880155555555', category: 'Legacy Recipient'),
  ];

  // Helper counters for your metric cards
  int get countMuslim => masterContacts.where((c) => c.category == 'Muslim').length;
  int get countInvite => masterContacts.where((c) => c.category == 'Invite To Islam').length;
  int get countLegacy => masterContacts.where((c) => c.category == 'Legacy Recipient').length;

  // Toggle Category Filter Action
  void toggleCategory(String category) {
    if (selectedCategory.value == category) {
      selectedCategory.value = null; // Unselect if tapped again to reset view
    } else {
      selectedCategory.value = category;
    }
  }

  // Reactive Map that computes search criteria and active tabs simultaneously
  List<Map<String, dynamic>> get filteredGroupedContacts {
    // Step 1: Filter by Category first
    Iterable<ContactModel> list = masterContacts;
    if (selectedCategory.value != null) {
      list = list.where((c) => c.category == selectedCategory.value);
    }

    // Step 2: Filter by Search query match
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      list = list.where((c) =>
      c.name.toLowerCase().contains(query) ||
          c.phone.contains(query));
    }

    // Step 3: Group them alphabetically ('A', 'B', etc.) sorted neatly
    final Map<String, List<ContactModel>> groups = {};
    for (var contact in list) {
      if (contact.name.isEmpty) continue;
      final firstLetter = contact.name[0].toUpperCase();
      groups.putIfAbsent(firstLetter, () => []).add(contact);
    }

    // Convert map to sorted iterable list structures for the UI ListView builder
    final sortedKeys = groups.keys.toList()..sort();
    return sortedKeys.map((key) {
      return {
        'letter': key,
        'contacts': groups[key]!,
      };
    }).toList();
  }
}