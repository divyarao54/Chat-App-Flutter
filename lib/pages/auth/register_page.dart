import "package:chat_app/helper/helper_function.dart";
import "package:chat_app/pages/auth/login_page.dart";
import "package:chat_app/pages/home_page.dart";
import "package:chat_app/service/auth_service.dart";
import "package:flutter/material.dart";
import "package:chat_app/widgets/widgets.dart";
import "package:flutter/gestures.dart";

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String fullName = "";
  String password = "";
  bool isLoading = false;
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfffefe),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
            child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Chat App",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1d3f6f)),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                        "Dive into the world of connections! Sign up today and start building your network of possibilities.",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF1d3f6f))),
                    Image.asset("assets/register_page.jpg"),
                    TextFormField(
                      style: const TextStyle(color: Color(0xFF1d3f6f)),
                      decoration: textInputDecoration2.copyWith(
                          labelText: "Full Name",
                          prefixIcon: Icon(
                            Icons.person,
                            color: Theme.of(context).primaryColorDark,
                          )),
                      onChanged: (value) {
                        setState(() {
                          fullName = value;
                        });
                      },
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        } else {
                          return "Name cannot be empty";
                        }
                      },
                    ),
                    const SizedBox(height: 15.0),
                    TextFormField(
                      style: const TextStyle(color: Color(0xFF1d3f6f)),
                      decoration: textInputDecoration2.copyWith(
                          labelText: "Email",
                          prefixIcon: Icon(
                            Icons.email,
                            color: Theme.of(context).primaryColorDark,
                          )),
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                      validator: (value) {
                        return RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value!)
                            ? null
                            : "Please enter a valid Email";
                      },
                    ),
                    const SizedBox(height: 15.0),
                    TextFormField(
                      style: const TextStyle(color: Color(0xFF1d3f6f)),
                      obscureText: true,
                      decoration: textInputDecoration2.copyWith(
                          labelText: "Password",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Theme.of(context).primaryColorDark,
                          )),
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return "Please enter your password";
                        } else if (value.length < 6) {
                          return "Password must be alteast 6 characters";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1d3f6f),
                                foregroundColor: Colors.white,
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            onPressed: () {
                              register();
                            },
                            child: const Text("Sign Up"))),
                    const SizedBox(
                      height: 10,
                    ),
                    Text.rich(TextSpan(
                        text: "Already have an account?",
                        style: const TextStyle(
                            color: Color(0xFF1d3f6f), fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              text: "Login here",
                              style: const TextStyle(
                                color: Color(0xFFfb9373),
                                decorationThickness: double.minPositive,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  nextScreen(context, const LoginPage());
                                }),
                        ]))
                  ],
                ))),
      ),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await authService
          .registerUserWithEmailAndPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
          // ignore: use_build_context_synchronously
          nextScreenReplace(context, const HomePage());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }
}
