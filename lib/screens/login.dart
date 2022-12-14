import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qadamv2/util/user_secure_storage.dart';
import 'package:qadamv2/util/user_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/users_services.dart';
import '../theme.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _loginFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final storage = FlutterSecureStorage();
  bool isLogging = false;
  bool hasError = false;

  _loginAccount() async {
    setState(() {
      isLogging = true;
    });
    final body = {
      "Email": emailController.text,
      "password": passwordController.text
    };

    UserService.login(body);
    final ans = await UserService.login(body);
    if (ans) {
      final user=await UserService.validateUser();
      UserSharedPreferences.setUserData(user);
      Navigator.of(context).pushReplacementNamed('/home');
      setState(() {
        hasError = false;
        isLogging = false;
      });
    } else {
      setState(() {
        hasError = true;
        isLogging = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: isLogging
            ? CircularProgressIndicator()
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                child: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 45),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: size.width * 0.15,
                                child: Image.asset("assets/images/qadam.jpg"),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Qadam',
                                style: QadamTheme.textTheme.headline1,
                              )
                            ],
                          ),
                          const SizedBox(height: 55),
                          if (hasError) ...[
                            Text(
                              'wrong email or password',
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                          ],
                          Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0.5,
                                    blurRadius: 2,
                                    offset: Offset(0, 0.1),
                                  )
                                ],
                                color: QadamTheme.textColor02,
                                border: Border.all(
                                    color: QadamTheme.textColor03, width: 0.5),
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 10),
                              child: TextField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                focusNode: _loginFocus,
                                style: TextStyle(color: QadamTheme.textColor04),
                                onSubmitted: (String text) {
                                  _passwordFocus.requestFocus();
                                },
                                obscureText: false,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Email',
                                  hintStyle: TextStyle(
                                      color: QadamTheme.textColor04,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          Container(
                            decoration: BoxDecoration(
                                color: QadamTheme.textColor02,
                                border: Border.all(
                                    color: QadamTheme.textColor03, width: 0.5),
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 10),
                              child: TextField(
                                style: TextStyle(color: QadamTheme.textColor04),
                                controller: passwordController,
                                focusNode: _passwordFocus,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                      color: QadamTheme.textColor04,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await _loginAccount();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: QadamTheme.textColor05,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100))),
                              width: double.infinity,
                              child: const Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: Text(
                                    "Log In",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacementNamed('/signup');
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'Create account',
                                style: TextStyle(
                                    color: QadamTheme.textColor05,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
