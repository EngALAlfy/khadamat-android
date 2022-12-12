import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:khadamat_app/providers/AuthProvider.dart';
import 'package:provider/provider.dart';

class GoogleSignUpScreen extends StatefulWidget {
  final email;
  final name;

  GoogleSignUpScreen({this.email, this.name});

  @override
  _GoogleSignUpScreenState createState() => _GoogleSignUpScreenState();
}

class _GoogleSignUpScreenState extends State<GoogleSignUpScreen> {
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
                "#وظايفي",
                style: TextStyle(fontSize: 40),
              ),
              Text(
                "اكبر تجمع للوظايف بين ايديك",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(
                height: 20,
              ),
              usernameTextField(context, authProvider),
              SizedBox(
                height: 10,
              ),
              phoneTextField(context, authProvider),
              SizedBox(
                height: 10,
              ),
              nameTextField(context, authProvider),
              SizedBox(
                height: 10,
              ),
              emailTextField(context, authProvider),
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

  usernameTextField(context, authProvider) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: TextFormField(
          onSaved: (newValue) {
            authProvider.username = newValue;
          },
          validator: RequiredValidator(errorText: 'يرجي ادخال اسم المستخدم'),
          decoration: InputDecoration(
            isDense: true,
            labelText: "اسم المستخدم",
            labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(20)),
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
              FontAwesome.user,
            ),
          ),
          obscureText: false,
        ),
      ),
    );
  }

  nameTextField(context, usersProvider) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: TextFormField(
          enabled: false,
          initialValue: widget.name,
          keyboardType: TextInputType.name,
          validator: RequiredValidator(errorText: "ادخل الاسم"),
          decoration: InputDecoration(
            isDense: true,
            labelText: "الاسم",
            labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(20)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(20)),
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
              FontAwesome.user,
            ),
          ),
          obscureText: false,
        ),
      ),
    );
  }

  emailTextField(context, usersProvider) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: TextFormField(
          enabled: false,
          initialValue: widget.email,
          keyboardType: TextInputType.emailAddress,
          validator: MultiValidator([
            RequiredValidator(errorText: "ادخل البريد"),
            EmailValidator(errorText: "ادخل بريد صالح"),
          ]),
          decoration: InputDecoration(
            isDense: true,
            labelText: "البريد",
            labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(20)),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(20)),
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
              Icons.email,
            ),
          ),
          obscureText: false,
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
            usersProvider.phone = newValue;
          },
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null) {
              return "ادخل الهاتف";
            }

            if (value.isEmpty) {
              return "ادخل الهاتف";
            }

            if (usersProvider.countryCode == null) {
              return "ادخل الهاتف";
            }

            if (usersProvider.countryCode.isEmpty) {
              return "ادخل الهاتف";
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

            authProvider.signInWithGoogleAccount(context);
          },
          label: Text(
            "تسجيل",
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
