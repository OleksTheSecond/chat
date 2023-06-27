import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.sumbitFn, this.isLoading);

  final bool isLoading;
  final void Function(String email, String login, String password, bool isLogin,
      BuildContext ctx) sumbitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var isLogin = true;
  String _userEmail = "";
  String _userName = "";
  String _userPassword = "";

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (isValid != null) {
      if (isValid) {
        _formKey.currentState?.save();
        widget.sumbitFn(_userEmail.trim(), _userName.trim(),
            _userPassword.trim(), isLogin, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      margin: EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(13),
          child: Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextFormField(
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
                enableSuggestions: false,
                key: ValueKey('email'),
                validator: (value) {
                  if (value != null) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Введіть електрону пошту';
                    }
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "Email"),
                onSaved: (value) {
                  _userEmail = value!;
                },
              ),
              if (!isLogin)
                TextFormField(
                  autocorrect: true,
                  textCapitalization: TextCapitalization.words,
                  enableSuggestions: false,
                  key: ValueKey('username'),
                  validator: (value) {
                    if (value != null) {
                      if (value.isEmpty || value.length < 3) {
                        return 'Введіть коректний логін';
                      }
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Login'),
                  onSaved: (value) {
                    _userName = value!;
                  },
                ),
              TextFormField(
                key: ValueKey('password'),
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (value) {
                  _userPassword = value!;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              if (widget.isLoading) CircularProgressIndicator(),
              if (!widget.isLoading)
                FilledButton.tonal(
                    onPressed: _trySubmit,
                    child: Text(isLogin ? 'Ввійти' : 'Зареєструватись')),
              if (!widget.isLoading)
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
                  child: Text(isLogin ? 'Реєстрація' : 'B мене вже є аккаунт'),
                ),
            ]),
          ),
        ),
      ),
    ));
  }
}
