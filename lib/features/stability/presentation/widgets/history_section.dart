import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/stability_log.dart';

class HistorySection extends StatelessWidget {
  const HistorySection({super.key, required this.logs});

  final List<StabilityLog> logs;

  @override
  Widget build(BuildContext context) {
    final totalScore = logs.fold<int>(0, (sum, log) => sum + log.score);
    final maxScore = 56;
    final progress = (totalScore / maxScore).clamp(0, 1).toDouble();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('14-Day History', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Total score: $totalScore / $maxScore'),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 16),
            if (logs.isEmpty)
              const Text('No entries yet. Save your first day to get started.')
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: logs.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final log = logs[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(DateFormat.yMMMMd().format(log.date)),
                    trailing: Text('${log.score} / 4'),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
