
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'notification_service.dart';

class AddReminderPage extends StatefulWidget {
  const AddReminderPage({super.key});

  @override
  State<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController petController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // 🔹 Save Reminder to Firebase
  Future<void> saveReminder() async {
    if (titleController.text.isEmpty ||
        petController.text.isEmpty ||
        dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("You must be signed in to add a reminder"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      String userId = user.uid;
      DatabaseReference reminderRef = _database.child("reminders").child(userId).push();

      await reminderRef.set({
        "reminderId": reminderRef.key,
        "title": titleController.text.trim(),
        "petName": petController.text.trim(),
        "date": dateController.text.trim(),
        "createdAt": DateTime.now().millisecondsSinceEpoch,
      });

      // Show notification
      NotificationService.showNotification(
        "Pet Reminder Added",
        titleController.text,
      );

      // Try to parse the provided date and schedule repeating notifications
      try {
        DateTime? start = DateTime.tryParse(dateController.text.trim());
        if (start != null) {
          final int schedId = await NotificationService.scheduleRepeatingFrom(
            start,
            titleController.text.trim(),
            "Reminder for ${petController.text.trim()}",
            intervalSeconds: 4,
          );
          print('[AddReminderPage] scheduled repeating notification id=$schedId start=${start.toIso8601String()}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Notification scheduled (every 4s), id=$schedId"),
              backgroundColor: Colors.blue,
            ),
          );
        } else {
          // If parsing failed, inform user to use ISO format
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Could not parse date — please pick a date/time using the picker"),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } catch (e) {
        // ignore scheduling errors but inform user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to schedule notification: $e"),
            backgroundColor: Colors.orange,
          ),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Reminder saved successfully 🐾"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Firebase error saving reminder: ${e.message}"),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error saving reminder: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Reminder")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Reminder Title"),
            ),
            TextField(
              controller: petController,
              decoration: const InputDecoration(labelText: "Pet Name"),
            ),
            TextField(
                controller: dateController,
                readOnly: true,
                onTap: _pickDateTime,
                decoration: const InputDecoration(
                  labelText: "Date (tap to pick)",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveReminder,
              child: const Text("Save Reminder"),
            ),
          ],
        ),
      ),
    );
  }

  // Show date picker then time picker and store ISO string in controller
  Future<void> _pickDateTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    final DateTime selected = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    // Store ISO8601 string so DateTime.tryParse succeeds later
    dateController.text = selected.toIso8601String();
    setState(() {});
  }
}
