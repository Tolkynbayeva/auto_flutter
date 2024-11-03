import 'package:flutter/material.dart';
import 'package:auto_flutter/style/text_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;

 // final Color iconColor;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    required this.title,
    this.backgroundColor = Colors.white,
   // this.iconColor = Colors.black,
    this.actions,
    this.bottom,
    super.key,
  });

  @override
  Size get preferredSize {
    final bottomHeight = bottom?.preferredSize.height ?? 0;
    return Size.fromHeight(kToolbarHeight + bottomHeight);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: backgroundColor,
     // iconTheme: IconThemeData(color: iconColor),
      title: Text(
        title,
        style: AutoTextStyles.h1,
      ),
      actions: actions,
      bottom: bottom,
    );
  }
}
