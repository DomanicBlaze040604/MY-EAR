              _selectedDate = date;
              _selectedTime = null; // Reset time when date changes
            });
          },
        ),
      ],
    );
  }

  Widget _buildTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Time',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        TimeSlotPicker(
          availableSlots: _getAvailableSlots(),
          onTimeSelected: (time) {
            setState(() {
              _selectedTime = time;
            });
          },
        ),
      ],
    );
  }

  List<String> _getAvailableSlots() {
    // Implement actual availability logic based on doctor's schedule
    return [
      '09:00 AM',
      '09:30 AM',
      '10:00 AM',
      '10:30 AM',
      '11:00 AM',
      '11:30 AM',
      '02:00 PM',
      '02:30 PM',
      '03:00 PM',
      '03:30 PM',
    ];
  }

  Widget _buildSymptomsInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Symptoms',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _symptomsController,
          decoration: const InputDecoration(
            hintText: 'Enter your symptoms...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildAppointmentSummary() {
    final fee = _appointmentType == AppointmentType.online
        ? widget.doctor.fees.online
        : widget.doctor.fees.inPerson;

    return AppointmentSummary(
      doctor: widget.doctor,
      date: _selectedDate!,
      time: _selectedTime!,
      type: _appointmentType,
      fee: fee,
      symptoms: _symptomsController.text,
    );
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Fee: ${widget.doctor.fees.currency} '
                '${_appointmentType == AppointmentType.online ? widget.doctor.fees.online : widget.doctor.fees.inPerson}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ElevatedButton(
              onPressed: _canBook() ? _bookAppointment : null,
              child: const Text('Book Appointment'),
            ),
          ],
        ),
      ),
    );
  }

  bool _canBook() {
    return _selectedDate != null &&
        _selectedTime != null &&
        _symptomsController.text.isNotEmpty;
  }

  void _bookAppointment() async {
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Appointment'),
        content: Text(
          'Would you like to book an appointment with Dr. ${widget.doctor.name} '
          'on ${_selectedDate!.toString().split(' ')[0]} at $_selectedTime?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirm ?? false) {
      // Show loading indicator
      _showLoadingDialog();

      try {
        // Create appointment
        final appointment = Appointment(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          doctorId: widget.doctor.id,
          patientId: 'current_user_id', // Replace with actual user ID
          dateTime: DateTime.parse(
            '${_selectedDate!.toString().split(' ')[0]} $_selectedTime',
          ),
          duration: const Duration(minutes: 30),
          type: _appointmentType,
          status: AppointmentStatus.scheduled,
          fee: _appointmentType == AppointmentType.online
              ? widget.doctor.fees.online
              : widget.doctor.fees.inPerson,
          currency: widget.doctor.fees.currency,
          symptoms: [_symptomsController.text],
          isFollowUp: false,
        );

        // Save appointment to database
        await _saveAppointment(appointment);

        // Hide loading indicator
        Navigator.pop(context);

        // Show success message and navigate back
        _showSuccessDialog();
      } catch (e) {
        // Hide loading indicator
        Navigator.pop(context);

        // Show error message
        _showErrorDialog(e.toString());
      }
    }
  }

  Future<void> _saveAppointment(Appointment appointment) async {
    // Implement the actual save logic
    await Future.delayed(const Duration(seconds: 2)); // Simulated delay
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Your appointment has been booked successfully!'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text('Failed to book appointment: $error'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}