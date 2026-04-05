import 'package:flutter/material.dart';
import 'package:check_2_check/models/paycheck.dart';
import 'package:check_2_check/models/person.dart';
import 'package:check_2_check/services/firestore_service.dart';
import 'package:check_2_check/utils/feature_flags.dart';

Future<void> showEditPaycheckDialog(
  BuildContext context,
  Paycheck paycheck,
  List<Person> people,
  FirestoreService firestore,
) async {
  final amountController = TextEditingController(text: paycheck.amount.toStringAsFixed(2));
  DateTime selectedDate = paycheck.date;
  final selectedPeopleIds = <String>{...paycheck.assignedPeopleIds};
  bool isRecurring = paycheck.isRecurring;
  String? recurrencePattern = paycheck.recurrencePattern;
  int? recurrenceDayOfWeek = paycheck.recurrenceDayOfWeek;
  int? recurrenceDayOfMonth = paycheck.recurrenceDayOfMonth;
  DateTime? recurrenceEndDate = paycheck.recurrenceEndDate;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setModalState) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 16, right: 16, top: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Edit Paycheck', style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextField(controller: amountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount', border: OutlineInputBorder(), prefixText: '\$ ')),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showDatePicker(context: ctx, initialDate: selectedDate, firstDate: DateTime(2020), lastDate: DateTime(2030));
                  if (picked != null) setModalState(() => selectedDate = picked);
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(formatDate(selectedDate)),
              ),
              const SizedBox(height: 16),
              SwitchListTile(title: const Text('Recurring'), value: isRecurring, onChanged: FeatureFlags.enableRecurringTransactions ? (v) => setModalState(() { isRecurring = v; if (!v) { recurrencePattern = null; recurrenceDayOfWeek = null; recurrenceDayOfMonth = null; recurrenceEndDate = null; } }) : null),
              if (isRecurring && FeatureFlags.enableRecurringTransactions) ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(value: recurrencePattern, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Select frequency'), items: const [DropdownMenuItem(value: 'weekly', child: Text('Weekly')), DropdownMenuItem(value: 'biweekly', child: Text('Bi-weekly')), DropdownMenuItem(value: 'monthly', child: Text('Monthly')), DropdownMenuItem(value: 'quarterly', child: Text('Quarterly')), DropdownMenuItem(value: 'annually', child: Text('Annually'))], onChanged: (v) => setModalState(() => recurrencePattern = v)),
              ],
              if (people.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text('Assign People', style: Theme.of(ctx).textTheme.labelLarge),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: people.map((person) => FilterChip(label: Text(person.displayName ?? person.fullName), selected: selectedPeopleIds.contains(person.id), onSelected: (selected) => setModalState(() { if (selected) selectedPeopleIds.add(person.id); else selectedPeopleIds.remove(person.id); }))).toList()),
              ],
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () async {
                  if (amountController.text.isNotEmpty) {
                    await firestore.updatePaycheck(paycheck.copyWith(amount: double.tryParse(amountController.text) ?? 0, date: selectedDate, assignedPeopleIds: selectedPeopleIds.toList(), isRecurring: isRecurring, recurrencePattern: isRecurring ? recurrencePattern : null, recurrenceDayOfWeek: isRecurring ? recurrenceDayOfWeek : null, recurrenceDayOfMonth: isRecurring ? recurrenceDayOfMonth : null, recurrenceEndDate: isRecurring ? recurrenceEndDate : null));
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('Save'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    ),
  );
}

String formatDate(DateTime date) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}