import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:homestay_app/src/common/route_manager.dart';
import 'package:homestay_app/src/common/widgets/build_button.dart';
import 'package:homestay_app/src/common/widgets/build_text_field.dart';
import 'package:homestay_app/src/features/auth/screens/auth_provider.dart';
import 'package:homestay_app/src/features/auth/screens/widgets/build_dialogs.dart';
import 'package:homestay_app/src/themes/export_themes.dart';
import 'package:homestay_app/src/themes/extensions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /// boolean variable to check if remember me is clicked or not
  bool _isChecked = false;

  late Box box1;

  @override
  void initState() {
    super.initState();
    createOpenBox();
  }

  /// create a box with this function below
  void createOpenBox() async {
    box1 = await Hive.openBox('loginData');
    getData();
  }


  /// gets the stored data from the box and assigns it to the controllers
  void getData() async {
    if (box1.get('username') != null) {
      _usernameController.text = box1.get('username');
      _isChecked = true;
      setState(() {});
    }
    if (box1.get('password') != null) {
      _passwordController.text = box1.get('password');
      _isChecked = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Login',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  BuildTextFormField(
                    controller: _usernameController,
                    labelText: 'Username',
                    textInputType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  BuildPasswordTextFormField(
                    labelText: 'Password',
                    textInputAction: TextInputAction.done,
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _isChecked,
                        onChanged: (value) {
                          _isChecked = !_isChecked;
                          removeLoginInfo();
                          setState(() {});
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                        activeColor: context.theme.colorScheme.primary,
                        checkColor: Colors.white,
                        side: const BorderSide(
                            color: AppColor.greyColor,
                            width: 1.4
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      SizedBox(width: 6,),
                      Text("Remember Me",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  Consumer(
                      builder: (context, ref, child) {
                        final authData = ref.watch(authProvider);
                        return BuildButton(
                          onPressed: () async{
                            if(_formKey.currentState!.validate()){
                              final navigator = Navigator.of(context);
                              buildLoadingDialog(context, "Logging in..");
                              login();
                              final response = await authData.login(
                                email: _usernameController.text.trim(),
                                password: _passwordController.text.trim(),
                              );
                              navigator.pop();
                              if(response != 'Login Successful'){
                                if(!context.mounted) return;
                                buildErrorDialog(context, response);
                              }else{
                                navigator.pushNamed(Routes.homeRoute);
                              }
                            }
                          },
                          buttonWidget: const Text('Login'),
                        );
                      }
                  ),
                  SizedBox(height: 60,),
                  Text(
                      'Don\'t have an account?',
                      style: Theme.of(context).textTheme.bodyMedium
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.pushNamed(context, Routes.registerRoute);
                    },
                    child: const Text('Create an account'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// adds the user info into (box) the local database (Hive)
  void login() {
    if (_isChecked) {
      box1.put('username', _usernameController.value.text);
      box1.put('password', _passwordController.value.text);
    }
  }

  /// clears the box or removes the stored credentials.
  void removeLoginInfo(){
    if(!_isChecked){
      box1.clear();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}