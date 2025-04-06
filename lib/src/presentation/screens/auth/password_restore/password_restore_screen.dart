import 'package:flutter/material.dart';
import '../../../../core/generated/i18n/app_localizations.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/app_route.dart';
import '../password_change/password_change_screen.dart';

class PasswordRestoreScreen extends StatefulWidget {
  const PasswordRestoreScreen({super.key});

  @override
  State<PasswordRestoreScreen> createState() => _PasswordRestoreScreenState();
}

class _PasswordRestoreScreenState extends State<PasswordRestoreScreen> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              constraints: const BoxConstraints(maxWidth: 400.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.passwordResetLink,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 46.0,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.email),
                      icon: const Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: ValidationBuilder().email().build(),
                  ),
                  const SizedBox(
                    height: 46.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const PasswordChangeScreen(),
                      ));
                    },
                    child: Text(
                      AppLocalizations.of(context)!.passwordRestore,
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  TextButton(
                      onPressed: () => context
                          .pushReplacementNamed(AppRoute.signInRouteName),
                      child: Text(AppLocalizations.of(context)!.signIn)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
