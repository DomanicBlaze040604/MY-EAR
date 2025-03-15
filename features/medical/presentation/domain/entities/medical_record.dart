import 'package:equatable/equatable.dart';

class MedicalRecord extends Equatable {
  final String id;
  final String userId;
  final String doctorId;
  final DateTime date;
  final String diagnosis;
  final List<String> symptoms;
  final List<Prescription> prescriptions;
  final List<String> attachmentUrls;
  final String notes;
  final RecordType type;
  final bool isActive;

  const MedicalRecord({
    required this.id,
    required this.userId,
    required this.doctorId,
    required this.date,
    required this.diagnosis,
    required this.symptoms,
    required this.prescriptions,
    this.attachmentUrls = const [],
    required this.notes,
    required this.type,
    this.isActive = true,
  });

  @override
  List<Object> get props => [
    id,
    userId,
    doctorId,
    date,
    diagnosis,
    symptoms,
    prescriptions,
    attachmentUrls,
    notes,
    type,
    isActive,
  ];

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      id: json['id'],
      userId: json['userId'],
      doctorId: json['doctorId'],
      date: DateTime.parse(json['date']),
      diagnosis: json['diagnosis'],
      symptoms: List<String>.from(json['symptoms']),
      prescriptions:
          (json['prescriptions'] as List)
              .map((e) => Prescription.fromJson(e))
              .toList(),
      attachmentUrls: List<String>.from(json['attachmentUrls'] ?? []),
      notes: json['notes'],
      type: RecordType.values.firstWhere(
        (e) => e.toString() == 'RecordType.${json['type']}',
      ),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'doctorId': doctorId,
      'date': date.toIso8601String(),
      'diagnosis': diagnosis,
      'symptoms': symptoms,
      'prescriptions': prescriptions.map((e) => e.toJson()).toList(),
      'attachmentUrls': attachmentUrls,
      'notes': notes,
      'type': type.toString().split('.').last,
      'isActive': isActive,
    };
  }
}

class Prescription {
  final String id;
  final String medication;
  final String dosage;
  final String frequency;
  final int duration;
  final String instructions;
  final DateTime startDate;
  final bool isActive;

  Prescription({
    required this.id,
    required this.medication,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.instructions,
    required this.startDate,
    this.isActive = true,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['id'],
      medication: json['medication'],
      dosage: json['dosage'],
      frequency: json['frequency'],
      duration: json['duration'],
      instructions: json['instructions'],
      startDate: DateTime.parse(json['startDate']),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medication': medication,
      'dosage': dosage,
      'frequency': frequency,
      'duration': duration,
      'instructions': instructions,
      'startDate': startDate.toIso8601String(),
      'isActive': isActive,
    };
  }
}

enum RecordType { consultation, test, therapy, surgery, followUp }
