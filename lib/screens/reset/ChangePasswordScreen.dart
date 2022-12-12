import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:khadamat_app/providers/AuthProvider.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  final bool reset;
  final id;

  const ChangePasswordScreen({Key key, this.reset = false, this.id}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 150,
              ),
              Text(
                "تغيير كلمة السر",
                style: TextStyle(fontSize: 40),
              ),
              Text(
                "اختر كلمة سر جديده لحسابك",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(
                height: 20,
              ),
              passwordTextField(context, authProvider),
              SizedBox(
                height: 5,
              ),
              loginBtn(context, authProvider),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  passwordTextField(context, AuthProvider authProvider) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(right: 20, left: 20, bottom: 10),
        child: TextFormField(
          validator: RequiredValidator(errorText: 'يرجي ادخال كلمة السر'),
          onSaved: (newValue) {
            if (widget.reset) {
              authProvider.resetedPassword = newValue;
            } else {
              authProvider.changedPassword = newValue;
            }
          },
          obscureText: true,
          decoration: InputDecoration(
            isDense: true,
            labelText: "كلمة السر الجديدة",
            labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
            hintStyle: TextStyle(fontSize: 14),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey, width: 1.0)),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.redAccent),
                borderRadius: BorderRadius.circular(20)),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red[300]),
                borderRadius: BorderRadius.circular(20)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                    color: Theme.of(context).accentColor, width: 1.0)),
            prefixIcon: const Icon(
              Icons.lock,
            ),
          ),
        ),
      ),
    );
  }

  loginBtn(context, AuthProvider authProvider) {
    return Container(
      width: 200,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Padding(
        padding: EdgeInsets.only(),
        child: FlatButton.icon(
          icon: Icon(
            FontAwesome.save,
            color: Colors.grey,
          ),
          onPressed: () {
            if (!_formKey.currentState.validate()) {
              return;
            }

            _formKey.currentState.save();

            if(widget.reset){
              authProvider.changeResetPassword(context);
            }else{
              authProvider.changeNewPassword(context , widget.id);
            }

          },
          label: Text(
            "تغيير",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
