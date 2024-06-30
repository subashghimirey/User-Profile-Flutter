import 'package:authentication/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:authentication/auth.dart';
import 'package:authentication/validators.dart';

class CustomForm extends StatefulWidget {
  const CustomForm({super.key});

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loginActive = true;
  final auth = Auth();
  final validator = Validators();
  String errorMessage = '';
  bool _agreeTerms = false;

  void change() {
    setState(() {
      _loginActive = !_loginActive;
      errorMessage = '';
      _formKey.currentState!.reset();
      emailController.clear();
      passwordController.clear();
      nameController.clear();
      _agreeTerms = false;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome to GG",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 45),
                ),
                const SizedBox(
                  height: 40,
                ),
                _loginActive
                    ? const SizedBox(
                        height: 2,
                      )
                    : TextFormField(
                        validator: (value) =>
                            validator.validateName(name: value!),
                        controller: nameController,
                        decoration: const InputDecoration(
                            hintText: "Your Name",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                      ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  validator: (value) => validator.validateEmail(email: value!),
                  controller: emailController,
                  decoration: const InputDecoration(
                      hintText: "yourgmail@gmail.com",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  validator: (value) =>
                      validator.validatePassword(password: value!),
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                ),
                const SizedBox(
                  height: 17,
                ),
                if (errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                _loginActive
                    ? const SizedBox(
                        height: 0,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _agreeTerms,
                            onChanged: (bool? value) {
                              setState(() {
                                _agreeTerms = value!;
                              });
                            },
                            checkColor: Colors.blue,
                            activeColor: Colors.white,
                          ),
                          const Text(
                            "I agree to all Terms, Privacy Policy",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                Container(
                  margin: const EdgeInsets.all(15),
                  width: double.infinity,
                  child: _loginActive
                      ? ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                var user =
                                    await auth.loginUsingEmailAndPassword(
                                        email: emailController.text,
                                        password: passwordController.text);

                                if (user != null) {
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                    builder: (context) => HomeScreen(
                                      user: user,
                                    ),
                                  ));
                                } else {
                                  setState(() {
                                    errorMessage = 'Invalid login credentials';
                                  });
                                }
                              } catch (e) {
                                setState(() {
                                  errorMessage =
                                      "Enter valid credentials to login";
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 48, 153, 239),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 15)),
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w700),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (!_agreeTerms) {
                                setState(() {
                                  errorMessage =
                                      "Please agree to privacy policies and terms";
                                });
                              } else {
                                try {
                                  var user =
                                      await auth.registerUsingEmailAndPassword(
                                          name: nameController.text,
                                          email: emailController.text,
                                          password: passwordController.text);

                                  if (user != null) {
                                    setState(() {
                                      _loginActive = !_loginActive;
                                      errorMessage = '';
                                    });
                                  }
                                } catch (e) {
                                  setState(() {
                                    errorMessage = "Email Already Used!!";
                                  });
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 48, 153, 239),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 15)),
                          child: const Text(
                            "Create Now",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w700),
                          ),
                        ),
                ),
                _loginActive
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Forgot details?",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Reset here",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 18),
                              ))
                        ],
                      )
                    : const SizedBox(
                        height: 2,
                      ),
                _loginActive
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          TextButton(
                              onPressed: change,
                              child: const Text(
                                "Sign Up Now",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 18),
                              ))
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          TextButton(
                              onPressed: change,
                              child: const Text(
                                "Login Now",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 18),
                              ))
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
