import 'package:flutter/material.dart';
import '../../core/services/user_service.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  final String fullName;
  final double weight;
  final double height;
  final String goal;
  final String fitnessLevel;

  const EditProfileScreen({
    super.key,
    required this.fullName,
    required this.weight,
    required this.height,
    required this.goal,
    required this.fitnessLevel,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _userService = UserService();
  late final _nameCtrl = TextEditingController(text: widget.fullName);
  late final _weightCtrl = TextEditingController(text: widget.weight > 0 ? widget.weight.toString() : '');
  late final _heightCtrl = TextEditingController(text: widget.height > 0 ? widget.height.toStringAsFixed(0) : '');
  late String _goal = widget.goal.isNotEmpty ? widget.goal : 'Stay Fit';
  late String _level = widget.fitnessLevel.isNotEmpty ? widget.fitnessLevel : 'Beginner';
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    super.dispose();
  }

  void _save() async {
    setState(() => _saving = true);
    try {
      final response = await _userService.updateProfile(
        fullName: _nameCtrl.text.trim(),
        weight: double.tryParse(_weightCtrl.text.trim()),
        height: double.tryParse(_heightCtrl.text.trim()),
        goal: _goal,
        fitnessLevel: _level,
      );

      if (!mounted) return;
      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Profile updated!'), backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16)));
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message']?.toString() ?? 'Error')));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AppTextField(label: 'Full Name', hint: 'Your name', controller: _nameCtrl, prefix: Icons.person_outline_rounded),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: AppTextField(label: 'Weight (kg)', hint: '75', controller: _weightCtrl, prefix: Icons.monitor_weight_outlined, keyboard: TextInputType.number)),
            const SizedBox(width: 12),
            Expanded(child: AppTextField(label: 'Height (cm)', hint: '175', controller: _heightCtrl, prefix: Icons.straighten_rounded, keyboard: TextInputType.number)),
          ]),
          const SizedBox(height: 22),

          Text('Goal', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: cs.onSurface.withOpacity(0.55))),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: ['Build Muscle', 'Lose Weight', 'Stay Fit', 'Strength'].map((g) {
            final sel = _goal == g;
            return GestureDetector(
              onTap: () => setState(() => _goal = g),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: sel ? cs.primary.withOpacity(0.06) : cs.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: sel ? cs.primary : cs.outline, width: sel ? 1.5 : 1),
                ),
                child: Text(g, style: TextStyle(fontSize: 13, fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                  color: sel ? cs.primary : cs.onSurface.withOpacity(0.5))),
              ),
            );
          }).toList()),
          const SizedBox(height: 22),

          Text('Fitness Level', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: cs.onSurface.withOpacity(0.55))),
          const SizedBox(height: 10),
          Row(children: ['Beginner', 'Intermediate', 'Advanced'].map((l) => Expanded(child: GestureDetector(
            onTap: () => setState(() => _level = l),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                color: _level == l ? cs.primary.withOpacity(0.06) : cs.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _level == l ? cs.primary : cs.outline, width: _level == l ? 1.5 : 1),
              ),
              child: Center(child: Text(l, style: TextStyle(fontSize: 12, fontWeight: _level == l ? FontWeight.w600 : FontWeight.w400,
                color: _level == l ? cs.primary : cs.onSurface.withOpacity(0.45)))),
            ),
          ))).toList()),
          const SizedBox(height: 32),

          AppButton(label: 'Save Changes', loading: _saving, onPressed: _save),
        ]),
      ),
    );
  }
}