import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/emergency_bloc.dart';
import '../../domain/entities/emergency_contact.dart';
import '../widgets/emergency_contact_form.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Mode'),
        backgroundColor: Colors.red,
      ),
      body: BlocConsumer<EmergencyBloc, EmergencyState>(
        listener: (context, state) {
          if (state is EmergencyError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is EmergencyAlertSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Emergency alert sent successfully'),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is EmergencyLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EmergencyContactsLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildEmergencyButton(context),
                    const SizedBox(height: 24),
                    _buildContactsList(context, state.contacts),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _showAddContactDialog(context),
                      child: const Text('Add Emergency Contact'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<EmergencyBloc>().add(LoadEmergencyContacts());
              },
              child: const Text('Load Emergency Contacts'),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmergencyButton(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        context.read<EmergencyBloc>().add(
          const SendEmergencyAlert(
            'EMERGENCY: I need immediate assistance. This is an automated alert.',
          ),
        );
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'HOLD FOR EMERGENCY',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactsList(
    BuildContext context,
    List<EmergencyContact> contacts,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Emergency Contacts',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...contacts.map((contact) => _buildContactCard(context, contact)),
      ],
    );
  }

  Widget _buildContactCard(BuildContext context, EmergencyContact contact) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(contact.name),
        subtitle: Text('${contact.relationship} - ${contact.phoneNumber}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditContactDialog(context, contact),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                context.read<EmergencyBloc>().add(
                  RemoveEmergencyContact(contact.id),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            child: EmergencyContactForm(
              onSubmit: (contact) {
                context.read<EmergencyBloc>().add(AddEmergencyContact(contact));
                Navigator.pop(context);
              },
            ),
          ),
    );
  }

  void _showEditContactDialog(BuildContext context, EmergencyContact contact) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            child: EmergencyContactForm(
              contact: contact,
              onSubmit: (updatedContact) {
                context.read<EmergencyBloc>().add(
                  UpdateEmergencyContact(updatedContact),
                );
                Navigator.pop(context);
              },
            ),
          ),
    );
  }
}
