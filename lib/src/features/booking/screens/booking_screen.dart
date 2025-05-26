import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homestay_app/src/common/widgets/build_button.dart';
import 'package:homestay_app/src/features/homestay/domain/models/homestay_model.dart';
import 'package:homestay_app/src/themes/extensions.dart';
import 'package:homestay_app/src/features/booking/screens/booking_confirm_screen.dart';
import 'package:homestay_app/src/features/booking/domain/model/booking_model.dart';

class BookingScreen extends StatefulWidget {
  final String homestayId;
  final int numberOfGuests;
  final HomestayModel homestayDetails;

  const BookingScreen({
    super.key,
    required this.homestayId,
    required this.numberOfGuests,
    required this.homestayDetails,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nightsController = TextEditingController();
  final _notesController = TextEditingController();
  final _dateController = TextEditingController(); // Added date controller
  DateTime? _selectedDate; // Added to store the selected date

  @override
  void initState() {
    super.initState();
    _nightsController.text = '1'; // Default to 1 night
    _selectedDate = DateTime.now(); // Default to current date
    _dateController.text =
        "${_selectedDate!.toLocal()}".split(
          ' ',
        )[0]; // Format date as YYYY-MM-DD
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _nightsController.dispose();
    _notesController.dispose();
    _dateController.dispose(); // Dispose date controller
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(), // Users can't select past dates
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text =
            "${_selectedDate!.toLocal()}".split(' ')[0]; // Format date
      });
    }
  }

  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      // Assuming a fixed price per night for now, you might fetch this from homestay details
      const double pricePerNight = 50.0;
      final int nights = int.tryParse(_nightsController.text) ?? 1;
      final int guests = widget.numberOfGuests;
      final double totalPrice =
          widget.homestayDetails.pricePerNight * nights * guests;
      DateTime checkInDate;
      try {
        checkInDate = DateTime.parse(_dateController.text);
      } catch (e) {
        // Handle invalid date format, perhaps show an error or default
        checkInDate = DateTime.now(); // Fallback, ideally validate earlier
      }

      final booking = BookingModel(
        homestayId: widget.homestayId,
        userName: _nameController.text,
        userPhone: _phoneController.text,
        checkInDate: checkInDate,
        numberOfNights: nights,
        numberOfGuests: guests,
        pricePerNight: pricePerNight,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        totalPrice: totalPrice,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingConfirmScreen(booking: booking),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Your Stay'),
        elevation: 1,
        backgroundColor: context.theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: <Widget>[
              Text(
                'Confirm your details and book',
                style: context.theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 10,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  // Add more sophisticated phone validation if needed
                  return null;
                },
              ),
              TextFormField(
                readOnly: true,
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Check-in Date',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
                onTap: () {
                  _selectDate(context); // Show date picker on tap
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a check-in date';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: widget.numberOfGuests.toString(),
                decoration: const InputDecoration(
                  labelText: 'Total Guests',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.group_outlined),
                ),
                readOnly: true, // Pre-filled from detail screen
              ),
              TextFormField(
                controller: _nightsController,
                decoration: const InputDecoration(
                  labelText: 'Total Nights Stay',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.night_shelter_outlined),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of nights';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid number of nights';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Additional Notes (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note_alt_outlined),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              BuildButton(
                onPressed: _submitBooking,
                buttonWidget: const Text('Confirm and Proceed to Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
