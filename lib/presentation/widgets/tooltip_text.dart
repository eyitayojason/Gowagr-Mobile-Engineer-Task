import 'package:flutter/material.dart';
import '../../constants/colors.dart';

/// A reusable widget that displays text with an optional tooltip.
///
/// This widget automatically shows a tooltip when the text is truncated
/// or when explicitly requested. It provides consistent styling across
/// the application.
///
/// Example usage:
/// ```dart
/// TooltipText(
///   text: "This is a long text that might be truncated",
///   style: TextStyle(fontSize: 16),
///   maxLines: 1,
/// )
/// ```
///
/// Or using the extension method:
/// ```dart
/// "Long text".toTooltipText(
///   style: TextStyle(fontSize: 16),
///   maxLines: 2,
/// )
/// ```
class TooltipText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int maxLines;
  final TextOverflow overflow;
  final TextAlign? textAlign;
  final String? tooltipMessage;
  final Duration? tooltipDuration;
  final bool showTooltip;

  const TooltipText({
    super.key,
    required this.text,
    this.style,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign,
    this.tooltipMessage,
    this.tooltipDuration,
    this.showTooltip = true,
  });

  @override
  Widget build(BuildContext context) {
    // If tooltip is disabled or text doesn't need truncation, return regular text
    if (!showTooltip) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
      );
    }

    // Use provided tooltip message or fall back to text
    final message = tooltipMessage ?? text;

    return Tooltip(
      message: message,
      preferBelow: false,
      decoration: BoxDecoration(
        color: AppColors.darkBlue.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      child: Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
      ),
    );
  }
}

/// Extension for easier usage with common text styles
///
/// Usage example:
/// ```dart
/// "Hello World".toTooltipText(style: TextStyle(fontSize: 16))
/// ```
extension TooltipTextExtension on String {
  Widget toTooltipText({
    TextStyle? style,
    int maxLines = 1,
    TextOverflow overflow = TextOverflow.ellipsis,
    TextAlign? textAlign,
    String? tooltipMessage,
    Duration? tooltipDuration,
    bool showTooltip = true,
  }) {
    return TooltipText(
      text: this,
      style: style,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      tooltipMessage: tooltipMessage,
      tooltipDuration: tooltipDuration,
      showTooltip: showTooltip,
    );
  }
}
