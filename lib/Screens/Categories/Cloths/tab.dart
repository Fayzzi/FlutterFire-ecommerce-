import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project_ecommerce/Screens/Categories/Cloths/AllCloths.dart';
import 'package:mad_project_ecommerce/Screens/Categories/Cloths/ChildrenCloths.dart';
import 'package:mad_project_ecommerce/Screens/Categories/Cloths/GentsCloths.dart';
import 'package:mad_project_ecommerce/Screens/Categories/Cloths/LadiesCloths.dart';

class ClothsTab extends StatefulWidget {
  const ClothsTab({super.key});

  @override
  State<ClothsTab> createState() => _ClothsTabState();
}

class _ClothsTabState extends State<ClothsTab>
    with SingleTickerProviderStateMixin {
  late TabController clothsTab;
  @override
  void initState() {
    clothsTab = TabController(initialIndex: 0, length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Cloths',
              style: TextStyle(color: Colors.black, fontSize: 22),
            ),
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
            bottom:  TabBar(
              labelColor: Colors.black,indicatorSize: TabBarIndicatorSize.label,
              controller: clothsTab,
                tabs: const [
              Tab(
                text: 'All Clothings',
              ),
              Tab(
                text: 'Gents',
              ),
              Tab(
                text: 'Ladies',
              ),
              Tab(
                text: 'Children',
              ),
            ]),
          ),
          body: TabBarView(
            controller: clothsTab,
            children: const [
              AllCloths(),
              GentsCloths(),
              LadiesCloths(),
              ChildrenCloths(),
            ],
          ),
        ),
        onWillPop: () async {
          if (clothsTab.index != 0) {
            clothsTab.animateTo(0);
            return false;
          }
          return true;
        });
  }
}
