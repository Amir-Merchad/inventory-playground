import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

/// User/customer avatar with initials fallback (works for Arabic names).
class AppAvatar extends StatelessWidget {
  const AppAvatar({super.key, required this.initials, this.imageUrl, this.size = 32});
  final String initials;
  final String? imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52).
    return shad.Avatar(
      initials: shad.Avatar.getInitials(initials),
      provider: imageUrl == null ? null : NetworkImage(imageUrl!),
      size: size,
    );
  }
}
