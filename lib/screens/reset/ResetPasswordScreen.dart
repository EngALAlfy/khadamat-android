import 'package:country_picker/country_picker.dart';
import 'package:ez_localization/ez_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:khadamat_app/providers/AuthProvider.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

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
                "استعادة كلمة السر",
                style: TextStyle(fontSize: 40),
              ),
              Text(
                "ادخل رقم الهاتف وسوف يتم ارسال رسالك استعادة اليك",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(
                height: 20,
              ),
              phoneTextField(context, authProvider),
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

  phoneTextField(context, usersProvider) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: TextFormField(
          onSaved: (newValue) {
            usersProvider.resetPhone = newValue;
          },
          keyboardType: TextInputType.phone,
          validator: (value){
            if(value == null){
              return "ادخل الهاتف";
            }

            if(value.isEmpty){
              return "ادخل الهاتف";
            }

            if(usersProvider.countryCode == null){
              return "اختر كود الدولة";
            }

            if(usersProvider.countryCode.isEmpty){
              return "اختر كود الدولة";
            }
            return null;
          },
          decoration: InputDecoration(
            isDense: true,
            labelText: "الهاتف",
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
            suffixIcon: TextButton(
              onPressed: () {
                showCountryPicker(
                  context: context,
                  showPhoneCode: true,
                  onSelect: (value) {
                    usersProvider.countryName = value.displayName;
                    usersProvider.countryCode = value.phoneCode;
                  },
                );
              },
              child: Consumer<AuthProvider>(
                builder: (context, value, child) =>
                    Text(value.countryName == null ? "N/A" : value.countryName),
              ),
            ),
          ),
          obscureText: false,
        ),
      ),
    );
  }

  loginBtn(context,AuthProvider authProvider) {
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

            authProvider.sendResetPasswordCode(context);
          },
          label: Text(
            "ارسال",
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
