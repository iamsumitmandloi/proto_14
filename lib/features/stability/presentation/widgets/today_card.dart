import 'package:flutter/material.dart';

class TodayCard extends StatelessWidget {
  const TodayCard({
    super.key,
    required this.pushupsDone,
    required this.deepWorkDone,
    required this.stepsController,
    required this.cigarettesController,
    required this.onPushupsChanged,
    required this.onDeepWorkChanged,
    required this.score,
    required this.onSave,
    required this.isSaving,
  });

  final bool pushupsDone;
  final bool deepWorkDone;
  final TextEditingController stepsController;
  final TextEditingController cigarettesController;
  final ValueChanged<bool> onPushupsChanged;
  final ValueChanged<bool> onDeepWorkChanged;
  final int score;
  final VoidCallback onSave;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Today', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Pushups Done'),
              value: pushupsDone,
              onChanged: onPushupsChanged,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Deep Work Done'),
              value: deepWorkDone,
              onChanged: onDeepWorkChanged,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: stepsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Steps',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: cigarettesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cigarettes',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Text('Score: $score / 4'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: isSaving ? null : onSave,
              child: isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save Today'),
            ),
          ],
        ),
      ),
    );
  }
}
