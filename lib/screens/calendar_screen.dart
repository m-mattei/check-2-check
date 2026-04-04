import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:check_2_check/services/firestore_service.dart';
import 'package:check_2_check/models/paycheck.dart';
import 'package:check_2_check/models/expense.dart';
import 'package:check_2_check/models/person.dart';
import 'package:check_2_check/utils/feature_flags.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final _firestore = FirestoreService();

  Map<DateTime, List<Paycheck>> _paycheckEvents = {};
  Map<DateTime, List<Expense>> _expenseEvents = {};
  List<Person> _people = [];
  bool _isInitialized = false;

  List<Paycheck> _generateRecurringPaycheckInstances(Paycheck paycheck) {
    if (!paycheck.isRecurring || paycheck.recurrencePattern == null) {
      return [paycheck];
    }
    final instances = <Paycheck>[];
    final startDate = paycheck.date;
    final endDate =
        paycheck.recurrenceEndDate ?? startDate.add(const Duration(days: 365));
    DateTime currentDate = startDate;

    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      final instance = paycheck.copyWith(
        id: '${paycheck.id}_${currentDate.millisecondsSinceEpoch}',
        date: currentDate,
      );
      instances.add(instance);
      currentDate = _nextDate(
        currentDate,
        paycheck.recurrencePattern!,
        paycheck.recurrenceDayOfWeek,
        paycheck.recurrenceDayOfMonth,
      );
      if (instances.length > 100) break;
    }
    return instances;
  }

  List<Expense> _generateRecurringExpenseInstances(Expense expense) {
    if (!expense.isRecurring || expense.recurrencePattern == null) {
      return [expense];
    }
    final instances = <Expense>[];
    final startDate = expense.date;
    final endDate =
        expense.recurrenceEndDate ?? startDate.add(const Duration(days: 365));
    DateTime currentDate = startDate;

    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      final instance = expense.copyWith(
        id: '${expense.id}_${currentDate.millisecondsSinceEpoch}',
        date: currentDate,
      );
      instances.add(instance);
      currentDate = _nextDate(
        currentDate,
        expense.recurrencePattern!,
        expense.recurrenceDayOfWeek,
        expense.recurrenceDayOfMonth,
      );
      if (instances.length > 100) break;
    }
    return instances;
  }

  DateTime _nextDate(
    DateTime current,
    String pattern,
    int? dayOfWeek,
    int? dayOfMonth,
  ) {
    switch (pattern) {
      case 'weekly':
        return current.add(const Duration(days: 7));
      case 'biweekly':
        return current.add(const Duration(days: 14));
      case 'monthly':
        if (dayOfMonth != null) {
          return DateTime(current.year, current.month + 1, dayOfMonth);
        }
        return DateTime(current.year, current.month + 1, current.day);
      case 'quarterly':
        if (dayOfMonth != null) {
          return DateTime(current.year, current.month + 3, dayOfMonth);
        }
        return DateTime(current.year, current.month + 3, current.day);
      case 'annually':
        return DateTime(
          current.year + 1,
          current.month,
          dayOfMonth ?? current.day,
        );
      default:
        return current.add(const Duration(days: 7));
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      await _firestore.getOrCreateHousehold();
    } catch (e) {
      debugPrint('Calendar: household init error: $e');
    }
    if (!mounted) return;

    _firestore.streamPaychecks().listen((paychecks) {
      debugPrint('Calendar: received ${paychecks.length} paychecks');
      final events = <DateTime, List<Paycheck>>{};
      for (final paycheck in paychecks) {
        final recurringInstances = _generateRecurringPaycheckInstances(
          paycheck,
        );
        for (final instance in recurringInstances) {
          final day = DateTime.utc(
            instance.date.year,
            instance.date.month,
            instance.date.day,
          );
          debugPrint(
            'Calendar: paycheck on ${day.toIso8601String()} amount=${instance.amount}',
          );
          events.putIfAbsent(day, () => []).add(instance);
        }
      }
      if (mounted) {
        setState(() => _paycheckEvents = events);
      }
    });
    _firestore.streamExpenses().listen((expenses) {
      debugPrint('Calendar: received ${expenses.length} expenses');
      final events = <DateTime, List<Expense>>{};
      for (final expense in expenses) {
        final recurringInstances = _generateRecurringExpenseInstances(expense);
        for (final instance in recurringInstances) {
          final day = DateTime.utc(
            instance.date.year,
            instance.date.month,
            instance.date.day,
          );
          debugPrint(
            'Calendar: expense on ${day.toIso8601String()} amount=${instance.amount}',
          );
          events.putIfAbsent(day, () => []).add(instance);
        }
      }
      if (mounted) {
        setState(() => _expenseEvents = events);
      }
    });
    _firestore.streamPeople().listen((people) {
      if (mounted) {
        setState(() => _people = people);
      }
    });

    setState(() => _isInitialized = true);
  }

  List<dynamic> _eventsForDay(DateTime day) {
    final key = DateTime.utc(day.year, day.month, day.day);
    final paychecks = _paycheckEvents[key] ?? [];
    final expenses = FeatureFlags.enableCalendarExpenses
        ? (_expenseEvents[key] ?? [])
        : [];
    final combined = [...paychecks, ...expenses];
    debugPrint(
      'Calendar: events for ${key.toIso8601String()} = ${combined.length} (paychecks: ${paychecks.length}, expenses: ${expenses.length})',
    );
    return combined;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Budget Calendar'), centerTitle: true),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() => _calendarFormat = format);
              }
            },
            onPageChanged: (focusedDay) => _focusedDay = focusedDay,
            eventLoader: _eventsForDay,
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (events.isEmpty) return const SizedBox.shrink();
                return Positioned(
                  bottom: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: events.map((e) {
                      final isPaycheck = e is Paycheck;
                      return Container(
                        width: 7,
                        height: 7,
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        decoration: BoxDecoration(
                          color: isPaycheck
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.error,
                          shape: BoxShape.circle,
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
            ),
          ),
          Expanded(
            child: _selectedDay != null
                ? _buildDayDetail(_selectedDay!)
                : const Center(
                    child: Text(
                      'Select a day to view paychecks',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayDetail(DateTime day) {
    final events = _eventsForDay(day);
    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatDate(day),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'No paychecks or expenses on this day',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    final paychecks = events.whereType<Paycheck>().toList();
    final expenses = events.whereType<Expense>().toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (paychecks.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Paychecks',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          ...paychecks.map((paycheck) => _buildPaycheckCard(paycheck)),
          if (expenses.isNotEmpty) const SizedBox(height: 16),
        ],
        if (expenses.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Expenses',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          ...expenses.map((expense) => _buildExpenseCard(expense)),
        ],
      ],
    );
  }

  Widget _buildPaycheckCard(Paycheck paycheck) {
    final assignedPeople = _people
        .where((p) => paycheck.assignedPeopleIds.contains(p.id))
        .toList();
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.payment,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          '\$${paycheck.amount.toStringAsFixed(2)}',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(_formatDate(paycheck.date)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Linked People',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                if (assignedPeople.isEmpty)
                  const Text(
                    'No people linked',
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: assignedPeople.map((person) {
                      final color = person.color != null
                          ? Color(int.parse(person.color!))
                          : Theme.of(context).colorScheme.secondaryContainer;
                      return Chip(
                        avatar: CircleAvatar(
                          backgroundColor: color,
                          child: Text(
                            person.firstName[0].toUpperCase(),
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSecondaryContainer,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        label: Text(person.displayName ?? person.fullName),
                        backgroundColor: color.withValues(alpha: 0.3),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseCard(Expense expense) {
    final assignedPeople = _people
        .where((p) => expense.assignedPeopleIds.contains(p.id))
        .toList();
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          child: Icon(
            Icons.shopping_cart,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
        ),
        title: Text(
          expense.name,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '\$${expense.amount.toStringAsFixed(2)} - ${_formatDate(expense.date)}',
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Linked People',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                if (assignedPeople.isEmpty)
                  const Text(
                    'No people linked',
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: assignedPeople.map((person) {
                      final color = person.color != null
                          ? Color(int.parse(person.color!))
                          : Theme.of(context).colorScheme.secondaryContainer;
                      return Chip(
                        avatar: CircleAvatar(
                          backgroundColor: color,
                          child: Text(
                            person.firstName[0].toUpperCase(),
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSecondaryContainer,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        label: Text(person.displayName ?? person.fullName),
                        backgroundColor: color.withValues(alpha: 0.3),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
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
}
