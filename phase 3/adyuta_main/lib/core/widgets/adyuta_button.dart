import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdyutaButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;

  const AdyutaButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
  });

  @override
  State<AdyutaButton> createState() => _AdyutaButtonState();
}

class _AdyutaButtonState extends State<AdyutaButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!widget.isLoading) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (!widget.isLoading) {
      HapticFeedback.lightImpact();
      _controller.reverse();
      widget.onPressed();
    }
  }

  void _onTapCancel() {
    if (!widget.isLoading) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget buttonContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading)
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          )
        else ...[
          if (widget.icon != null) ...[
            Icon(widget.icon, size: 20),
            const SizedBox(width: 8),
          ],
          Text(widget.text),
        ],
      ],
    );

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: widget.isOutlined 
                ? Colors.transparent 
                : theme.colorScheme.primary,
            border: widget.isOutlined 
                ? Border.all(color: theme.colorScheme.primary, width: 1.5)
                : null,
            boxShadow: widget.isOutlined ? [] : [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Center(
            child: DefaultTextStyle(
              style: theme.textTheme.titleMedium!.copyWith(
                color: widget.isOutlined 
                    ? theme.colorScheme.primary 
                    : Colors.white,
                fontWeight: FontWeight.bold,
              ),
              child: IconTheme(
                data: IconThemeData(
                  color: widget.isOutlined 
                      ? theme.colorScheme.primary 
                      : Colors.white,
                ),
                child: buttonContent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
