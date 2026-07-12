import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({super.key, this.value});
  /// 0..1, or null = indeterminate.
  final double? value;

  @override
  Widget build(BuildContext context) =>
      // ADAPTER (shadcn ^0.0.52): Progress expects 0..100.
      shad.Progress(progress: value == null ? null : (value! * 100).clamp(0, 100));
}

class AppSpinner extends StatelessWidget {
  const AppSpinner({super.key, this.size = 24});
  final double size;

  @override
  Widget build(BuildContext context) =>
      SizedBox.square(dimension: size, child: const shad.CircularProgressIndicator());
}

/// Skeleton loading — wrap the real layout, don't design separate ghosts.
class AppSkeleton extends StatelessWidget {
  const AppSkeleton({super.key, required this.child, required this.loading});
  final Widget child;
  final bool loading;

  @override
  Widget build(BuildContext context) =>
      // ADAPTER (shadcn ^0.0.52): built on skeletonizer via shadcn extension.
      loading ? child.asSkeleton() : child;
}
