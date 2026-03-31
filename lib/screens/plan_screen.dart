import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:check_2_check/utils/feature_flags.dart';

enum _PlanView { paychecks, categories }

class _MockPerson {
  final String id;
  final String displayName;
  final Color color;

  const _MockPerson({
    required this.id,
    required this.displayName,
    required this.color,
  });
}

class _MockPaycheck {
  final DateTime date;
  final double amount;
  final List<_MockPerson> assignedPeople;
  final List<_MockExpense> expenses;

  _MockPaycheck({
    required this.date,
    required this.amount,
    required this.assignedPeople,
    required this.expenses,
  });

  double get remaining => amount - expenses.fold(0, (sum, e) => sum + e.amount);
}

class _MockExpense {
  final String name;
  final double amount;
  final List<_MockPerson> assignedPeople;

  const _MockExpense({
    required this.name,
    required this.amount,
    required this.assignedPeople,
  });
}

class _MockCategory {
  final String id;
  final String name;
  final IconData icon;
  final double planned;
  final double spent;
  final bool isCustom;

  const _MockCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.planned,
    required this.spent,
    this.isCustom = false,
  });

  double get remaining => planned - spent;

  _MockCategory copyWith({
    String? name,
    IconData? icon,
    double? planned,
    double? spent,
  }) {
    return _MockCategory(
      id: id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      planned: planned ?? this.planned,
      spent: spent ?? this.spent,
      isCustom: isCustom,
    );
  }
}

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  _PlanView _currentView = _PlanView.paychecks;
  bool _isPlannerMode = false;

  bool get _isIOS => !kIsWeb && Platform.isIOS;

  final List<_MockPerson> _people = [
    const _MockPerson(id: 'p1', displayName: 'Alex', color: Colors.blue),
    const _MockPerson(id: 'p2', displayName: 'Jordan', color: Colors.purple),
    const _MockPerson(id: 'p3', displayName: 'Sam', color: Colors.teal),
  ];

  late List<_MockPaycheck> _paychecks;
  late List<_MockCategory> _categories;

  @override
  void initState() {
    super.initState();
    _paychecks = [
      _MockPaycheck(
        date: DateTime(2026, 4, 3),
        amount: 2400,
        assignedPeople: [_people[0]],
        expenses: [
          _MockExpense(
            name: 'Rent',
            amount: 1200,
            assignedPeople: [_people[0], _people[1]],
          ),
          _MockExpense(
            name: 'Groceries',
            amount: 200,
            assignedPeople: [_people[1]],
          ),
          _MockExpense(
            name: 'Utilities',
            amount: 150,
            assignedPeople: [_people[0]],
          ),
        ],
      ),
      _MockPaycheck(
        date: DateTime(2026, 4, 17),
        amount: 2400,
        assignedPeople: [_people[1]],
        expenses: [
          _MockExpense(
            name: 'Groceries',
            amount: 200,
            assignedPeople: [_people[1]],
          ),
          _MockExpense(name: 'Gas', amount: 60, assignedPeople: [_people[1]]),
          _MockExpense(
            name: 'Savings',
            amount: 300,
            assignedPeople: [_people[0], _people[1]],
          ),
        ],
      ),
      _MockPaycheck(
        date: DateTime(2026, 5, 1),
        amount: 2400,
        assignedPeople: [_people[0]],
        expenses: [
          _MockExpense(
            name: 'Rent',
            amount: 1200,
            assignedPeople: [_people[0], _people[1]],
          ),
          _MockExpense(
            name: 'Insurance',
            amount: 180,
            assignedPeople: [_people[0]],
          ),
        ],
      ),
    ];

    _categories = [
      const _MockCategory(
        id: 'c1',
        name: 'Rent',
        icon: Icons.home,
        planned: 1200,
        spent: 1200,
      ),
      const _MockCategory(
        id: 'c2',
        name: 'Groceries',
        icon: Icons.shopping_cart,
        planned: 400,
        spent: 185,
      ),
      const _MockCategory(
        id: 'c3',
        name: 'Utilities',
        icon: Icons.bolt,
        planned: 150,
        spent: 150,
      ),
      const _MockCategory(
        id: 'c4',
        name: 'Gas',
        icon: Icons.local_gas_station,
        planned: 120,
        spent: 60,
      ),
      const _MockCategory(
        id: 'c5',
        name: 'Savings',
        icon: Icons.savings,
        planned: 300,
        spent: 0,
      ),
      const _MockCategory(
        id: 'c6',
        name: 'Insurance',
        icon: Icons.shield,
        planned: 180,
        spent: 0,
      ),
      const _MockCategory(
        id: 'c7',
        name: 'Entertainment',
        icon: Icons.movie,
        planned: 100,
        spent: 45,
      ),
    ];
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
          if (_currentView == _PlanView.categories)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _showAddCategoryDialog,
              tooltip: 'Add Category',
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SegmentedButton<_PlanView>(
              segments: const [
                ButtonSegment<_PlanView>(
                  value: _PlanView.paychecks,
                  label: Text('Paychecks'),
                  icon: Icon(Icons.payment),
                ),
                ButtonSegment<_PlanView>(
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
            child: _currentView == _PlanView.paychecks
                ? _buildPaycheckView()
                : _buildCategoryView(),
          ),
        ],
      ),
    );
  }

  Widget _buildPaycheckView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _paychecks.length,
      itemBuilder: (context, index) {
        final paycheck = _paychecks[index];
        final isPast = paycheck.date.isBefore(DateTime.now());
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
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
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_formatDate(paycheck.date)),
                if (paycheck.assignedPeople.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    runSpacing: 2,
                    children: paycheck.assignedPeople
                        .map((p) => _buildPersonChip(p))
                        .toList(),
                  ),
                ],
              ],
            ),
            trailing: Text(
              '\$${paycheck.remaining.toStringAsFixed(2)}',
              style: TextStyle(
                color: paycheck.remaining >= 0
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Assigned Expenses',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    ...paycheck.expenses.map(
                      (expense) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    expense.name,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                  if (expense.assignedPeople.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Wrap(
                                      spacing: 4,
                                      runSpacing: 2,
                                      children: expense.assignedPeople
                                          .map(
                                            (p) => _buildPersonChip(
                                              p,
                                              small: true,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Text(
                              '\$${expense.amount.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
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
                        color: Theme.of(context).colorScheme.secondaryContainer,
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
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
  }

  Widget _buildPersonChip(_MockPerson person, {bool small = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6 : 8,
        vertical: small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: person.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: person.color.withValues(alpha: 0.4)),
      ),
      child: Text(
        person.displayName,
        style: TextStyle(
          fontSize: small ? 10 : 12,
          color: person.color,
          fontWeight: FontWeight.w600,
        ),
      ),
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
                onPressed: () {
                  if (nameController.text.trim().isNotEmpty &&
                      amountController.text.isNotEmpty) {
                    setState(() {
                      _categories.add(
                        _MockCategory(
                          id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                          name: nameController.text.trim(),
                          icon: selectedIcon,
                          planned: double.tryParse(amountController.text) ?? 0,
                          spent: 0,
                          isCustom: true,
                        ),
                      );
                    });
                    Navigator.pop(context);
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

  Future<void> _showEditCategoryDialog(_MockCategory category) async {
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
                onPressed: () {
                  if (nameController.text.trim().isNotEmpty &&
                      amountController.text.isNotEmpty) {
                    setState(() {
                      final index = _categories.indexWhere(
                        (c) => c.id == category.id,
                      );
                      if (index != -1) {
                        _categories[index] = category.copyWith(
                          name: nameController.text.trim(),
                          icon: selectedIcon,
                          planned:
                              double.tryParse(amountController.text) ??
                              category.planned,
                        );
                      }
                    });
                    Navigator.pop(context);
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

  Future<bool?> _confirmDeleteCategory(_MockCategory category) async {
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

  void _deleteCategory(_MockCategory category) {
    setState(() {
      _categories.removeWhere((c) => c.id == category.id);
    });
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
