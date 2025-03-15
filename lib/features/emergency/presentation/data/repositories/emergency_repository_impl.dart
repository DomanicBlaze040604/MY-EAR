import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/emergency_contact.dart';
import '../../domain/repositories/emergency_repository.dart';

class EmergencyRepositoryImpl implements EmergencyRepository {
  final SharedPreferences _prefs;
  final Location _location = Location();
  static const String _contactsKey = 'emergency_contacts';

  EmergencyRepositoryImpl(this._prefs);

  @override
  Future<List<EmergencyContact>> getContacts() async {
    final String? contactsJson = _prefs.getString(_contactsKey);
    if (contactsJson == null) return [];

    final List<dynamic> decoded = json.decode(contactsJson);
    return decoded.map((json) => _contactFromJson(json)).toList();
  }

  @override
  Future<void> addContact(EmergencyContact contact) async {
    final contacts = await getContacts();
    contacts.add(contact);
    await _saveContacts(contacts);
  }

  @override
  Future<void> removeContact(String id) async {
    final contacts = await getContacts();
    contacts.removeWhere((contact) => contact.id == id);
    await _saveContacts(contacts);
  }

  @override
  Future<void> updateContact(EmergencyContact contact) async {
    final contacts = await getContacts();
    final index = contacts.indexWhere((c) => c.id == contact.id);
    if (index != -1) {
      contacts[index] = contact;
      await _saveContacts(contacts);
    }
  }

  @override
  Future<void> sendEmergencyAlert(String message) async {
    final contacts = await getContacts();
    final location = await getCurrentLocation();

    for (final contact in contacts) {
      final smsUri = Uri.parse(
        'sms:${contact.phoneNumber}?body=$message\nMy location: https://maps.google.com/?q=${location['latitude']},${location['longitude']}',
      );
      await launchUrl(smsUri);
    }
  }

  @override
  Future<Map<String, double>> getCurrentLocation() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        throw Exception('Location service not enabled');
      }
    }

    PermissionStatus permission = await _location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();
      if (permission != PermissionStatus.granted) {
        throw Exception('Location permission not granted');
      }
    }

    final locationData = await _location.getLocation();
    return {
      'latitude': locationData.latitude ?? 0.0,
      'longitude': locationData.longitude ?? 0.0,
    };
  }

  Future<void> _saveContacts(List<EmergencyContact> contacts) async {
    final encoded = json.encode(
      contacts.map((c) => _contactToJson(c)).toList(),
    );
    await _prefs.setString(_contactsKey, encoded);
  }

  Map<String, dynamic> _contactToJson(EmergencyContact contact) {
    return {
      'id': contact.id,
      'name': contact.name,
      'phoneNumber': contact.phoneNumber,
      'relationship': contact.relationship,
      'isPrimary': contact.isPrimary,
    };
  }

  EmergencyContact _contactFromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      relationship: json['relationship'],
      isPrimary: json['isPrimary'] ?? false,
    );
  }
}
