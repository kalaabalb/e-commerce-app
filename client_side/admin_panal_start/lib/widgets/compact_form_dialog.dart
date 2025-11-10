import 'package:flutter/material.dart';
import '../utility/responsive_utils.dart';

class CompactFormDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final double? maxWidth;

  const CompactFormDialog({
    Key? key,
    required this.title,
    required this.child,
    this.maxWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(isMobile ? 16 : 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? (isMobile ? double.infinity : 600),
          maxHeight:
              MediaQuery.of(context).size.height * 0.95, // Increased max height
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF2A2D3E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Compact header
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12, // Reduced vertical padding
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF212332),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white70, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                  ],
                ),
              ),

              // Form content with flexible space
              Expanded(
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
