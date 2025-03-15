import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/emergency_contact.dart';
import '../../domain/repositories/emergency_repository.dart';

part 'emergency_event.dart';
part 'emergency_state.dart';

class EmergencyBloc extends Bloc<EmergencyEvent, EmergencyState> {
  final EmergencyRepository repository;

  EmergencyBloc(this.repository) : super(EmergencyInitial()) {
    on<LoadEmergencyContacts>(_onLoadContacts);
    on<AddEmergencyContact>(_onAddContact);
    on<RemoveEmergencyContact>(_onRemoveContact);
    on<UpdateEmergencyContact>(_onUpdateContact);
    on<SendEmergencyAlert>(_onSendAlert);
  }

  Future<void> _onLoadContacts(
    LoadEmergencyContacts event,
    Emitter<EmergencyState> emit,
  ) async {
    try {
      emit(EmergencyLoading());
      final contacts = await repository.getContacts();
      emit(EmergencyContactsLoaded(contacts));
    } catch (e) {
      emit(EmergencyError('Failed to load contacts: $e'));
    }
  }

  Future<void> _onAddContact(
    AddEmergencyContact event,
    Emitter<EmergencyState> emit,
  ) async {
    try {
      await repository.addContact(event.contact);
      final contacts = await repository.getContacts();
      emit(EmergencyContactsLoaded(contacts));
    } catch (e) {
      emit(EmergencyError('Failed to add contact: $e'));
    }
  }

  Future<void> _onRemoveContact(
    RemoveEmergencyContact event,
    Emitter<EmergencyState> emit,
  ) async {
    try {
      await repository.removeContact(event.contactId);
      final contacts = await repository.getContacts();
      emit(EmergencyContactsLoaded(contacts));
    } catch (e) {
      emit(EmergencyError('Failed to remove contact: $e'));
    }
  }

  Future<void> _onUpdateContact(
    UpdateEmergencyContact event,
    Emitter<EmergencyState> emit,
  ) async {
    try {
      await repository.updateContact(event.contact);
      final contacts = await repository.getContacts();
      emit(EmergencyContactsLoaded(contacts));
    } catch (e) {
      emit(EmergencyError('Failed to update contact: $e'));
    }
  }

  Future<void> _onSendAlert(
    SendEmergencyAlert event,
    Emitter<EmergencyState> emit,
  ) async {
    try {
      emit(EmergencySending());
      await repository.sendEmergencyAlert(event.message);
      emit(EmergencyAlertSent());
    } catch (e) {
      emit(EmergencyError('Failed to send alert: $e'));
    }
  }
}
