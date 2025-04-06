import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

import '../../../../core/generated/i18n/app_localizations.dart';

class PasswordChangeScreen extends StatefulWidget {
  const PasswordChangeScreen({super.key});

  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _oldPaswordVisible = false;
  bool _newPaswordVisible = false;
  bool _confirmPaswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
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
                      AppLocalizations.of(context)!.changePassword,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 46.0,
                    ),
                    TextFormField(
                      controller: _oldPasswordController,
                      decoration: InputDecoration(
                          label:
                              Text(AppLocalizations.of(context)!.oldPassword),
                          icon: const Icon(Icons.password),
                          suffixIcon: IconButton(
                              onPressed: () => setState(() {
                                    _oldPaswordVisible = !_oldPaswordVisible;
                                  }),
                              icon: Icon(_oldPaswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility))),
                      obscureText: !_oldPaswordVisible,
                      keyboardType: TextInputType.visiblePassword,
                      validator: ValidationBuilder().minLength(6).build(),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _newPasswordController,
                      decoration: InputDecoration(
                          label:
                              Text(AppLocalizations.of(context)!.newPassword),
                          icon: const Icon(Icons.password),
                          suffixIcon: IconButton(
                              onPressed: () => setState(() {
                                    _newPaswordVisible = !_newPaswordVisible;
                                  }),
                              icon: Icon(_newPaswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility))),
                      obscureText: !_newPaswordVisible,
                      keyboardType: TextInputType.visiblePassword,
                      validator: ValidationBuilder().minLength(6).build(),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        label:
                            Text(AppLocalizations.of(context)!.changePassword),
                        icon: const Icon(Icons.password),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() {
                            _confirmPaswordVisible = !_confirmPaswordVisible;
                          }),
                          icon: Icon(_confirmPaswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                      ),
                      obscureText: !_confirmPaswordVisible,
                      keyboardType: TextInputType.visiblePassword,
                      validator: ValidationBuilder().minLength(6).build(),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(AppLocalizations.of(context)!.changePassword),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
