import 'package:admin_panel/common/cubit/system_cubit.dart';
import 'package:admin_panel/common/widgets/nav_button.dart';
import 'package:admin_panel/core/configs/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

// Static list of nav buttons, accessible from anywhere
List<Widget> appBarActions(BuildContext context) {

  return [
    navButton(Icons.chat, 'צ\'אטים', () {
      Navigator.pushReplacementNamed(context, '/chatPage');

    }),
    navButton(Icons.people, 'מטופלים', () {
      Navigator.pushReplacementNamed(context, '/CustomersPage');
    }),
    navButton(Icons.settings, 'הגדרות', () {
      Navigator.pushNamed(context, '/config');
    }),

  ];
}

class DesktopAppbar extends StatelessWidget implements PreferredSizeWidget {
  const DesktopAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(
      context,
    ).largerOrEqualTo(DESKTOP);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
        color: Colors.white, // Or your preferred color
        child: SafeArea(
          bottom: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _logoWidget(),
              const Spacer(),
              if (isDesktop)
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: responsiveButtons(context),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(150); // adjust as needed

  Widget responsiveButtons(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: 12,
      runSpacing: 12,
      children: appBarActions(context), // Using the static actions list here
    );
  }
}

class MobileAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MobileAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 100,
      elevation: 0,
      centerTitle: true,
      title: _logoWidget(),
    );
  }
}

class BasicAppbar extends StatelessWidget implements PreferredSizeWidget {
  const BasicAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(150); // Adjusted dynamically

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(
      context,
    ).largerOrEqualTo(DESKTOP);
    return isDesktop ? const DesktopAppbar() : const MobileAppbar();
  }
}

Widget _logoWidget() {
  return SizedBox(
    height: 100,
    child: Image.asset(AppImages.logo, fit: BoxFit.contain),
  );
}
