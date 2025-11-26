import 'package:flutter/material.dart';

enum ToastPosition {
  top,
  center,
  bottom,
}

void showSuccessToast(
    BuildContext context,
    String message, {
      ToastPosition position = ToastPosition.center,
    }) {
  _showCustomToast(
    context,
    message,
    icon: Icons.check_circle,
    iconColor: Colors.green,
    position: position,
  );
}

void showErrorToast(
    BuildContext context,
    String message, {
      ToastPosition position = ToastPosition.center,
    }) {
  _showCustomToast(
    context,
    message,
    icon: Icons.error,
    iconColor: Colors.red,
    position: position,
  );
}

void _showCustomToast(
    BuildContext context,
    String message, {
      required IconData icon,
      required Color iconColor,
      required ToastPosition position,
    }) {
  final overlay = Overlay.of(context);

  double? top;
  double? bottom;

  switch (position) {
    case ToastPosition.top:
      top = 80;
      break;
    case ToastPosition.center:
      top = null;
      bottom = null;
      break;
    case ToastPosition.bottom:
      bottom = 80;
      break;
  }

  final overlayEntry = OverlayEntry(
    builder: (_) => Positioned(
      top: top,
      bottom: bottom,
      left: 0,
      right: 0,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(const Duration(milliseconds: 1800)).then((_) {
    overlayEntry.remove();
  });
}
