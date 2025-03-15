import 'package:equatable/equatable.dart';

class Appointment extends Equatable {
  final String id;
  final String doctorId;
  final String patientId;
  final DateTime dateTime;
  final Duration duration;
  final AppointmentType type;
  final AppointmentStatus status;
  final double fee;
  final String currency;
  final String? notes;
  final List<String> symptoms;
  final bool isFollowUp;
  final String? previousAppointmentId;

  const Appointment({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.dateTime,
    required this.duration,
    required this.type,
    required this.status,
    required this.fee,
    required this.currency,
    this.notes,
    required this.symptoms,
    required this.isFollowUp,
    this.previousAppointmentId,
  });

  @override
  List<Object?> get props => [
    id,
    doctorId,
    patientId,
    dateTime,
    duration,
    type,
    status,
    fee,
    currency,
    notes,
    symptoms,
    isFollowUp,
    previousAppointmentId,
  ];

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      doctorId: json['doctorId'],
      patientId: json['patientId'],
      dateTime: DateTime.parse(json['dateTime']),
      duration: Duration(minutes: json['duration']),
      type: AppointmentType.values.firstWhere(
        (e) => e.toString() == 'AppointmentType.${json['type']}',
      ),
      status: AppointmentStatus.values.firstWhere(
        (e) => e.toString() == 'AppointmentStatus.${json['status']}',
      ),
      fee: json['fee'].toDouble(),
      currency: json['currency'],
      notes: json['notes'],
      symptoms: List<String>.from(json['symptoms']),
      isFollowUp: json['isFollowUp'],
      previousAppointmentId: json['previousAppointmentId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'patientId': patientId,
      'dateTime': dateTime.toIso8601String(),
      'duration': duration.inMinutes,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'fee': fee,
      'currency': currency,
      'notes': notes,
      'symptoms': symptoms,
      'isFollowUp': isFollowUp,
      'previousAppointmentId': previousAppointmentId,
    };
  }
}

enum AppointmentType { online, inPerson, emergency }

enum AppointmentStatus { scheduled, confirmed, completed, cancelled, noShow }
