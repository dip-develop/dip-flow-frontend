import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/app_route.dart';
import '../../../../domain/usecases/usecases.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _paswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              constraints: const BoxConstraints(maxWidth: 400.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      label: Text(AppLocalizations.of(context)!.email),
                      icon: const Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: ValidationBuilder().email().build(),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        label: Text(AppLocalizations.of(context)!.password),
                        icon: const Icon(Icons.password),
                        suffixIcon: IconButton(
                            onPressed: () => setState(() {
                                  _paswordVisible = !_paswordVisible;
                                }),
                            icon: Icon(_paswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility))),
                    obscureText: !_paswordVisible,
                    keyboardType: TextInputType.visiblePassword,
                    validator: ValidationBuilder().minLength(6).build(),
                  ),
                  const SizedBox(
                    height: 32.0,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          GetIt.I<AuthUseCase>()
                              .signInWithEmail(
                                  email: _emailController.text,
                                  password: _passwordController.text)
                              .then((_) =>
                                  context.goNamed(AppRoute.dashboardRouteName));
                        }
                      },
                      child: Text(AppLocalizations.of(context)!.signIn)),
                  const SizedBox(
                    height: 16.0,
                  ),
                  TextButton(
                      onPressed: () => context
                          .pushReplacementNamed(AppRoute.signUpRouteName),
                      child: Text(AppLocalizations.of(context)!.signUp)),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
