import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:check_2_check/utils/feature_flags.dart';
import 'package:check_2_check/services/firestore_service.dart';
import 'package:check_2_check/models/category.dart' as model;
import 'package:check_2_check/models/paycheck.dart';
import 'package:check_2_check/models/expense.dart';

enum _PlanView { all, paychecks, expenses, categories }

enum _ItemType { paycheck, expense, category }

class _PlannerItem {
  final _ItemType type;
  final DateTime date;
  final dynamic data;
  _PlannerItem({required this.type, required this.date, required this.data});
}

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  _PlanView _currentView = _PlanView.all;
  bool _isPlannerMode = false;
  final _firestore = FirestoreService();
  bool _isLoading = true;
  String? _householdId;

  bool get _isIOS => !kIsWeb && Platform.isIOS;

  @override
  void initState() {
    super.initState();
    _initFirestore();
  }

  Future<void> _initFirestore() async {
    try {
      _householdId = await _firestore.getOrCreateHousehold();
    } catch (e) {
      debugPrint('Firestore init error: $e');
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!FeatureFlags.enablePlanPage) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Plan page is disabled.\nEnable it in Developer Options.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_isPlannerMode) {
      return _buildPlannerMode();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan'),
        centerTitle: true,
        actions: [
          if (_isIOS && FeatureFlags.enableApplePencilPlanner)
            IconButton(
              icon: const Icon(Icons.draw),
              onPressed: () {
                setState(() {
                  _isPlannerMode = true;
                });
              },
              tooltip: 'Planner Mode',
            ),
          if (_currentView == _PlanView.all ||
              _currentView == _PlanView.categories)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddOptions(context, _currentView),
              tooltip: 'Add',
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SegmentedButton<_PlanView>(
              segments: [
                ButtonSegment<_PlanView>(
                  value: _PlanView.all,
                  label: const Text('All'),
                  icon: const Icon(Icons.list),
                ),
                ButtonSegment<_PlanView>(
                  value: _PlanView.paychecks,
                  label: const Text('Paychecks'),
                  icon: const Icon(Icons.payment),
                ),
                const ButtonSegment<_PlanView>(
                  value: _PlanView.expenses,
                  label: Text('Expenses'),
                  icon: Icon(Icons.shopping_cart),
                ),
                const ButtonSegment<_PlanView>(
                  value: _PlanView.categories,
                  label: Text('Categories'),
                  icon: Icon(Icons.category),
                ),
              ],
              selected: {_currentView},
              onSelectionChanged: (selected) {
                setState(() {
                  _currentView = selected.first;
                });
              },
            ),
          ),
          Expanded(
            child: _currentView == _PlanView.all
                ? _buildConsolidatedView()
                : _currentView == _PlanView.paychecks
                ? _buildPaycheckView()
                : _currentView == _PlanView.expenses
                ? _buildExpenseView()
                : _buildCategoryView(),
          ),
        ],
      ),
    );
  }

  void _showAddOptions(BuildContext context, _PlanView currentView) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (currentView == _PlanView.all ||
                currentView == _PlanView.paychecks)
              ListTile(
                leading: const Icon(Icons.payment),
                title: const Text('Add Paycheck'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showAddPaycheckDialog();
                },
              ),
            if (currentView == _PlanView.all ||
                currentView == _PlanView.expenses)
              ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: const Text('Add Expense'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showAddExpenseDialog();
                },
              ),
            if (currentView == _PlanView.all ||
                currentView == _PlanView.categories)
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text('Add Category'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showAddCategoryDialog();
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsolidatedView() {
    if (_householdId == null) {
      return const Center(child: Text('Not connected to Firestore'));
    }

    return StreamBuilder<List<Paycheck>>(
      stream: _firestore.streamPaychecks(),
      builder: (context, paycheckSnap) {
        return StreamBuilder<List<Expense>>(
          stream: _firestore.streamExpenses(),
          builder: (context, expenseSnap) {
            return StreamBuilder<List<model.Category>>(
              stream: _firestore.streamCategories(),
              builder: (context, catSnap) {
                final paychecks = paycheckSnap.data ?? [];
                final expenses = expenseSnap.data ?? [];
                final categories = catSnap.data ?? [];

                final items = <_PlannerItem>[];
                items.addAll(
                  paychecks.map(
                    (p) => _PlannerItem(
                      type: _ItemType.paycheck,
                      date: p.date,
                      data: p,
                    ),
                  ),
                );
                items.addAll(
                  expenses.map(
                    (e) => _PlannerItem(
                      type: _ItemType.expense,
                      date: e.date,
                      data: e,
                    ),
                  ),
                );
                items.addAll(
                  categories.map(
                    (c) => _PlannerItem(
                      type: _ItemType.category,
                      date: DateTime.now(),
                      data: c,
                    ),
                  ),
                );
                items.sort((a, b) => a.date.compareTo(b.date));

                if (items.isEmpty) {
                  return const Center(
                    child: Text(
                      'Your planner is empty.\nTap + to add items.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: items.length,
                  itemBuilder: (context, index) => _buildItemCard(items[index]),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildItemCard(_PlannerItem item) {
    switch (item.type) {
      case _ItemType.paycheck:
        return _buildPaycheckCard(item.data as Paycheck);
      case _ItemType.expense:
        return _buildExpenseCard(item.data as Expense);
      case _ItemType.category:
        return _buildCategoryCard(item.data as model.Category);
    }
  }

  Widget _buildPaycheckCard(Paycheck p) {
    final now = DateTime.now();
    final isPast = p.date.isBefore(now);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isPast
              ? Theme.of(context).colorScheme.surfaceContainerHighest
              : Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            isPast ? Icons.check_circle : Icons.payment,
            color: isPast
                ? Theme.of(context).colorScheme.onSurfaceVariant
                : Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text('\$${p.amount.toStringAsFixed(2)}'),
        subtitle: Text(_formatDate(p.date)),
      ),
    );
  }

  Widget _buildExpenseCard(Expense e) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          child: Icon(
            Icons.shopping_cart,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
        ),
        title: Text(e.name),
        subtitle: Text('\$${e.amount.toStringAsFixed(2)}'),
      ),
    );
  }

  Widget _buildCategoryCard(model.Category c) {
    final progress = c.planned > 0
        ? (c.spent / c.planned).clamp(0.0, 1.0)
        : 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          child: Icon(
            Icons.category,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
        title: Text(c.name),
        subtitle: LinearProgressIndicator(value: progress),
        trailing: Text(
          '\$${c.spent.toStringAsFixed(0)}/\$${c.planned.toStringAsFixed(0)}',
        ),
      ),
    );
  }

  Widget _buildPaycheckView() {
    if (_householdId == null) {
      return const Center(child: Text('Not connected to Firestore'));
    }

    return StreamBuilder<List<Paycheck>>(
      stream: _firestore.streamPaychecks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final paychecks = snapshot.data ?? [];

        if (paychecks.isEmpty) {
          return const Center(
            child: Text(
              'No paychecks yet.\nAdd one to get started!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: paychecks.length,
          itemBuilder: (context, index) {
            final paycheck = paychecks[index];
            final isPast = paycheck.date.isBefore(DateTime.now());
            return Dismissible(
              key: ValueKey(paycheck.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                color: Theme.of(context).colorScheme.error,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: (direction) => _confirmDeletePaycheck(paycheck),
              onDismissed: (_) => _deletePaycheck(paycheck),
              child: Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isPast
                        ? Theme.of(context).colorScheme.surfaceContainerHighest
                        : Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(
                      isPast ? Icons.check_circle : Icons.upcoming,
                      color: isPast
                          ? Theme.of(context).colorScheme.onSurfaceVariant
                          : Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  title: Text(
                    '\$${paycheck.amount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(_formatDate(paycheck.date)),
                  trailing: Text(
                    _formatDate(paycheck.date),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCategoryView() {
    if (_householdId == null) {
      return const Center(child: Text('Not connected to Firestore'));
    }

    return StreamBuilder<List<model.Category>>(
      stream: _firestore.streamCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final categories = snapshot.data ?? [];

        if (categories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'No categories yet.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: _showAddCategoryDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Category'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final progress = category.planned > 0
                ? (category.spent / category.planned).clamp(0.0, 1.0)
                : 0.0;
            return Dismissible(
              key: ValueKey(category.id),
              direction: category.isCustom
                  ? DismissDirection.endToStart
                  : DismissDirection.none,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                color: Theme.of(context).colorScheme.error,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: (direction) => _confirmDeleteCategory(category),
              onDismissed: (_) => _deleteCategory(category),
              child: Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(category.icon),
                  title: Row(
                    children: [
                      Text(category.name),
                      if (category.isCustom) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Custom',
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: progress,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${category.spent.toStringAsFixed(0)} / \$${category.planned.toStringAsFixed(0)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            category.remaining >= 0
                                ? '\$${category.remaining.toStringAsFixed(0)} left'
                                : '\$${category.remaining.abs().toStringAsFixed(0)} over',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: category.remaining >= 0
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.error,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: category.isCustom
                      ? IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showEditCategoryDialog(category),
                        )
                      : null,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showAddCategoryDialog() async {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    IconData selectedIcon = Icons.label;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Add Category',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Planned Amount',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
              ),
              const SizedBox(height: 16),
              Text('Icon', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    [
                      Icons.home,
                      Icons.shopping_cart,
                      Icons.bolt,
                      Icons.local_gas_station,
                      Icons.savings,
                      Icons.shield,
                      Icons.movie,
                      Icons.restaurant,
                      Icons.local_hospital,
                      Icons.school,
                      Icons.fitness_center,
                      Icons.pets,
                      Icons.car_repair,
                      Icons.phone_android,
                      Icons.travel_explore,
                      Icons.label,
                    ].map((icon) {
                      final isSelected = icon == selectedIcon;
                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            selectedIcon = icon;
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                            border: isSelected
                                ? Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    width: 2,
                                  )
                                : null,
                          ),
                          child: Icon(icon, size: 20),
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () async {
                  if (nameController.text.trim().isNotEmpty &&
                      amountController.text.isNotEmpty) {
                    await _firestore.addCategory(
                      model.Category(
                        id: '',
                        name: nameController.text.trim(),
                        icon: selectedIcon,
                        planned: double.tryParse(amountController.text) ?? 0,
                        spent: 0,
                        isCustom: true,
                      ),
                    );
                    if (mounted) Navigator.pop(context);
                  }
                },
                child: const Text('Add'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showEditCategoryDialog(model.Category category) async {
    final nameController = TextEditingController(text: category.name);
    final amountController = TextEditingController(
      text: category.planned.toStringAsFixed(0),
    );
    IconData selectedIcon = category.icon;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Edit Category',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Planned Amount',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
              ),
              const SizedBox(height: 16),
              Text('Icon', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    [
                      Icons.home,
                      Icons.shopping_cart,
                      Icons.bolt,
                      Icons.local_gas_station,
                      Icons.savings,
                      Icons.shield,
                      Icons.movie,
                      Icons.restaurant,
                      Icons.local_hospital,
                      Icons.school,
                      Icons.fitness_center,
                      Icons.pets,
                      Icons.car_repair,
                      Icons.phone_android,
                      Icons.travel_explore,
                      Icons.label,
                    ].map((icon) {
                      final isSelected = icon == selectedIcon;
                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            selectedIcon = icon;
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                            border: isSelected
                                ? Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    width: 2,
                                  )
                                : null,
                          ),
                          child: Icon(icon, size: 20),
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () async {
                  if (nameController.text.trim().isNotEmpty &&
                      amountController.text.isNotEmpty) {
                    await _firestore.updateCategory(
                      category.copyWith(
                        name: nameController.text.trim(),
                        icon: selectedIcon,
                        planned: double.tryParse(amountController.text),
                      ),
                    );
                    if (mounted) Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _confirmDeleteCategory(model.Category category) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete "${category.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCategory(model.Category category) async {
    await _firestore.deleteCategory(category.id);
  }

  Future<void> _showAddPaycheckDialog() async {
    final amountController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    final selectedPeopleIds = <String>{};
    final people = await _firestore.streamPeople().first;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Add Paycheck',
                  style: Theme.of(context).textTheme.titleLarge,
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
                Text('Date', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setModalState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: Text(_formatDate(selectedDate)),
                ),
                if (people.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Assign People',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: people.map((person) {
                      final isSelected = selectedPeopleIds.contains(person.id);
                      return FilterChip(
                        label: Text(person.displayName ?? person.fullName),
                        selected: isSelected,
                        onSelected: (selected) {
                          setModalState(() {
                            if (selected) {
                              selectedPeopleIds.add(person.id);
                            } else {
                              selectedPeopleIds.remove(person.id);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () async {
                    if (amountController.text.isNotEmpty) {
                      await _firestore.addPaycheck(
                        Paycheck(
                          id: '',
                          amount: double.tryParse(amountController.text) ?? 0,
                          date: selectedDate,
                          assignedPeopleIds: selectedPeopleIds.toList(),
                        ),
                      );
                      if (mounted) Navigator.pop(context);
                    }
                  },
                  child: const Text('Add'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _confirmDeletePaycheck(Paycheck paycheck) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Paycheck'),
        content: Text(
          'Are you sure you want to delete the paycheck of \$${paycheck.amount.toStringAsFixed(2)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deletePaycheck(Paycheck paycheck) async {
    await _firestore.deletePaycheck(paycheck.id);
  }

  Widget _buildExpenseView() {
    if (_householdId == null) {
      return const Center(child: Text('Not connected to Firestore'));
    }

    return StreamBuilder<List<Expense>>(
      stream: _firestore.streamExpenses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final expenses = snapshot.data ?? [];

        if (expenses.isEmpty) {
          return const Center(
            child: Text(
              'No expenses yet.\nAdd one to get started!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            final expense = expenses[index];
            return Dismissible(
              key: ValueKey(expense.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                color: Theme.of(context).colorScheme.error,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: (direction) => _confirmDeleteExpense(expense),
              onDismissed: (_) => _deleteExpense(expense),
              child: Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.errorContainer,
                    child: Icon(
                      Icons.shopping_cart,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                  title: Text(
                    expense.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '\$${expense.amount.toStringAsFixed(2)} - ${_formatDate(expense.date)}',
                  ),
                  trailing: Text(
                    '\$${expense.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showAddExpenseDialog() async {
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    final accountController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    String selectedCategoryId = '';
    final selectedPeopleIds = <String>{};
    final people = await _firestore.streamPeople().first;
    final categories = await _firestore.streamCategories().first;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Add Expense',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
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
                    hintText: 'e.g. Checking, Credit Card',
                  ),
                ),
                const SizedBox(height: 16),
                Text('Date', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setModalState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: Text(_formatDate(selectedDate)),
                ),
                if (categories.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Category',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedCategoryId.isEmpty
                        ? null
                        : selectedCategoryId,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Select a category',
                    ),
                    items: categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setModalState(() {
                        selectedCategoryId = value ?? '';
                      });
                    },
                  ),
                ],
                if (people.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Assign People',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: people.map((person) {
                      final isSelected = selectedPeopleIds.contains(person.id);
                      return FilterChip(
                        label: Text(person.displayName ?? person.fullName),
                        selected: isSelected,
                        onSelected: (selected) {
                          setModalState(() {
                            if (selected) {
                              selectedPeopleIds.add(person.id);
                            } else {
                              selectedPeopleIds.remove(person.id);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () async {
                    if (nameController.text.trim().isNotEmpty &&
                        amountController.text.isNotEmpty) {
                      await _firestore.addExpense(
                        Expense(
                          id: '',
                          name: nameController.text.trim(),
                          amount: double.tryParse(amountController.text) ?? 0,
                          categoryId: selectedCategoryId,
                          account: accountController.text.trim(),
                          date: selectedDate,
                          assignedPeopleIds: selectedPeopleIds.toList(),
                        ),
                      );
                      if (mounted) Navigator.pop(context);
                    }
                  },
                  child: const Text('Add'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _confirmDeleteExpense(Expense expense) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content: Text(
          'Are you sure you want to delete "${expense.name}" (\$${expense.amount.toStringAsFixed(2)})?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteExpense(Expense expense) async {
    await _firestore.deleteExpense(expense.id);
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

  Widget _buildPlannerMode() {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      body: Stack(
        children: [
          CustomPaint(painter: _RuledLinesPainter(), child: Container()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _isPlannerMode = false;
                          });
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Exit Planner Mode'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown.shade700,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      Text(
                        _formatDate(DateTime.now()),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.brown.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Budget Planner',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade900,
                      fontFamily: 'serif',
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildPlannerSection('Income'),
                        _buildPlannerSection('Expenses'),
                        _buildPlannerSection('Savings'),
                        _buildPlannerSection('Notes'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlannerSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.brown.shade800,
              fontFamily: 'serif',
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.brown.shade200, width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RuledLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFBDBDBD).withValues(alpha: 0.3)
      ..strokeWidth = 1;
    const lineSpacing = 40.0;
    for (double y = 80; y < size.height; y += lineSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    final marginPaint = Paint()
      ..color = Colors.redAccent.withValues(alpha: 0.3)
      ..strokeWidth = 2;
    canvas.drawLine(Offset(48, 0), Offset(48, size.height), marginPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
