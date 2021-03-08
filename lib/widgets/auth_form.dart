import 'dart:io';

import 'package:chat/models/auth_data.dart';
import 'package:chat/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final Function(AuthData) onSubmit;

  const AuthForm(this.onSubmit);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _authData = AuthData();

  _submit() {
    FocusScope.of(context).unfocus();
    bool isValid = _formKey.currentState.validate();

    if (isValid) {
      widget.onSubmit(_authData);
    }
  }

  _onImageSelect(File image) {
    _authData.user.avatarImage = image;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (_authData.isSignUp) UserImagePicker(_onImageSelect),
                  if (_authData.isSignUp)
                    TextFormField(
                      key: ValueKey('name'),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Nome',
                      ),
                      onChanged: (value) => _authData.user.name = value.trim(),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe um nome.';
                        }
                        return null;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('email'),
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                    onChanged: (value) => _authData.user.email = value.trim(),
                    validator: (value) {
                      if (value == null || !value.contains('@')) {
                        return 'Informe um e-mail válido.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    key: ValueKey('password'),
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                    ),
                    onChanged: (value) =>
                        _authData.user.password = value.trim(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Informe uma senha';
                      } else if (value.length < 4) {
                        return 'Senha deve conter ao menos 4 caracteres.';
                      }
                      return null;
                    },
                  ),
                  if (_authData.isSignUp)
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirmar Senha',
                      ),
                      validator: (value) {
                        if (value != _authData.user.password) {
                          return 'Senhas não conferem.';
                        }
                        return null;
                      },
                    ),
                  SizedBox(height: 12.0),
                  RaisedButton(
                    onPressed: _submit,
                    child: Text(_authData.isSignIn ? 'Entrar' : 'Registrar'),
                  ),
                  FlatButton(
                    onPressed: () => setState(() => _authData.toggleMode()),
                    child: Text(_authData.isSignIn
                        ? 'Criar uma conta?'
                        : 'Já possui uma conta?'),
                    textColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
