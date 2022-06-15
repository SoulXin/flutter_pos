import 'package:flutter/material.dart';
import '/screens/SplashScreen.dart';
import '../utils/StorageToken.dart';
import 'package:provider/provider.dart';
import '../providers/Auth.dart';

enum AuthMode { Register, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: deviceSize.width > 600 ? 2 : 1,
                child: AuthCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'username': '',
    'password': '',
  };
  var _isLoading = false;
  var _checkToken = false;

  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  Future checkToken() async {
    String token = await StorageToken.getToken() ?? '';
    if (token.isNotEmpty) {
      Provider.of<Auth>(context, listen: false).setUser(token: token);
      setState(() {
        _checkToken = true;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occured!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
          _authData['username'] as String,
          _authData['password'] as String,
        );
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).register(
          _authData['username'] as String,
          _authData['password'] as String,
        );
      }
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Register;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: TextStyle(fontSize: 15),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    return _checkToken
        ? SplashScreen()
        : Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 8.0,
            child: Container(
              height: _authMode == AuthMode.Register ? 350 : 260,
              constraints: BoxConstraints(
                  minHeight: _authMode == AuthMode.Register ? 320 : 260),
              width: deviceSize.width * 0.75,
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Invalid username!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['username'] = value as String;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      controller: _passwordController,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 5) {
                          return 'Password is too short!';
                        }
                      },
                      onSaved: (value) {
                        _authData['password'] = value as String;
                      },
                    ),
                    if (_authMode == AuthMode.Register)
                      TextFormField(
                        enabled: _authMode == AuthMode.Register,
                        decoration:
                            InputDecoration(labelText: 'Confirm Password'),
                        obscureText: true,
                        validator: _authMode == AuthMode.Register
                            ? (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match!';
                                }
                              }
                            : null,
                      ),
                    if (_isLoading)
                      CircularProgressIndicator()
                    else
                      Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              ElevatedButton(
                                child: Text(_authMode == AuthMode.Login
                                    ? 'Login'
                                    : 'Register'),
                                onPressed: _submit,
                                style: style,
                              ),
                              ElevatedButton(
                                child: Text(
                                    '${_authMode == AuthMode.Login ? 'Register' : 'Login'} Instead'),
                                onPressed: _switchAuthMode,
                                style: style,
                              ),
                            ]),
                      )
                  ],
                ),
              ),
            ),
          );
  }
}
