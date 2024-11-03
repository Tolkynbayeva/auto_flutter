import 'package:auto_flutter/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBarWithSubtitle extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final bool showActionIcon;
  final String? actionIconPath;
  final VoidCallback? onActionPressed;

  const CustomAppBarWithSubtitle({
    required this.title,
    required this.subtitle,
    this.showActionIcon = false,
    this.actionIconPath,
    this.onActionPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 120,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AutoTextStyles.h1,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                Text(
                  subtitle,
                  style: AutoTextStyles.h4,
                ),
              ],
            ),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        if (showActionIcon && actionIconPath != null)
          IconButton(
            icon: SvgPicture.asset(actionIconPath!),
            onPressed: onActionPressed,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
