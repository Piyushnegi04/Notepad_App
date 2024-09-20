import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ClickableText extends StatelessWidget {
  final String text;

  ClickableText(this.text);

  @override
  Widget build(BuildContext context) {
    final List<TextSpan> children = [];

    // Regular expression to detect URLs
    final RegExp exp = RegExp(
        r'(http|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])?');
    final Iterable<RegExpMatch> matches = exp.allMatches(text);

    int lastMatchEnd = 0;
    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        // Add plain text before the URL
        children.add(TextSpan(text: text.substring(lastMatchEnd, match.start)));
      }

      final String url = match.group(0) ?? '';
      // Add the URL as a clickable link
      children.add(
        TextSpan(
          text: url,
          style: const TextStyle(
              color: Colors.blue, decoration: TextDecoration.underline),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              if (await canLaunchUrlString(url)) {
                await launchUrlString(url,
                    mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Could not launch $url')),
                );
              }
            },
        ),
      );
      lastMatchEnd = match.end;
    }

    // Add remaining plain text after the last URL
    if (lastMatchEnd < text.length) {
      children.add(TextSpan(text: text.substring(lastMatchEnd)));
    }

    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: children,
      ),
    );
  }
}
