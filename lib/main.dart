import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mad_project_ecommerce/BottomnavigationBar/BottomnavigationBar.dart';
import 'package:mad_project_ecommerce/SaadProject/HomeScreen.dart';

import 'AuthServics/AuthServics.dart';
import 'Controllers/controllers.dart';
import 'Screens/ForgotPasswordRecovery/passrecovery.dart';
import 'Screens/SignUp/SignUp.dart';
import 'firebase_options.dart';

class circular extends GetxController {
  var isLod = false.obs;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
              elevation: 0, backgroundColor: Colors.white, centerTitle: true)),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return BottomNavigationBarWidget();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  passwordObscure okobscure = Get.put(passwordObscure());
  circular loading = Get.put(circular());

  Future<void> loginProcess() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      Get.snackbar('', '',
          titleText: const Text(
            'Failed',
            style: TextStyle(color: Colors.white),
          ),
          messageText: const Text(
            'All fields are required to login',
            style: TextStyle(color: Colors.white),
          ),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          snackStyle: SnackStyle.GROUNDED);
    } else {
      try {
        loading.isLod.value = true;
        FocusScope.of(context).unfocus();
        await AuthSevices()
            .Login(_usernameController.text, _passwordController.text);
        loading.isLod.value = false;
      } catch (e) {
        Get.snackbar('', '',
            titleText: const Text(
              'Failed',
              style: TextStyle(color: Colors.white),
            ),
            messageText: Text(
              e.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            snackStyle: SnackStyle.GROUNDED);
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Login Page',
          style: TextStyle(color: Colors.black, fontSize: 23),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 220,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/check.png'),
                        fit: BoxFit.contain)),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.7,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 2, right: 2),
                      child: Text(
                        "Enter credentials to Login",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.7,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: AbsorbPointer(
                  absorbing: loading.isLod.value ? true : false,
                  child: TextField(
                    controller: _usernameController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25)),
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: AbsorbPointer(
                  absorbing: loading.isLod.value ? true : false,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: okobscure.Isobscure.value,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          okobscure.Isobscure.toggle();
                        },
                        icon: Icon(okobscure.Isobscure.value
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                      labelText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25)),
                      prefixIcon: const Icon(Icons.lock),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const PasswordRecovery(),
                            transition: Transition.cupertino);
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: GestureDetector(
                  onTap: loginProcess,
                  child: loading.isLod.value
                      ? const CircularProgressIndicator(
                          color: Colors.green,
                        )
                      : Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(21)),
                          padding: const EdgeInsets.all(9),
                          child: const Center(
                            child: Text(
                              "Login",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 19),
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.7,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 2, right: 2),
                      child: Text(
                        "Or use Login method",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.7,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AbsorbPointer(
                    absorbing: loading.isLod.value ? true : false,
                    child: GestureDetector(
                      onTap: () async {
                        await Firebase.initializeApp();
                        await AuthSevices().googelSignIn();
                      },
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage('images/google.png'),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Not a member?",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  AbsorbPointer(
                    absorbing: loading.isLod.value ? true : false,
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => const SignUp(),
                            transition: Transition.cupertino);
                      },
                      child: const Text(
                        "click here to Register!",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )),
      ),
    );
  }
}
