// lib/screens/posters/components/poster_header.dart
import 'package:admin_panal_start/utility/extensions.dart';
import 'package:admin_panal_start/utility/responsive_utils.dart';
import 'package:flutter/material.dart';
import '../../../utility/constants.dart';
import '../../../widgets/responsive_header.dart';

class PosterHeader extends StatelessWidget {
  const PosterHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveHeader(
      title: "Posters",
      onSearch: (val) {
        context.dataProvider.filterPosters(val);
      },
      actionButton: null,
    );
  }
}
