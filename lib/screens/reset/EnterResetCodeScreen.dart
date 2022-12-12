import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:khadamat_app/providers/AuthProvider.dart';
import 'package:provider/provider.dart';

class EnterResetCodeScreen extends StatefulWidget {
  final bool verify;

  const EnterResetCodeScreen({Key key, this.verify = false}) : super(key: key);

  @override
  _EnterResetCodeScreenState createState() => _EnterResetCodeScreenState();
}

class _EnterResetCodeScreenState extends State<EnterResetCodeScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    if(widget.verify){
      authProvider.sendPhoneVerifiedCode(context);
    }

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
                widget.verify ? "تأكيد الهاتف" : "استعادة كلمة السر",
                style: TextStyle(fontSize: 40),
              ),
              Text(
                "ادخل الكود المرسل اليك",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(
                height: 20,
              ),
              codeTextField(context, authProvider),
              SizedBox(
                height: 10,
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

  codeTextField(context, AuthProvider usersProvider) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: TextFormField(
          onSaved: (newValue) {
            usersProvider.verificationCode = newValue;
          },
          keyboardType: TextInputType.text,
          validator: RequiredValidator(
              errorText: EzLocalization.of(context).get("enter_code")),
          decoration: InputDecoration(
            isDense: true,
            labelText: "الكود",
            labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.redAccent),
                borderRadius: BorderRadius.circular(20)),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red[300]),
                borderRadius: BorderRadius.circular(20)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(20)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                    color: Theme.of(context).accentColor, width: 1.0)),
            prefixIcon: const Icon(
              FontAwesome.phone,
            ),
          ),
          obscureText: false,
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
            FontAwesome.sign_in,
            color: Colors.grey,
          ),
          onPressed: () {
            if (!_formKey.currentState.validate()) {
              return;
            }

            _formKey.currentState.save();

            if (widget.verify) {
              authProvider.verifyPhoneCode(context);
            } else {
              authProvider.resetPassword(context);
            }
          },
          label: Text(
            "تأكيد",
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
