import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:turbo_flutter_template/core/state/manage-state/extensions/context_extension.dart';
import 'package:turbo_flutter_template/core/ui/show-ui/extensions/text_style_extension.dart';

class AcceptPrivacyText extends StatelessWidget {
  const AcceptPrivacyText({
    required this.onPrivacyPolicyTap,
    required this.onTermsOfServiceTap,
    super.key,
  });

  final VoidCallback onPrivacyPolicyTap;
  final VoidCallback onTermsOfServiceTap;

  @override
  Widget build(BuildContext context) {
    final textStyle = context.texts.muted;
    return Text.rich(
      TextSpan(
        style: textStyle,
        children: [
          TextSpan(text: context.strings.iAgreeToThe),
          const TextSpan(text: ' '),
          TextSpan(
            text: context.strings.privacyPolicy,
            style: textStyle.bold,
            recognizer: TapGestureRecognizer()..onTap = onPrivacyPolicyTap,
          ),
          const TextSpan(text: ' '),
          TextSpan(text: context.strings.and),
          const TextSpan(text: ' '),
          TextSpan(
            text: context.strings.termsOfService,
            style: textStyle.bold,
            recognizer: TapGestureRecognizer()..onTap = onTermsOfServiceTap,
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }
}
