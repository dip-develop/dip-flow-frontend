import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/app_route.dart';
import '../../../../core/cubits/application_cubit.dart';
import '../../../../domain/exceptions/auth_exception.dart';
import '../../../../domain/usecases/usecases.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _paswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Form(
        key: _formKey,
        child: Center(
          child: BlocBuilder<ApplicationCubit, ApplicationState>(
            buildWhen: (previous, current) =>
                current is ExceptionOccurred &&
                current.exception is AuthException,
            builder: (context, state) {
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  constraints: const BoxConstraints(maxWidth: 400.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (state.exception != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            (state.exception as AuthException).message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                          ),
                        ),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          label: Text(AppLocalizations.of(context)!.name),
                          icon: const Icon(Icons.person),
                        ),
                        keyboardType: TextInputType.name,
                        validator: ValidationBuilder().required().build(),
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
                                  .signUpWithEmail(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      name: _nameController.text)
                                  .then((_) => context
                                      .goNamed(AppRoute.dashboardRouteName));
                            }
                          },
                          child: Text(AppLocalizations.of(context)!.signUp)),
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
              );
            },
          ),
        ),
      )),
    );
  }
}
