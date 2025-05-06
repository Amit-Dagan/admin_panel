import 'package:admin_panel/data/models/auth/create_user_req.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/basic_app_button.dart';
import '../../../common/widgets/text_button.dart';
import '../../../core/configs/assets.dart';
import '../../../domain/usecase/auth/auth.dart';
import '../../../service_locator.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // _backGround(),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: isWide
                      ? Row(
                          children: [
                            Expanded(child: _logoSection()),
                            Expanded(child: _formSection(context)),
                          ],
                        )
                      : Column(
                          children: [
                            _logoSection(),
                            _formSection(context),
                          ],
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _logoSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Column(
        children: [
          Image.asset(AppImages.logo),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _formSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
                  _text('Full Name'),
                  _nameField(context),
                  const SizedBox(height: 20),
                  _text('Email'),
                  _emailField(context),
                  const SizedBox(height: 20),
                  _text('Password'),
                  _passwordField(context),
                  const SizedBox(height: 20),
                  _text('Confirm Password'),
                  _confirmPasswordField(context),
                ],
              ),
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -40),
          child: BasicAppButton(
            onPressed: () async {
              var result = await sl<SignupUseCase>().call(
                params: CreateUserReq(
                  fullName: _name.text.toString(),
                  email: _email.text.toString(),
                  password: _password.text.toString(),
                ),
              );
              result.fold(
                (l) {
                  var snackBar = SnackBar(
                    content: Text(l),
                    behavior: SnackBarBehavior.floating,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                (r) {
                  var snackBar = SnackBar(
                    content: Text(r),
                    behavior: SnackBarBehavior.floating,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              );
            },
            title: 'Sign Up',
          ),
        ),
        BasicTextButton(
          color: const Color(0xFF14354e),

          onPressed: () {
            Navigator.pushReplacementNamed(context, '/signin');
          },
          text: 'Login',
          size: 18,
        ),
        const SizedBox(height: 30),
        BasicTextButton(
          color: const Color(0xFF14354e),
          onPressed: () {},
          text: 'Forgot Password?',
          size: 14,
        ),
        const SizedBox(height: 50),
      ],
    );
  }



  Widget _text(String text) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _emailField(BuildContext context) {
    return TextField(
      controller: _email,
      decoration: const InputDecoration(hintText: 'example@gmail.com')
          .applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

    Widget _nameField(BuildContext context) {
    return TextField(
      controller: _name,
      decoration: const InputDecoration(
        hintText: 'Your name',
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
      controller: _password,
      decoration: const InputDecoration(hintText: '*******')
          .applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _confirmPasswordField(BuildContext context) {
    return TextField(
      controller: _confirmPassword,
      decoration: const InputDecoration(hintText: '*******')
          .applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }
}
