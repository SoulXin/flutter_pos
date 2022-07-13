import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/models/MessageException.dart';
import 'package:mobile/widgets/ShowDialog.dart';
import '/screens/SplashScreen.dart';
import '../utils/StorageToken.dart';
import 'package:provider/provider.dart';
import '../providers/Auth.dart';

enum AuthMode { Register, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
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
  static const storage = FlutterSecureStorage();

  AuthMode _authMode = AuthMode.Login;
  final Map<String, String> _authData = {
    'username': '',
    'password': '',
  };
  var _isLoading = false;
  var _checkToken = true;

  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  void checkToken() async {
    String token = await StorageToken.getToken() ?? '';

    if (token.isNotEmpty) {
      if (!mounted) return;

      try {
        await Provider.of<Auth>(context, listen: false).setUser(token: token);
      } on MessageException catch (error) {
        if (error.message.contains('Unauthenticated')) {
          await storage.deleteAll();
        }

        if (!mounted) return;
        showErrorDialog(context, error.message);
      } catch (error) {
        showErrorDialog(context, error.toString());
      }
    }

    setState(() {
      _checkToken = false;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occured!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
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
      textStyle: const TextStyle(fontSize: 15),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    return _checkToken
        ? const SplashScreen()
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
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Username'),
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
                      decoration: const InputDecoration(labelText: 'Password'),
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
                        decoration: const InputDecoration(
                            labelText: 'Confirm Password'),
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
                      const CircularProgressIndicator()
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: _submit,
                            style: style,
                            child: Text(_authMode == AuthMode.Login
                                ? 'Login'
                                : 'Register'),
                          ),
                          ElevatedButton(
                            onPressed: _switchAuthMode,
                            style: style,
                            child: Text(
                                '${_authMode == AuthMode.Login ? 'Register' : 'Login'} Instead'),
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ),
          );
  }
}
