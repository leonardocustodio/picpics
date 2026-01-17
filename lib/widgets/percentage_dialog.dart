import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:picpics/providers/percentage_dialog_provider.dart';

class PercentageDialog extends ConsumerWidget {
  const PercentageDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(percentageDialogProvider);

    if (!state.isShowing) {
      return Container();
    }

    final percentage = state.progress;
    final textPercent = (percentage * 100).floor();

    return Stack(
      children: [
        Positioned.fill(
          child: Container(color: Colors.black.withValues(alpha: .7)),
        ),
        Align(
          child: Container(
            width: 80,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(50)),
            height: 80,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CircularPercentIndicator(
                      radius: 70,
                      percent: percentage,
                      progressColor: Colors.green,
                      backgroundColor: Colors.grey.withValues(alpha: .4)),
                ),
                Align(
                  child: Text(
                    '$textPercent%',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        inherit: false, color: Colors.black, fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (state.message.isNotEmpty)
          Align(
            child: Container(
              margin: const EdgeInsets.only(top: 130),
              child: Text(
                textPercent > 98 ? "Finishing..." : state.message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    inherit: false, color: Colors.white, fontSize: 17),
              ),
            ),
          ),
      ],
    );
  }
}
