import 'package:flutter/widgets.dart';
import 'package:shadcn_wrapper/shadcn_wrapper.dart';

class LoadingListWidget extends StatelessWidget {
  const LoadingListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSkeleton(
      loading: true,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppTokens.s2),
        itemCount: 10,
        separatorBuilder: (_, __) {
          return const SizedBox(height: 8);
        },
        itemBuilder: (context, index) {
          return const AppButton.outline(
            child: SizedBox(
              width: double.infinity,
              height: 48,
            ),
          );
        },
      ),
    );
  }
}
