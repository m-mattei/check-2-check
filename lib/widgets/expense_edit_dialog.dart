import 'package:flutter/material.dart';
import 'package:check_2_check/models/expense.dart';
import 'package:check_2_check/models/category.dart' as model;
import 'package:check_2_check/models/paycheck.dart';
import 'package:check_2_check/models/person.dart';
import 'package:check_2_check/services/firestore_service.dart';
import 'package:check_2_check/utils/feature_flags.dart';

Future<void> showEditExpenseDialog(
  BuildContext context,
  Expense expense,
  List<Person> people,
  List<model.Category> categories,
  List<Paycheck> paychecks,
  FirestoreService firestore,
) async {
  final nameController = TextEditingController(text: expense.name);
  final amountController = TextEditingController(
    text: expense.amount.toStringAsFixed(2),
  );
  final accountController = TextEditingController(text: expense.account);
  DateTime selectedDate = expense.date;
  String selectedCategoryId = expense.categoryId;
  String selectedPaycheckId = expense.paycheckId ?? '';
  final selectedPeopleIds = <String>{...expense.assignedPeopleIds};
  bool isRecurring = expense.isRecurring;
  String? recurrencePattern = expense.recurrencePattern;
  int? recurrenceDayOfWeek = expense.recurrenceDayOfWeek;
  int? recurrenceDayOfMonth = expense.recurrenceDayOfMonth;
  DateTime? recurrenceEndDate = expense.recurrenceEndDate;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setModalState) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Edit Expense', style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Expense Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: accountController,
                decoration: const InputDecoration(
                  labelText: 'Account',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: ctx,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null)
                    setModalState(() => selectedDate = picked);
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(formatDate(selectedDate)),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Recurring'),
                value: isRecurring,
                onChanged: FeatureFlags.enableRecurringTransactions
                    ? (v) => setModalState(() {
                        isRecurring = v;
                        if (!v) {
                          recurrencePattern = null;
                          recurrenceDayOfWeek = null;
                          recurrenceDayOfMonth = null;
                          recurrenceEndDate = null;
                        }
                      })
                    : null,
              ),
              if (isRecurring && FeatureFlags.enableRecurringTransactions) ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: recurrencePattern,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Select frequency',
                  ),
                  items: const [
                    DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                    DropdownMenuItem(
                      value: 'biweekly',
                      child: Text('Bi-weekly'),
                    ),
                    DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                    DropdownMenuItem(
                      value: 'quarterly',
                      child: Text('Quarterly'),
                    ),
                    DropdownMenuItem(
                      value: 'annually',
                      child: Text('Annually'),
                    ),
                  ],
                  onChanged: (v) => setModalState(() => recurrencePattern = v),
                ),
              ],
              if (categories.isNotEmpty) ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategoryId.isEmpty ? null : selectedCategoryId,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Select a category',
                  ),
                  items: categories
                      .map(
                        (c) =>
                            DropdownMenuItem(value: c.id, child: Text(c.name)),
                      )
                      .toList(),
                  onChanged: (v) =>
                      setModalState(() => selectedCategoryId = v ?? ''),
                ),
              ],
              if (paychecks.isNotEmpty &&
                  FeatureFlags.enablePaycheckExpensePlanning) ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<String?>(
                  value: selectedPaycheckId.isEmpty ? null : selectedPaycheckId,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Select a paycheck',
                  ),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('None')),
                    ...paychecks.map(
                      (p) => DropdownMenuItem(
                        value: p.id,
                        child: Text(
                          '\$${p.amount.toStringAsFixed(2)} - ${formatDate(p.date)}',
                        ),
                      ),
                    ),
                  ],
                  onChanged: (v) =>
                      setModalState(() => selectedPaycheckId = v ?? ''),
                ),
              ],
              if (people.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Assign People',
                  style: Theme.of(ctx).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: people
                      .map(
                        (person) => FilterChip(
                          label: Text(person.displayName ?? person.fullName),
                          selected: selectedPeopleIds.contains(person.id),
                          onSelected: (selected) => setModalState(() {
                            if (selected)
                              selectedPeopleIds.add(person.id);
                            else
                              selectedPeopleIds.remove(person.id);
                          }),
                        ),
                      )
                      .toList(),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () async {
                  if (nameController.text.trim().isNotEmpty &&
                      amountController.text.isNotEmpty) {
                    await firestore.updateExpense(
                      expense.copyWith(
                        name: nameController.text.trim(),
                        amount: double.tryParse(amountController.text) ?? 0,
                        categoryId: selectedCategoryId,
                        account: accountController.text.trim(),
                        date: selectedDate,
                        assignedPeopleIds: selectedPeopleIds.toList(),
                        isRecurring: isRecurring,
                        recurrencePattern: isRecurring
                            ? recurrencePattern
                            : null,
                        recurrenceDayOfWeek: isRecurring
                            ? recurrenceDayOfWeek
                            : null,
                        recurrenceDayOfMonth: isRecurring
                            ? recurrenceDayOfMonth
                            : null,
                        recurrenceEndDate: isRecurring
                            ? recurrenceEndDate
                            : null,
                        paycheckId: selectedPaycheckId.isNotEmpty
                            ? selectedPaycheckId
                            : null,
                      ),
                    );
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
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}
