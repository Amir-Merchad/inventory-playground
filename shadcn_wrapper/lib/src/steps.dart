import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

/// ---------------------------------------------------------------------------
/// Timeline — audit trails, order history, stock-movement history.
/// ---------------------------------------------------------------------------
class AppTimelineEntry {
  const AppTimelineEntry({required this.time, required this.title, this.content, this.color});
  final String time;
  final String title;
  final Widget? content;

  /// Semantic accent (e.g. danger for "voided"); defaults to theme primary.
  final Color? color;
}

class AppTimeline extends StatelessWidget {
  const AppTimeline({super.key, required this.entries});
  final List<AppTimelineEntry> entries;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52).
    return shad.Timeline(
      data: [
        for (final e in entries)
          shad.TimelineData(
            time: Text(e.time),
            title: Text(e.title),
            content: e.content,
            color: e.color,
          ),
      ],
    );
  }
}

/// ---------------------------------------------------------------------------
/// Steps — static numbered guide (setup instructions, SOP checklists).
/// ---------------------------------------------------------------------------
class AppStepsItem {
  const AppStepsItem({required this.title, this.content = const []});
  final String title;
  final List<Widget> content;
}

class AppSteps extends StatelessWidget {
  const AppSteps({super.key, required this.items});
  final List<AppStepsItem> items;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52).
    return shad.Steps(
      children: [
        for (final i in items) shad.StepItem(title: Text(i.title), content: i.content),
      ],
    );
  }
}

/// ---------------------------------------------------------------------------
/// Stepper — interactive wizard (checkout, stock-take, onboarding, imports).
/// Controlled: currentStep lives in the caller; mark failures per step.
/// ---------------------------------------------------------------------------
class AppWizardStep {
  const AppWizardStep({required this.title, this.icon, this.contentBuilder});
  final String title;
  final Widget? icon;
  final WidgetBuilder? contentBuilder;
}

class AppStepper extends StatefulWidget {
  const AppStepper({
    super.key,
    required this.steps,
    required this.currentStep,
    this.failedSteps = const {},
    this.horizontal = true,
  });
  final List<AppWizardStep> steps;
  final int currentStep;

  /// Indices rendered in the failed state (validation errors).
  final Set<int> failedSteps;
  final bool horizontal;

  @override
  State<AppStepper> createState() => _AppStepperState();
}

class _AppStepperState extends State<AppStepper> {
  late shad.StepperController _controller;

  shad.StepperValue _value() => shad.StepperValue(
        currentStep: widget.currentStep,
        stepStates: {for (final i in widget.failedSteps) i: shad.StepState.failed},
      );

  @override
  void initState() {
    super.initState();
    // ADAPTER (shadcn ^0.0.52): StepperController is a ValueNotifier.
    _controller = shad.StepperController(
      currentStep: widget.currentStep,
      stepStates: {for (final i in widget.failedSteps) i: shad.StepState.failed},
    );
  }

  @override
  void didUpdateWidget(covariant AppStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep || oldWidget.failedSteps != widget.failedSteps) {
      _controller.value = _value();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return shad.Stepper(
      controller: _controller,
      direction: widget.horizontal ? Axis.horizontal : Axis.vertical,
      steps: [
        for (final s in widget.steps)
          shad.Step(title: Text(s.title), icon: s.icon, contentBuilder: s.contentBuilder),
      ],
    );
  }
}
