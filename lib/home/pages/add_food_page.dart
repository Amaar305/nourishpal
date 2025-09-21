import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nourishpal/home/models/food_item.dart';
import 'package:nourishpal/main.dart';
import 'package:nourishpal/services/food_repository.dart';
import 'package:nourishpal/services/notification_services.dart';

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({super.key});

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  final name = TextEditingController();
  final qty = TextEditingController();
  DateTime? expiry;
  String? category;

  final categories = const [
    'Produce',
    'Dairy',
    'Meat',
    'Bakery',
    'Frozen',
    'Pantry',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Add Food Item'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(
                hintText: 'Name',
                contentPadding: EdgeInsets.all(20),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: qty,
              decoration: const InputDecoration(
                hintText: 'Quantity',
                contentPadding: EdgeInsets.all(20),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  firstDate: now.subtract(const Duration(days: 1)),
                  lastDate: DateTime(now.year + 3),
                  initialDate: now,
                );
                if (picked != null) setState(() => expiry = picked);
              },
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Expiry Date',
                    suffixIcon: const Icon(Icons.calendar_today),
                    contentPadding: EdgeInsets.all(20),
                  ),
                  controller: TextEditingController(
                    text: expiry == null ? '' : FoodRepository.fmt(expiry!),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            DropdownButtonFormField<String>(
              initialValue: category,
              items: categories
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => category = v),
              decoration: const InputDecoration(
                hintText: 'Category',
                contentPadding: EdgeInsets.all(20),
              ),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () async {
                if (name.text.isEmpty ||
                    qty.text.isEmpty ||
                    expiry == null ||
                    category == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please complete all fields')),
                  );
                  return;
                }
                foodRepo.add(
                  FoodItem(
                    name: name.text.trim(),
                    quantity: qty.text.trim(),
                    expiry: expiry!,
                    category: category!,
                  ),
                );
                await NotificationService().rescheduleExpiryAlerts();
                await NotificationService().showNow(
                  title: 'NourishPal',
                  body: 'Hello from local notifications!',
                );
                if (context.mounted) context.go('/home');
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
