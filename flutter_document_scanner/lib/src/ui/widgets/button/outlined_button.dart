import 'package:flutter/material.dart';
import '../common/indicator.dart';
import 'model/button_size.dart';

class XOutlinedButton extends StatelessWidget {
  const XOutlinedButton({
    this.onPressed,
    this.title,
    this.child,
    this.icon,
    this.busy = false,
    this.enabled = true,
    this.size,
    this.borderColor,
    super.key,
  });

  final bool busy;
  final Widget? icon;
  final bool enabled;
  final String? title;
  final Widget? child;
  final VoidCallback? onPressed;
  final ButtonSize? size;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final size = this.size ?? ButtonSize.medium();
    final onPressed = enabled
        ? () {
            if (this.onPressed != null || busy == false) {
              this.onPressed?.call();
            }
          }
        : null;
    final foregroundColor = Theme.of(context).primaryColor;
    final indicator =
        XIndicator(radius: size.iconSize / 2, color: foregroundColor);

    return SizedBox(
      height: size.height,
      child: OutlinedButtonTheme(
        data: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: foregroundColor,
            textStyle: size.style.copyWith(),
            minimumSize: Size(size.minWidth, size.height),
            padding: EdgeInsets.symmetric(horizontal: size.padding),
            side: borderColor != null ? BorderSide(color: borderColor!) : null,
          ),
        ),
        child: icon != null
            ? OutlinedButton.icon(
                onPressed: onPressed,
                label: child ?? Text(title ?? ''),
                icon: busy
                    ? indicator
                    : IconTheme(
                        data: IconThemeData(
                            size: size.iconSize, color: foregroundColor),
                        child: icon!),
              )
            : OutlinedButton(
                onPressed: onPressed,
                child: busy ? indicator : (child ?? Text(title ?? '')),
              ),
      ),
    );
  }
}
