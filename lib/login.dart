import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class login extends StatefulWidget {
  final void Function()? onPressed;
  final void Function()? onPressed2;
  const login({super.key, required this.onPressed, required this.onPressed2});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _password = true;
  bool _loading = false;
  Future signIn() async {
    try {
      setState(() {
        _loading = true;
      });

      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
    } catch (e) {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) {
            return const CupertinoAlertDialog(
              content: Text(
                'Enter a Valid Email Id',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            );
          });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        // Container(
        //   constraints: const BoxConstraints.expand(),
        //   width: double.infinity,
        //   decoration: const BoxDecoration(
        //     image: DecorationImage(
        //       image: AssetImage("assets/P.png"),
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 150),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 210),
                child: Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[800]),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 120),
                child: Text(
                  "Please Sign in to continue",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.blueGrey),
                ),
              ),
              const SizedBox(
                height: 55,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                    hintText: 'Enter Email-Id',
                    prefixIcon: const Icon(Icons.mail),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(_password
                            ? Icons.visibility_off
                            : Icons.visibility),
                        color: Colors.grey.shade600,
                        onPressed: () {
                          setState(() {
                            _password = !_password;
                          });
                        }),
                    hintText: 'Enter Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 39),
                    child: TextButton(
                        onPressed: widget.onPressed2,
                        child: Text('Forgot Password?',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600))),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(),
                    child: SizedBox(
                      height: 60,
                      width: 130,
                      child: ElevatedButton(
                          onPressed: _loading
                              ? null
                              : () {
                                  if (_passwordController.text.isNotEmpty &&
                                      _emailController.text.isNotEmpty) {
                                    setState(() {
                                      signIn();
                                    });
                                    // ignore: avoid_print
                                    print("success");
                                  } else {
                                    // ignore: avoid_print
                                    const AlertDialog(actions: [
                                      Text('Please enter both fields')
                                    ]);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[100],
                              foregroundColor: Colors.white,

                              //  shadowColor: Colors.greenAccent,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  //side: BorderSide(width: 2),
                                  borderRadius: BorderRadius.circular(30.0)),
                              minimumSize: const Size(100, 40)),
                          child: _loading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black),
                                )
                              : Row(
                                  children: [
                                    Text('Login',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600)),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.black,
                                    )
                                  ],
                                )),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 180,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 70),
                child: Row(
                  children: [
                    const Text(
                      'Need an account ?',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    TextButton(
                        onPressed: widget.onPressed,
                        child: const Text(
                          'Sign-Up',
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w600),
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
