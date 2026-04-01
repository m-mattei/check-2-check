import 'package:flutter/material.dart';
import 'package:check_2_check/services/firestore_service.dart';
import 'package:check_2_check/models/person.dart';
import 'package:check_2_check/models/household_role.dart';

class HouseholdScreen extends StatefulWidget {
  const HouseholdScreen({super.key});

  @override
  State<HouseholdScreen> createState() => _HouseholdScreenState();
}

class _HouseholdScreenState extends State<HouseholdScreen> {
  final _firestore = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Household'), centerTitle: true),
      body: StreamBuilder<List<Person>>(
        stream: _firestore.streamPeople(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final people = snapshot.data ?? [];

          if (people.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No household members yet.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: _showAddMemberDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Member'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: people.length,
            itemBuilder: (context, index) {
              final person = people[index];
              final color = person.color != null
                  ? Color(int.parse(person.color!))
                  : Theme.of(context).colorScheme.primary;
              return Dismissible(
                key: ValueKey(person.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) => _confirmDeletePerson(person),
                onDismissed: (_) => _deletePerson(person),
                child: Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color,
                      child: Text(
                        person.firstName[0].toUpperCase(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      person.displayName ?? person.fullName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: person.role != null
                        ? Text(
                            person.role!.name[0].toUpperCase() +
                                person.role!.name.substring(1),
                          )
                        : null,
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showEditMemberDialog(person),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMemberDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddMemberDialog() async {
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final middleNameController = TextEditingController();
    final nicknameController = TextEditingController();
    HouseholdRole? selectedRole;
    Color selectedColor = Colors.blue;

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
                  'Add Household Member',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: middleNameController,
                  decoration: const InputDecoration(
                    labelText: 'Middle Name (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nicknameController,
                  decoration: const InputDecoration(
                    labelText: 'Nickname (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Role', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                DropdownButtonFormField<HouseholdRole>(
                  value: selectedRole,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Select role',
                  ),
                  items: HouseholdRole.values.map((role) {
                    final label =
                        role.name[0].toUpperCase() + role.name.substring(1);
                    return DropdownMenuItem<HouseholdRole>(
                      value: role,
                      child: Text(label),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setModalState(() {
                      selectedRole = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Text('Color', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      [
                        Colors.blue,
                        Colors.red,
                        Colors.green,
                        Colors.orange,
                        Colors.purple,
                        Colors.teal,
                        Colors.pink,
                        Colors.indigo,
                        Colors.amber,
                        Colors.cyan,
                      ].map((color) {
                        final isSelected = color.value == selectedColor.value;
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              selectedColor = color;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(color: Colors.black, width: 3)
                                  : null,
                            ),
                            child: isSelected
                                ? const Icon(Icons.check, color: Colors.white)
                                : null,
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () async {
                    if (firstNameController.text.trim().isNotEmpty &&
                        lastNameController.text.trim().isNotEmpty) {
                      await _firestore.addPerson(
                        Person(
                          id: '',
                          userId: '',
                          firstName: firstNameController.text.trim(),
                          middleName: middleNameController.text.trim().isEmpty
                              ? null
                              : middleNameController.text.trim(),
                          lastName: lastNameController.text.trim(),
                          nickname: nicknameController.text.trim().isEmpty
                              ? null
                              : nicknameController.text.trim(),
                          role: selectedRole,
                          color:
                              '0x${selectedColor.value.toRadixString(16).padLeft(8, '0')}',
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

  Future<void> _showEditMemberDialog(Person person) async {
    final firstNameController = TextEditingController(text: person.firstName);
    final lastNameController = TextEditingController(text: person.lastName);
    final middleNameController = TextEditingController(
      text: person.middleName ?? '',
    );
    final nicknameController = TextEditingController(
      text: person.nickname ?? '',
    );
    HouseholdRole? selectedRole = person.role;
    Color selectedColor = person.color != null
        ? Color(int.parse(person.color!))
        : Colors.blue;

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
                  'Edit Member',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: middleNameController,
                  decoration: const InputDecoration(
                    labelText: 'Middle Name (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nicknameController,
                  decoration: const InputDecoration(
                    labelText: 'Nickname (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Role', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                DropdownButtonFormField<HouseholdRole>(
                  value: selectedRole,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Select role',
                  ),
                  items: HouseholdRole.values.map((role) {
                    final label =
                        role.name[0].toUpperCase() + role.name.substring(1);
                    return DropdownMenuItem<HouseholdRole>(
                      value: role,
                      child: Text(label),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setModalState(() {
                      selectedRole = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Text('Color', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      [
                        Colors.blue,
                        Colors.red,
                        Colors.green,
                        Colors.orange,
                        Colors.purple,
                        Colors.teal,
                        Colors.pink,
                        Colors.indigo,
                        Colors.amber,
                        Colors.cyan,
                      ].map((color) {
                        final isSelected = color.value == selectedColor.value;
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              selectedColor = color;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(color: Colors.black, width: 3)
                                  : null,
                            ),
                            child: isSelected
                                ? const Icon(Icons.check, color: Colors.white)
                                : null,
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () async {
                    if (firstNameController.text.trim().isNotEmpty &&
                        lastNameController.text.trim().isNotEmpty) {
                      await _firestore.updatePerson(
                        person.copyWith(
                          firstName: firstNameController.text.trim(),
                          middleName: middleNameController.text.trim().isEmpty
                              ? null
                              : middleNameController.text.trim(),
                          lastName: lastNameController.text.trim(),
                          nickname: nicknameController.text.trim().isEmpty
                              ? null
                              : nicknameController.text.trim(),
                          role: selectedRole,
                          color:
                              '0x${selectedColor.value.toRadixString(16).padLeft(8, '0')}',
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
      ),
    );
  }

  Future<bool?> _confirmDeletePerson(Person person) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Member'),
        content: Text(
          'Are you sure you want to remove "${person.displayName ?? person.fullName}" from the household?',
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

  Future<void> _deletePerson(Person person) async {
    await _firestore.deletePerson(person.id);
  }
}
