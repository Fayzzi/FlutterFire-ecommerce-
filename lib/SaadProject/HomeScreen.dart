import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Icon(
            Icons.logout,
            color: Colors.black,
          )
        ],
        title: Text(
          "Home",
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        height: 0.5,
                        color: Colors.green,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 3, right: 3),
                      child: Text(
                        "Categories",
                        style: TextStyle(color: Colors.green, fontSize: 18),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        height: 0.5,
                        color: Colors.green,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SofaCategory()));
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(21)),
                          elevation: 1,
                          child: SizedBox(
                            height: 200,
                            width: 200,
                            child: Column(
                              children: [
                                Container(
                                  height: 180,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(21),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          "https://sofaboys.ie/cdn/shop/products/PHOTO-2023-03-07-20-06-28.jpg?v=1678223185"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Sofas",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(21)),
                        elevation: 1,
                        child: SizedBox(
                          height: 200,
                          width: 200,
                          child: Column(
                            children: [
                              Container(
                                height: 180,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(21),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "https://www.laresidenceinteriors.co.uk/cdn/shop/files/BelmontOvalDiningTablewithKingsley_BurfordChairsAngleLifestyle_7574d123-b65d-4ae2-ade6-30650155db7b.jpg?v=1693650574"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                "Dinning Table",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(21)),
                        elevation: 1,
                        child: SizedBox(
                          height: 200,
                          width: 200,
                          child: Column(
                            children: [
                              Container(
                                height: 180,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(21),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "https://i0.wp.com/woodwoon.com/wp-content/uploads/2023/02/BK0018-bed-modern-bed-design-in-pakistan-Woodwoon.webp?fit=1536%2C1024&ssl=1"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                "Beds",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        height: 0.5,
                        color: Colors.green,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 3, right: 3),
                      child: Text(
                        "Newly Arrived",
                        style: TextStyle(color: Colors.green, fontSize: 18),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        height: 0.5,
                        color: Colors.green,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 1,
              ),
              GridView(
                shrinkWrap: true,
                primary: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(21)),
                    elevation: 1,
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: Column(
                        children: [
                          Container(
                            height: 190,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(21),
                              image: DecorationImage(
                                image: NetworkImage(
                                    "https://www.abakusdirect.co.uk/pub/media/catalog/product/v/e/verona_cornersofa_2022_1500x1021.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            "Verona Corner Sofa",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(21)),
                    elevation: 1,
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: Column(
                        children: [
                          Container(
                            height: 190,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(21),
                              image: DecorationImage(
                                image: NetworkImage(
                                    "https://premiahome.pk/cdn/shop/products/WhatsAppImage2022-11-16at12.20.12PM.jpg?v=1668583283"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            "Black Sofa Cover",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(21)),
                    elevation: 1,
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: Column(
                        children: [
                          Container(
                            height: 190,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(21),
                              image: DecorationImage(
                                image: NetworkImage(
                                    "https://www.elitestore.pk/wp-content/uploads/2023/04/5-5.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            "Quilted Sofa Cover",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(21)),
                    elevation: 1,
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: Column(
                        children: [
                          Container(
                            height: 190,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(21),
                              image: DecorationImage(
                                image: NetworkImage(
                                    "https://furniturehub.pk/wp-content/uploads/2020/11/FH-1541-DRAWING-ROOM-SOFA.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            "Black and Gold",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(21)),
                    elevation: 1,
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: Column(
                        children: [
                          Container(
                            height: 190,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(21),
                              image: DecorationImage(
                                image: NetworkImage(
                                    "https://pffurniture.co.uk/wp-content/uploads/2016/10/VER220812-1.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            "Verona Corner Sofa",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 1),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SofaCategory extends StatelessWidget {
  const SofaCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Sofas",
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: GridView(
        shrinkWrap: true,
        primary: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
            elevation: 1,
            child: SizedBox(
              height: 200,
              width: 200,
              child: Column(
                children: [
                  Container(
                    height: 190,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(21),
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://www.abakusdirect.co.uk/pub/media/catalog/product/v/e/verona_cornersofa_2022_1500x1021.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    "Verona Corner Sofa",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
            elevation: 1,
            child: SizedBox(
              height: 200,
              width: 200,
              child: Column(
                children: [
                  Container(
                    height: 190,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(21),
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://premiahome.pk/cdn/shop/products/WhatsAppImage2022-11-16at12.20.12PM.jpg?v=1668583283"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    "Black Sofa Cover",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
            elevation: 1,
            child: SizedBox(
              height: 200,
              width: 200,
              child: Column(
                children: [
                  Container(
                    height: 190,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(21),
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://www.elitestore.pk/wp-content/uploads/2023/04/5-5.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    "Quilted Sofa Cover",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
            elevation: 1,
            child: SizedBox(
              height: 200,
              width: 200,
              child: Column(
                children: [
                  Container(
                    height: 190,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(21),
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://furniturehub.pk/wp-content/uploads/2020/11/FH-1541-DRAWING-ROOM-SOFA.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    "Black and Gold",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
            elevation: 1,
            child: SizedBox(
              height: 200,
              width: 200,
              child: Column(
                children: [
                  Container(
                    height: 190,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(21),
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://pffurniture.co.uk/wp-content/uploads/2016/10/VER220812-1.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    "Verona Corner Sofa",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 1),
      ),
    );
  }
}
