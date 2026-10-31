import 'package:flutter/material.dart';
import 'bhashini_service.dart';

class GlobalBhashiniText extends StatefulWidget {
  final String data;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;

  const GlobalBhashiniText(
    this.data, {
    Key? key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  }) : super(key: key);

  @override
  State<GlobalBhashiniText> createState() => _GlobalBhashiniTextState();
}

class _GlobalBhashiniTextState extends State<GlobalBhashiniText> {
  String _translatedText = '';
  String _lastLang = 'en';

  @override
  void initState() {
    super.initState();
    _translatedText = widget.data;
    _lastLang = GlobalBhashiniService.instance.currentLanguageCode;
    _translate();
    GlobalBhashiniService.instance.addListener(_onLangChange);
  }

  void _onLangChange() {
    if (mounted && _lastLang != GlobalBhashiniService.instance.currentLanguageCode) {
      _lastLang = GlobalBhashiniService.instance.currentLanguageCode;
      _translate();
    }
  }

  @override
  void didUpdateWidget(GlobalBhashiniText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _translate();
    }
  }

  @override
  void dispose() {
    GlobalBhashiniService.instance.removeListener(_onLangChange);
    super.dispose();
  }

  Future<void> _translate() async {
    final t = await GlobalBhashiniService.instance.translate(widget.data);
    if (mounted) {
      setState(() {
        _translatedText = t;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _translatedText,
      style: widget.style,
      strutStyle: widget.strutStyle,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      locale: widget.locale,
      softWrap: widget.softWrap,
      overflow: widget.overflow,
      maxLines: widget.maxLines,
      semanticsLabel: widget.semanticsLabel,
      textWidthBasis: widget.textWidthBasis,
      textHeightBehavior: widget.textHeightBehavior,
      selectionColor: widget.selectionColor,
    );
  }
}
