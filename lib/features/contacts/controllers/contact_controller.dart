import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';

class ContactModel {
  // The device's own contact id, when this came from the address book.
  // Null for contacts created purely inside the app.
  final String? deviceId;
  final String name;
  final String phone;
  // 'Muslim' | 'Invite To Islam' | 'Legacy Recipient' | null (unassigned).
  // Device contacts have no inherent category, so this starts null.
  final String? category;

  ContactModel({
    this.deviceId,
    required this.name,
    required this.phone,
    this.category,
  });

  // Content equality (not identity) so a contact still matches itself in
  // a Set/List after setCategory() replaces it with a new instance —
  // otherwise a re-categorized contact would silently vanish from any
  // existing selection.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is ContactModel &&
              deviceId == other.deviceId &&
              name == other.name &&
              phone == other.phone);

  @override
  int get hashCode => Object.hash(deviceId, name, phone);
}

class ContactController extends GetxController {
  var searchQuery = ''.obs;
  var selectedCategory = RxnString();

  final RxList<ContactModel> masterContacts = <ContactModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  // v2's PermissionStatus enum (unlike v1's plain bool) actually
  // distinguishes denied from permanentlyDenied/restricted, so this is
  // set precisely in fetchDeviceContacts() rather than guessed.
  final RxBool likelyPermanentlyDenied = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDeviceContacts();
  }

  Future<void> fetchDeviceContacts() async {
    isLoading.value = true;
    errorMessage.value = '';
    likelyPermanentlyDenied.value = false;
    try {
      final status = await FlutterContacts.permissions.request(PermissionType.readWrite);

      if (status == PermissionStatus.permanentlyDenied || status == PermissionStatus.restricted) {
        errorMessage.value =
        'Contacts permission is blocked. Please enable it from system Settings.';
        likelyPermanentlyDenied.value = true;
        return;
      }
      if (status != PermissionStatus.granted && status != PermissionStatus.limited) {
        errorMessage.value =
        'Contacts permission was not granted. Please allow access to see your contacts.';
        return;
      }

      final deviceContacts = await FlutterContacts.getAll(
        properties: {ContactProperty.phone},
      );

      final mapped = <ContactModel>[];
      for (final c in deviceContacts) {
        final name = (c.displayName ?? '').trim();
        if (name.isEmpty) continue;
        // This screen's rows and search assume a phone number; skip
        // entries that don't have one rather than showing a blank field.
        if (c.phones.isEmpty) continue;
        mapped.add(ContactModel(deviceId: c.id, name: name, phone: c.phones.first.number));
      }
      mapped.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      masterContacts.assignAll(mapped);
    } catch (e) {
      errorMessage.value = 'Could not load contacts from your device.';
      debugPrint('ContactController.fetchDeviceContacts error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // For the "permanently denied" case — sends the user to system Settings
  // to grant it manually, since re-requesting won't show a dialog anymore.
  Future<void> openPermissionSettings() => FlutterContacts.permissions.openSettings();

  // ── Counters ──
  // NOTE: these will read 0 until contacts get categorized — device
  // contacts have no built-in category. setCategory() below is how
  // CreateContactScreen's (now working) Save flow assigns one.
  int get countMuslim => masterContacts.where((c) => c.category == 'Muslim').length;
  int get countInvite => masterContacts.where((c) => c.category == 'Invite To Islam').length;
  int get countLegacy => masterContacts.where((c) => c.category == 'Legacy Recipient').length;

  void toggleCategory(String category) {
    selectedCategory.value = selectedCategory.value == category ? null : category;
  }

  // Assigns/changes a contact's category in place.
  void setCategory(ContactModel contact, String category) {
    final index = masterContacts.indexOf(contact);
    if (index == -1) return;
    masterContacts[index] = ContactModel(
      deviceId: contact.deviceId,
      name: contact.name,
      phone: contact.phone,
      category: category,
    );
  }

  // Adds a brand-new contact created inside the app (not from the device
  // picker) — used by CreateContactScreen's Save button.
  void addContact(ContactModel contact) {
    masterContacts.add(contact);
  }

  List<Map<String, dynamic>> get filteredGroupedContacts {
    Iterable<ContactModel> list = masterContacts;

    if (selectedCategory.value != null) {
      list = list.where((c) => c.category == selectedCategory.value);
    }

    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      list = list.where(
            (c) => c.name.toLowerCase().contains(query) || c.phone.contains(query),
      );
    }

    final Map<String, List<ContactModel>> groups = {};
    for (var contact in list) {
      if (contact.name.isEmpty) continue;
      final firstLetter = contact.name[0].toUpperCase();
      groups.putIfAbsent(firstLetter, () => []).add(contact);
    }

    final sortedKeys = groups.keys.toList()..sort();
    return sortedKeys.map((key) => {'letter': key, 'contacts': groups[key]!}).toList();
  }
}