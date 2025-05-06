import 'package:admin_panel/common/widgets/appbar.dart';
import 'package:admin_panel/common/widgets/basic_app_button.dart';
import 'package:admin_panel/presentation/home/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(
      context,
    ).largerOrEqualTo(DESKTOP);
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final horizontalPadding = isDesktop ? 100.0 : 16.0;

    return Scaffold(
      appBar: BasicAppbar(),
      drawer: Drawer(child: ListView(children: appBarActions(context))),

      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 20,
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // This Expanded widget makes the grid grow to fill the rest
            //Expanded(child: CustomersGrid()),
          ],
        ),
      ),
    );
  }

  
}
