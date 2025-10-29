// lib/widgets/responsive_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utility/constants.dart';
import '../utility/responsive_utils.dart';

class ResponsiveHeader extends StatelessWidget {
  final String title;
  final Function(String) onSearch;
  final Widget? actionButton;

  const ResponsiveHeader({
    Key? key,
    required this.title,
    required this.onSearch,
    this.actionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (ResponsiveUtils.isMobile(context)) {
      return _buildMobileHeader(context);
    }

    return _buildDesktopHeader(context);
  }

  Widget _buildMobileHeader(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),
            _buildCompactProfile(),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildSearchField()),
            if (actionButton != null) ...[
              SizedBox(width: 8),
              actionButton!,
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopHeader(BuildContext context) {
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        Spacer(flex: 2),
        Expanded(
          child: _buildSearchField(),
        ),
        _buildProfileCard(),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: secondaryColor,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: Container(
          padding: EdgeInsets.all(defaultPadding * 0.75),
          margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: SvgPicture.asset("assets/icons/Search.svg"),
        ),
      ),
      onChanged: onSearch,
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: EdgeInsets.only(left: defaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Image.asset("assets/images/profile_pic.png", height: 38),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            child: Text("Angelina Jolie"),
          ),
          Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }

  Widget _buildCompactProfile() {
    return CircleAvatar(
      radius: 20,
      backgroundImage: AssetImage("assets/images/profile_pic.png"),
    );
  }
}
