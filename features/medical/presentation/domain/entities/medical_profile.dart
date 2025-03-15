import 'package:equatable/equatable.dart';

class MedicalProfile extends Equatable {
  final String id;
  final String bloodType;
  final List<String> allergies;
  final List<String> medications;
  final List<String> conditions;
  final String? doctorName;
  final String? doctorContact;
  final String? hospitalPreference;
  final DateTime lastUpdated;

  const MedicalProfile({
    required this.id,
    required this.bloodType,
    required this.allergies,
    required this.medications,
    required this.conditions,
    this.doctorName,
    this.doctorContact,
    this.hospitalPreference,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        id,
        bloodType,
        allergies,
        medications,
        conditions,
        doctorName,
        doctorContact,
        hospitalPreference,
        lastUpdated,
      ];

  factory MedicalProfile.fromJson(Map<String, dynamic> json) {
    return MedicalProfile(
      id: json['id'],
      bloodType: json['bloodType'],
      allergies: List<String>.from(json['allergies']),
      medications: List<String>.from(json['medications']),
      conditions: List<String>.from(json['conditions']),
      doctorName: json['doctorName'],
      doctorContact: json['doctorContact'],
      hospitalPreference: json['hospitalPreference'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bloodType': bloodType,
      'allergies': allergies,
      'medications': medications,
      'conditions': conditions,
      'doctorName': doctorName,
      'doctorContact': doctorContact,
      'hospitalPreference': hospitalPreference,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}