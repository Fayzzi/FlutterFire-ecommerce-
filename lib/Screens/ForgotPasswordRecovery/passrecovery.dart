import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project_ecommerce/AuthServics/AuthServics.dart';

class PasswordRecovery extends StatefulWidget {
  const PasswordRecovery({super.key});

  @override
  State<PasswordRecovery> createState() => _PasswordRecoveryState();
}

class _PasswordRecoveryState extends State<PasswordRecovery> {
  TextEditingController _pass = TextEditingController();

  Future check() async {
    if (_pass.text == '') {
      Get.snackbar('', '',
          titleText: const Text(
            'Failed',
            style: TextStyle(color: Colors.white),
          ),
          messageText: const Text(
            'Email is required',
            style: TextStyle(color: Colors.white),
          ),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          snackStyle: SnackStyle.GROUNDED);
    } else {
      await AuthSevices().Passwordrecovery(_pass.text);
    }
  }

  @override
  void dispose() {
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Password Recovery',
          style: TextStyle(color: Colors.black, fontSize: 23),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: TextField(
              controller: _pass,
              decoration: InputDecoration(
                  hintText: "Write your Recovery Email",
                  helperText: "This email will be used to recover your account",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(23),
                      borderSide: const BorderSide(color: Colors.black))),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: check,
            child: Container(
              margin: const EdgeInsets.only(left: 25, right: 25),
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(21)),
              child: const Center(
                child: Text(
                  "Send Link",
                  style: TextStyle(color: Colors.white, fontSize: 19),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
