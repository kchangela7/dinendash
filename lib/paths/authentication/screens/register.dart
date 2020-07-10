import 'package:dinendash/paths/authentication/validator.dart';
import 'package:dinendash/shared/constants.dart';
import 'package:dinendash/shared/loading_utils/snackBar.dart';
import 'package:flutter/material.dart';
import 'package:dinendash/services/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';

class Register extends StatefulWidget {

  // Toggle Function passed from Authenticate.dart
  final Function toggleView;
  Register({ this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text('Register'),
        centerTitle: true,
      ),
      body: RegisterForm(toggleView: widget.toggleView),
    );
  }
}

// Register Form
class RegisterForm extends StatefulWidget {

  // Pass toggle function into RegisterForm
  final Function toggleView;
  RegisterForm({ this.toggleView });

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {

  final AuthService _auth = AuthService(); // Create instance of AuthService
  final _formKey = GlobalKey<FormState>();

  // text field state
  String name = '';
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Align(
              heightFactor: 2,
              child: Icon(
                FontAwesomeIcons.pencilAlt,
                color: primary,
                size: 70
              ),
            ),

            // Name Input
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Name',
              ),
              validator: RequiredValidator(errorText: 'name is required'),
              onChanged: (val) {
                setState(() => name = val);
              },
            ),

            // Email Input
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.email),
                labelText: 'Email',
              ),
              validator: emailValidator,
              onChanged: (val) {
                setState(() => email = val);
              },
            ),

            // Password Input
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.lock),
                labelText: 'Password',
              ),
              obscureText: true,
              autocorrect: false,
              validator: passwordValidator,
              onChanged: (val) {
                setState(() => password = val);
              },
            ),

            // Confirm Password Input
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.lock),
                labelText: 'Confirm Password',
              ),
              obscureText: true,
              autocorrect: false,
              validator: (val) => MatchValidator(errorText: 'passwords do not match')
                .validateMatch(val, password)
            ),
            SizedBox(height: 12.0),

            // Register Button
            RaisedButton(
              color: primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              onPressed: () async {
                if (_formKey.currentState.validate()) { //Check validation
                  Scaffold.of(context) // Display Loading SnackBar
                  ..hideCurrentSnackBar()
                  ..showSnackBar(loadingSnackBar('Loading...'));
                  // Attempt Register from Auth.dart
                  dynamic result = await _auth.signUpWithEmailAndPassword(email: email, password: password);
                  if (result == null) {
                    Scaffold.of(context) // Display Error SnackBar
                    ..hideCurrentSnackBar()
                    ..showSnackBar(errorSnackBar('Could Not Register'));
                  }
                }
              },
              child: Text(
                'Register',
                style: TextStyle(color: background)
              ),
            ),

            // Return to S Button
            FlatButton(
              child: Text('Return to Sign In'),
              onPressed: () {
                widget.toggleView();
              },
            ),
          ],
        ),
      ),
    );
  }
}