import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/app_route.dart';
import '../../../../core/cubits/application_cubit.dart';
import '../../../../core/generated/i18n/app_localizations.dart';
import '../../../../domain/exceptions/auth_exception.dart';
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
          child: BlocBuilder<ApplicationCubit, ApplicationState>(
            buildWhen: (previous, current) =>
                current is ExceptionOccurred && exception is AuthException,
            builder: (context, state) {
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  constraints: const BoxConstraints(maxWidth: 400.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (state.exception is AuthException)
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
                        height: 8.0,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => context
                              .pushNamed(AppRoute.restorePasswordRouteName),
                          child: Text(
                              AppLocalizations.of(context)!.passwordRestore),
                        ),
                      ),
                      const SizedBox(
                        height: 22.0,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              final goRouter = GoRouter.of(context);
                              GetIt.I<AuthUseCase>()
                                  .signInWithEmail(
                                      email: _emailController.text,
                                      password: _passwordController.text)
                                  .then((_) => goRouter
                                      .goNamed(AppRoute.dashboardRouteName));
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
              );
            },
          ),
        ),
      )),
    );
  }
}
