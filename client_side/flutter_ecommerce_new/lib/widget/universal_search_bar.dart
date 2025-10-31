import 'package:flutter/material.dart';
import 'package:e_commerce_flutter/utility/extensions.dart';
import '../utility/app_color.dart';

class UniversalSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final VoidCallback? onClear;

  const UniversalSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText,
    this.onClear,
  });

  @override
  State<UniversalSearchBar> createState() => _UniversalSearchBarState();
}

class _UniversalSearchBarState extends State<UniversalSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        onChanged: (value) {
          // This is the correct way - just pass the value directly
          widget.onChanged?.call(value);
        },
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
          hintText:
              widget.hintText ??
              context.safeDataProvider.safeTranslate(
                'search_hint',
                fallback: 'Search...',
              ),
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(Icons.search, color: AppColor.darkOrange, size: 20),
          ),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey, size: 20),
                  onPressed: () {
                    widget.controller.clear();
                    widget.onChanged?.call('');
                    widget.onClear?.call();
                  },
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}