import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mad_project_ecommerce/Screens/Add%20product/Addproduct.dart';
import 'package:mad_project_ecommerce/Screens/AdminPanel/AdminPanel.dart';
import 'package:mad_project_ecommerce/Screens/homepage/Homepage.dart';

class BottomSelector extends GetxController {
  var current = 0.obs;
}

class BottomNavigationBarWidget extends StatefulWidget {
  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget>
    with WidgetsBindingObserver {
  final BottomSelector selector = Get.put(BottomSelector());
  User? user = FirebaseAuth.instance.currentUser;
  final List<Widget> tabs = [
    const Homepage(),
    const AddProduct(),
    const AdminPage(),
  ];
  @override
  void initState() {
    setStatus('Online');
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  void setStatus(String status) {
    FirebaseFirestore.instance.collection("Users").doc(user!.uid).update({
      'Status': status,
      'Last Seen': DateTime.now(),
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (user != null) {
        setStatus('Online');
      }
    } else {
      setStatus('Offline');
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            body: Obx(() => IndexedStack(
                  index: selector.current.value,
                  children: tabs,
                )),
            bottomNavigationBar: Obx(
              () => BottomNavigationBar(
                selectedItemColor: Colors.black,
                showSelectedLabels: true,
               elevation: 1,
                unselectedItemColor: Colors.grey,
                selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700,color: Colors.black),
                showUnselectedLabels: false,

                backgroundColor: Colors.white,
                onTap: (value) {
                  selector.current.value = value;
                },
                currentIndex: selector.current.value,
                items: const [
                  BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.house,size: 20,), label: 'Home'),
                  BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.plus,size: 20,), label: 'Add product'),
                  BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.user,size: 20,),
                      label: 'Admin'),
                ],
              ),
            )),
        onWillPop: () async {
          Get.defaultDialog(
              title: ("Leave app"),
              content: Text("Are you sure you want to leave the app?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("No")),
                TextButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: Text("Yes")),
              ]);
          return false;
        });
  }
}
