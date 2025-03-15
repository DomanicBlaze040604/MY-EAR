import '../entities/emergency_contact.dart';

abstract class EmergencyRepository {
  Future<List<EmergencyContact>> getContacts();
  Future<void> addContact(EmergencyContact contact);
  Future<void> removeContact(String id);
  Future<void> updateContact(EmergencyContact contact);
  Future<void> sendEmergencyAlert(String message);
  Future<Map<String, double>> getCurrentLocation();
}
