import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/stability_log.dart';
import '../providers/stability_providers.dart';
import '../widgets/history_section.dart';
import '../widgets/today_card.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  late final TextEditingController _stepsController;
  late final TextEditingController _cigarettesController;

  var _pushupsDone = false;
  var _deepWorkDone = false;

  @override
  void initState() {
    super.initState();
    _stepsController = TextEditingController(text: '0');
    _cigarettesController = TextEditingController(text: '0');

    Future.microtask(
      () => ref.read(dashboardNotifierProvider.notifier).loadLogs(),
    );
  }

  @override
  void dispose() {
    _stepsController.dispose();
    _cigarettesController.dispose();
    super.dispose();
  }

  int get _stepsCount => int.tryParse(_stepsController.text.trim()) ?? 0;
  int get _cigarettesCount => int.tryParse(_cigarettesController.text.trim()) ?? 0;

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardNotifierProvider);
    final scoreCalculator = ref.watch(scoreCalculatorProvider);

    final score = scoreCalculator(
      pushupsDone: _pushupsDone,
      deepWorkDone: _deepWorkDone,
      stepsCount: _stepsCount,
      cigarettesCount: _cigarettesCount,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('14-Day Stability Tracker')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (dashboardState.error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            dashboardState.error!,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onErrorContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            TodayCard(
              pushupsDone: _pushupsDone,
              deepWorkDone: _deepWorkDone,
              stepsController: _stepsController,
              cigarettesController: _cigarettesController,
              onPushupsChanged: (value) => setState(() => _pushupsDone = value),
              onDeepWorkChanged: (value) => setState(() => _deepWorkDone = value),
              score: score,
              isSaving: dashboardState.isSaving,
              onSave: () async {
                final today = DateTime.now();
                final dateOnly = DateTime(today.year, today.month, today.day);

                final log = StabilityLog(
                  date: dateOnly,
                  pushupsDone: _pushupsDone,
                  deepWorkDone: _deepWorkDone,
                  stepsCount: _stepsCount,
                  cigarettesCount: _cigarettesCount,
                  score: score,
                );

                await ref
                    .read(dashboardNotifierProvider.notifier)
                    .saveTodayLog(log);
              },
            ),
            const SizedBox(height: 16),
            if (dashboardState.isLoading)
              const Center(child: CircularProgressIndicator())
            else
              HistorySection(logs: dashboardState.logs),
          ],
        ),
      ),
    );
  }
}
