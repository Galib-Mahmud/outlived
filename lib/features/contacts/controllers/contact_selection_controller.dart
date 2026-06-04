
import 'package:get/get.dart';

class ContactModel {
  final String name;
  final String phone;
  final String category;

  ContactModel({
    required this.name,
    required this.phone,
    required this.category,
  });
}

class ContactSelectionController extends GetxController {
  /// Search
  var searchQuery = ''.obs;

  /// Selected category filter
  var selectedCategory = RxnString();

  /// Selected contacts (MULTI SELECT)
  var selectedContacts = <ContactModel>[].obs;

  /// Demo data (replace later with real contacts API/device)
  final List<ContactModel> contacts = [
    ContactModel(name: 'Adnan', phone: '+880123456789', category: 'Muslim'),
    ContactModel(name: 'Asif', phone: '+880198765432', category: 'Invite'),
    ContactModel(name: 'Bilal', phone: '+880155555555', category: 'Legacy'),
    ContactModel(name: 'Omar', phone: '+880111111111', category: 'Muslim'),
    ContactModel(name: 'Rahim', phone: '+880222222222', category: 'Invite'),
  ];

  /// Toggle single contact
  void toggleContact(ContactModel contact) {
    if (selectedContacts.contains(contact)) {
      selectedContacts.remove(contact);
    } else {
      selectedContacts.add(contact);
    }
  }

  /// Toggle group selection
  void toggleGroup(List<ContactModel> groupContacts) {
    final allSelected =
    groupContacts.every((c) => selectedContacts.contains(c));

    if (allSelected) {
      selectedContacts.removeWhere((c) => groupContacts.contains(c));
    } else {
      for (var c in groupContacts) {
        if (!selectedContacts.contains(c)) {
          selectedContacts.add(c);
        }
      }
    }
  }

  /// Filter + Grouping
  List<Map<String, dynamic>> get groupedContacts {
    Iterable<ContactModel> list = contacts;

    /// category filter
    if (selectedCategory.value != null) {
      list = list.where((c) => c.category == selectedCategory.value);
    }

    /// search filter
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      list = list.where((c) =>
      c.name.toLowerCase().contains(q) ||
          c.phone.contains(q));
    }

    /// group by first letter
    final Map<String, List<ContactModel>> map = {};

    for (var c in list) {
      final key = c.name[0].toUpperCase();
      map.putIfAbsent(key, () => []).add(c);
    }

    final keys = map.keys.toList()..sort();

    return keys.map((k) {
      return {
        'letter': k,
        'contacts': map[k]!,
      };
    }).toList();
  }
}