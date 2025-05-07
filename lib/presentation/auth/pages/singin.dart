import 'package:admin_panel/common/cubit/system_cubit.dart';
import 'package:flutter/material.dart';
import '../../../common/widgets/basic_app_button.dart';
import '../../../common/widgets/text_button.dart';
import '../../../core/configs/assets.dart';
import '../../../data/models/auth/signin_user_req.dart';
import '../../../domain/usecase/auth/auth.dart';
import '../../../service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SigninPage extends StatelessWidget {
  SigninPage({super.key});

  final TextEditingController _password = TextEditingController();
  final TextEditingController _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //_backGround(),
          Padding(
            padding: const EdgeInsets.all(15),
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isWide =
                    constraints.maxWidth > 600; // breakpoint for web layout

                return SingleChildScrollView(
                  child:
                      isWide
                          ? Row(
                            children: [
                              Expanded(child: _logoSection()),
                              Expanded(child: _loginSection(context)),
                            ],
                          )
                          : Column(
                            children: [_logoSection(), _loginSection(context)],
                          ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _logoSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 25),
        Image.asset(AppImages.logo),
        const SizedBox(height: 20),
        
      ],
    );
  }

  Widget _loginSection(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(38),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 43),
              child: Column(
                children: [
                  _text('Email'),
                  _emailField(context),
                  const SizedBox(height: 20),
                  _text('Password'),
                  _passwordField(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        Container(
          transform: Matrix4.translationValues(0, -40, 0),
          child: BasicAppButton(
            onPressed: () async {
              var result = await sl<SigninUseCase>().call(
                params: SigninUserReq(
                  email: _email.text.toString(),
                  password: _password.text.toString(),
                ),
              );
              result.fold(
                (l) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l.message),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                (r) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(r),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  context.read<SystemCubit>().saveCurrentUser(r);
                  Navigator.pushReplacementNamed(context, '/homePage');
                },
              );
            },
            title: 'LOGIN',
          ),
        ),
      ],
    );
  }

  Widget _text(String text) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
    );
  }

  Widget _emailField(BuildContext context) {
    return TextField(
      controller: _email,
      decoration: const InputDecoration(
        hintText: 'example@gmail.com',
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
      controller: _password,
      decoration: const InputDecoration(
        hintText: '*******',
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }
}
