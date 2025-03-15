import 'package:equatable/equatable.dart';

class DoctorProfile extends Equatable {
  final String id;
  final String name;
  final String specialization;
  final String qualifications;
  final String hospitalAffiliation;
  final String photoUrl;
  final String about;
  final List<String> languages;
  final List<String> expertiseAreas;
  final Map<String, dynamic> availability;
  final double rating;
  final int totalPatients;
  final int yearsOfExperience;
  final bool isAvailableOnline;
  final ConsultationFees fees;

  const DoctorProfile({
    required this.id,
    required this.name,
    required this.specialization,
    required this.qualifications,
    required this.hospitalAffiliation,
    required this.photoUrl,
    required this.about,
    required this.languages,
    required this.expertiseAreas,
    required this.availability,
    required this.rating,
    required this.totalPatients,
    required this.yearsOfExperience,
    required this.isAvailableOnline,
    required this.fees,
  });

  @override
  List<Object> get props => [
    id,
    name,
    specialization,
    qualifications,
    hospitalAffiliation,
    photoUrl,
    about,
    languages,
    expertiseAreas,
    availability,
    rating,
    totalPatients,
    yearsOfExperience,
    isAvailableOnline,
    fees,
  ];

  factory DoctorProfile.fromJson(Map<String, dynamic> json) {
    return DoctorProfile(
      id: json['id'],
      name: json['name'],
      specialization: json['specialization'],
      qualifications: json['qualifications'],
      hospitalAffiliation: json['hospitalAffiliation'],
      photoUrl: json['photoUrl'],
      about: json['about'],
      languages: List<String>.from(json['languages']),
      expertiseAreas: List<String>.from(json['expertiseAreas']),
      availability: json['availability'],
      rating: json['rating'].toDouble(),
      totalPatients: json['totalPatients'],
      yearsOfExperience: json['yearsOfExperience'],
      isAvailableOnline: json['isAvailableOnline'],
      fees: ConsultationFees.fromJson(json['fees']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'qualifications': qualifications,
      'hospitalAffiliation': hospitalAffiliation,
      'photoUrl': photoUrl,
      'about': about,
      'languages': languages,
      'expertiseAreas': expertiseAreas,
      'availability': availability,
      'rating': rating,
      'totalPatients': totalPatients,
      'yearsOfExperience': yearsOfExperience,
      'isAvailableOnline': isAvailableOnline,
      'fees': fees.toJson(),
    };
  }
}

class ConsultationFees {
  final double online;
  final double inPerson;
  final double followUp;
  final String currency;

  ConsultationFees({
    required this.online,
    required this.inPerson,
    required this.followUp,
    required this.currency,
  });

  factory ConsultationFees.fromJson(Map<String, dynamic> json) {
    return ConsultationFees(
      online: json['online'].toDouble(),
      inPerson: json['inPerson'].toDouble(),
      followUp: json['followUp'].toDouble(),
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'online': online,
      'inPerson': inPerson,
      'followUp': followUp,
      'currency': currency,
    };
  }
}
