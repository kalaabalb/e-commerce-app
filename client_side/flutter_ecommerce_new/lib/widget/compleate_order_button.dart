import 'package:e_commerce_flutter/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/data/data_provider.dart';

class CompleteOrderButton extends StatelessWidget {
  final String? labelText;
  final Function()? onPressed;

  const CompleteOrderButton({super.key, this.onPressed, this.labelText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          foregroundColor: Colors.white,
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        onPressed: onPressed,
        child: Text(
          labelText ?? context.dataProvider.translate('complete_order'),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}