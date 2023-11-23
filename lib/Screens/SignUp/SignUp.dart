import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../AuthServics/AuthServics.dart';
import '../../Controllers/controllers.dart';

class circularSignUp extends GetxController {
  var isLod = false.obs;
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  final TextEditingController _email = TextEditingController();
  bool isobscure = true;
  circularSignUp sig = Get.put(circularSignUp());
  final TextEditingController _passwordController = TextEditingController();
  passwordObscure obscure = Get.put(passwordObscure());
  bottomSelecter newvalue = Get.put(bottomSelecter());
  Future<void> signUpProcess() async {
    if (_usernameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _email.text == "" ||
        newvalue.selected.value == "") {
      Get.snackbar('', '',
          titleText: Text(
            'Failed',
            style: TextStyle(color: Colors.white),
          ),
          messageText: Text(
            'All fields are required to login',
            style: TextStyle(color: Colors.white),
          ),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
          snackStyle: SnackStyle.GROUNDED);
    }
    if (_passwordController.text != _confirm.text) {
      Get.snackbar('', '',
          titleText: Text(
            'Failed',
            style: TextStyle(color: Colors.white),
          ),
          messageText: Text(
            'Both passwords must match',
            style: TextStyle(color: Colors.white),
          ),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
          snackStyle: SnackStyle.GROUNDED);
    } else {
      try {
        sig.isLod.value = true;
        FocusScope.of(context).unfocus();
        await AuthSevices().SignUp(_email.text, _passwordController.text,
            newvalue.selected.value, _usernameController.text);
        sig.isLod.value = false;
      } catch (e) {
        Get.snackbar('', '',
            titleText: const Text(
              'Failed',
              style: TextStyle(color: Colors.white),
            ),
            messageText: Text(
              e.toString(),
              style: TextStyle(color: Colors.white),
            ),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
            snackStyle: SnackStyle.GROUNDED);
      }
      sig.isLod.value = false;
    }
    sig.isLod.value = false;
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
          onPressed: (){
            Get.back();
          },
        ),
        title: const Text('Register', style: TextStyle(color: Colors.black,fontSize: 23)),
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
                height: 180,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/register.png'),
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
                        "Enter credentials to SignUp",
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
                  absorbing:sig.isLod.value ? true : false,
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    controller: _usernameController,
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
                  absorbing:sig.isLod.value ? true : false,
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    controller: _email,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25)),
                      prefixIcon: const Icon(Icons.email),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: AbsorbPointer(
                  absorbing:sig.isLod.value ? true : false,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      hintText: 'Select Gender',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28)),
                    ),
                    value: newvalue.selected.value.isNotEmpty
                        ? newvalue.selected.value
                        : null,
                    items: const [
                      DropdownMenuItem(
                        child: Text('Male'),
                        value: 'Male',
                      ),
                      DropdownMenuItem(
                        child: Text('Female'),
                        value: 'Female',
                      ),
                      DropdownMenuItem(
                        child: Text('Rather not say'),
                        value: 'Rather not say',
                      ),
                    ],
                    onChanged: (valuw) {
                      newvalue.selected.value = valuw.toString();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: AbsorbPointer(
                    absorbing:sig.isLod.value ? true : false,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: obscure.Isobscure.value,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            obscure.Isobscure.toggle();
                          },
                          icon: Icon(obscure.Isobscure.value
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        labelText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25)),
                        prefixIcon: const Icon(Icons.lock),
                      ),
                    ),
                  )),
              const SizedBox(height: 20),
              Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: AbsorbPointer(
                    absorbing:sig.isLod.value ? true : false,
                    child: TextField(
                      controller: _confirm,
                      obscureText: obscure.Isobscure.value,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            obscure.Isobscure.toggle();
                          },
                          icon: Icon(obscure.Isobscure.value
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        labelText: 'Confirm password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25)),
                        prefixIcon: const Icon(Icons.lock),
                      ),
                    ),
                  )),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: GestureDetector(
                  onTap: signUpProcess,
                  child: sig.isLod.value
                      ? CircularProgressIndicator(
                          color: Colors.green,
                        )
                      : Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(21)),
                          padding: const EdgeInsets.all(9),
                          child: const Center(
                            child: Text(
                              "Register",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 19),
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
