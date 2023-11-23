import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project_ecommerce/Screens/Categories/Footwear/AllTab.dart';
import 'package:mad_project_ecommerce/Screens/Categories/Footwear/Gents.dart';
import 'package:mad_project_ecommerce/Screens/Categories/Footwear/Ladies.dart';
import 'package:mad_project_ecommerce/Screens/Categories/Footwear/Children.dart';

class TabBarFootwear extends StatefulWidget {
  const TabBarFootwear({Key? key}) : super(key: key);

  @override
  _TabBarFootwearState createState() => _TabBarFootwearState();
}

class _TabBarFootwearState extends State<TabBarFootwear>
    with SingleTickerProviderStateMixin {
  late TabController tabs;

  @override
  void initState() {
    super.initState();
    tabs = TabController(initialIndex: 0, length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          title: const Text(
            'Footwear',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          bottom: TabBar(
            controller: tabs,
            labelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: const [
              Tab(
                text: 'All Footwear',
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
            ],
          ),
        ),
        body: TabBarView(
          controller: tabs,
          children: const [
            AllFootwear(),
            GentsFootwear(),
            LadiesFootwear(),
            Children(),
          ],
        ),
      ),
      onWillPop: () async {
        if (tabs.index != 0) {
          tabs.animateTo(0);
          return false;
        }
        return true;
      },
    );
  }

  @override
  void dispose() {
    tabs.dispose();
    super.dispose();
  }
}
