import 'package:dinendash/paths/authentication/validator.dart';
import 'package:dinendash/shared/constants.dart';
import 'package:dinendash/shared/loading_utils/loading.dart';
import 'package:dinendash/shared/loading_utils/snackBar.dart';
import 'package:flutter/material.dart';
import 'package:dinendash/services/auth.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignIn extends StatefulWidget {

  // Toggle function passed from authenticate.dart
  final Function toggleView;
  SignIn({ this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  // Loading widget toggle function
  bool loading = false;
  void toggleLoading() {
    setState(() => loading = !loading);
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: primary,
        title: Text('Login'),
        centerTitle: true,
      ),
      body: LoginForm(toggleView: widget.toggleView, toggleLoading: toggleLoading)
    );
  }
}

// Login Form Widget
class LoginForm extends StatefulWidget {

  // Pass toggle functions into LoginForm
  final Function toggleView;
  final Function toggleLoading;
  LoginForm({ this.toggleView, this.toggleLoading });

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final AuthService _auth = AuthService(); // Create Instance of AuthService
  final _formKey = GlobalKey<FormState>();

  // Text Field State
  String email = '';
  String password = '';
  String error = '';

  // Login
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget> [
            Align(
              heightFactor: 3.5,
              child: Center(
                child: Text(
                  'DineNDash',
                  style: TextStyle(
                    color: primary, fontSize: 50, fontWeight: FontWeight.bold, fontFamily: 'Ubuntu'
                  ),
                ),
              ),
            ),

            // Email Input
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.email),
                labelText: 'Email',
              ),
              autocorrect: false,
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
              validator: (val) => val.isEmpty ? 'Enter a password' : null,
              onChanged: (val) {
                setState(() => password = val);
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[

                  // Login Button
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: primary,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        Scaffold.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(loadingSnackBar('Logging In...'));
                        dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                        if (result == null) {
                          Scaffold.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(errorSnackBar('Could Not Sign In'));
                        }
                      }
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: background)
                    ),
                  ),

                  //Google Signin Button
                  RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    icon: Icon(FontAwesomeIcons.google, color: Colors.white),
                    onPressed: () async {
                      widget.toggleLoading();
                      dynamic result = await _auth.signInWithGoogle();
                      if (result == null) {
                        widget.toggleLoading();
                        Scaffold.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(errorSnackBar('Could not sign in'));
                      }
                    },
                    label: Text('Sign in with Google', style: TextStyle(color: Colors.white)),
                    color: Colors.redAccent,
                  ),

                  // Create Account Button
                  FlatButton(
                    child: Text('Create an Account'),
                    onPressed: () {
                      widget.toggleView();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class SignIn extends StatefulWidget {

//   // Toggle function passed from authenticate.dart
//   final Function toggleView;
//   SignIn({ this.toggleView });

//   @override
//   _SignInState createState() => _SignInState();
// }

// class _SignInState extends State<SignIn> {
//   bool _rememberMe = false;

//   Widget _buildEmailTF() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           'Email',
//           style: kLabelStyle,
//         ),
//         SizedBox(height: 10.0),
//         Container(
//           alignment: Alignment.centerLeft,
//           decoration: kBoxDecorationStyle,
//           height: 50.0,
//           child: TextField(
//             keyboardType: TextInputType.emailAddress,
//             style: TextStyle(
//               color: Colors.white,
//               fontFamily: 'OpenSans',
//             ),
//             decoration: InputDecoration(
//               border: InputBorder.none,
//               contentPadding: EdgeInsets.only(top: 14.0),
//               prefixIcon: Icon(
//                 Icons.email,
//                 color: Colors.white,
//               ),
//               hintText: 'Enter your Email',
//               hintStyle: kHintTextStyle,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildPasswordTF() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           'Password',
//           style: kLabelStyle,
//         ),
//         SizedBox(height: 10.0),
//         Container(
//           alignment: Alignment.centerLeft,
//           decoration: kBoxDecorationStyle,
//           height: 50.0,
//           child: TextField(
//             obscureText: true,
//             style: TextStyle(
//               color: Colors.white,
//               fontFamily: 'OpenSans',
//             ),
//             decoration: InputDecoration(
//               border: InputBorder.none,
//               contentPadding: EdgeInsets.only(top: 14.0),
//               prefixIcon: Icon(
//                 Icons.lock,
//                 color: Colors.white,
//               ),
//               hintText: 'Enter your Password',
//               hintStyle: kHintTextStyle,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildForgotPasswordBtn() {
//     return Container(
//       alignment: Alignment.centerRight,
//       child: FlatButton(
//         onPressed: () => print('Forgot Password Button Pressed'),
//         child: Text(
//           'Forgot Password?',
//           style: kLabelStyle,
//         ),
//       ),
//     );
//   }

//   Widget _buildRememberMeCheckbox() {
//     return Container(
//       height: 20.0,
//       child: Row(
//         children: <Widget>[
//           Theme(
//             data: ThemeData(unselectedWidgetColor: Colors.white),
//             child: Checkbox(
//               value: _rememberMe,
//               checkColor: Colors.green,
//               activeColor: Colors.white,
//               onChanged: (value) {
//                 setState(() {
//                   _rememberMe = value;
//                 });
//               },
//             ),
//           ),
//           Text(
//             'Remember me',
//             style: kLabelStyle,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoginBtn() {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 15.0),
//       width: double.infinity,
//       child: RaisedButton(
//         elevation: 5.0,
//         onPressed: () => print('Login Button Pressed'),
//         padding: EdgeInsets.all(15.0),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30.0),
//         ),
//         color: Colors.white,
//         child: Text(
//           'LOGIN',
//           style: TextStyle(
//             color: Color(0xFF527DAA),
//             letterSpacing: 1.5,
//             fontSize: 18.0,
//             fontWeight: FontWeight.bold,
//             fontFamily: 'OpenSans',
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSignInWithText() {
//     return Column(
//       children: <Widget>[
//         Text(
//           '- OR -',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//         SizedBox(height: 15.0),
//         Text(
//           'Sign in with',
//           style: kLabelStyle,
//         ),
//       ],
//     );
//   }

//   Widget _buildSocialBtn(Function onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 60.0,
//         width: 60.0,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black26,
//               offset: Offset(0, 2),
//               blurRadius: 6.0,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSocialBtnRow() {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: <Widget>[
//           _buildSocialBtn(
//             () => print('Login with Facebook'),
            
//           ),
//           _buildSocialBtn(
//             () => print('Login with Google'),
            
//           ),
//         ],
//       ),
      
//     );
//   }

//   Widget _buildSignupBtn() {
//     return GestureDetector(
//       onTap: () => print('Sign Up Button Pressed'),
//       child: RichText(
//         text: TextSpan(
//           children: [
//             TextSpan(
//               text: 'Don\'t have an Account? ',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//             TextSpan(
//               text: 'Sign Up',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: AnnotatedRegion<SystemUiOverlayStyle>(
//         value: SystemUiOverlayStyle.light,
//         child: GestureDetector(
//           onTap: () => FocusScope.of(context).unfocus(),
//           child: Stack(
//             children: <Widget>[
//               Container(
//                 height: double.infinity,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       Color(0xFF73AEF5),
//                       Color(0xFF61A4F1),
//                       Color(0xFF478DE0),
//                       Color(0xFF398AE5),
//                     ],
//                     stops: [0.1, 0.4, 0.7, 0.9],
//                   ),
//                 ),
//               ),
//               Container(
//                 height: double.infinity,
//                 child: SingleChildScrollView(
//                   physics: AlwaysScrollableScrollPhysics(),
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 40.0,
//                     vertical: 100.0,
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Text(
//                         'Sign In',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 27.0,
//                           fontWeight: FontWeight.w600,
//                           fontFamily: 'OpenSans',
//                         ),
//                       ),
//                       SizedBox(height: 30.0),
//                       _buildEmailTF(),
//                       SizedBox(
//                         height: 20.0,
//                       ),
//                       _buildPasswordTF(),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           _buildRememberMeCheckbox(),
//                           _buildForgotPasswordBtn(),
//                         ],
//                       ),
//                       _buildLoginBtn(),
//                       _buildSignInWithText(),
//                       _buildSocialBtnRow(),
//                       _buildSignupBtn(),
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }