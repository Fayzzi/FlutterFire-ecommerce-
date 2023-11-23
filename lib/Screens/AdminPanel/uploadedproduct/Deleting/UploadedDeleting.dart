import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Deletedata {
  User? user = FirebaseAuth.instance.currentUser;
  Future DeleteCloths(String Id, String category, String subCategory) async {
    try {
      //user
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.uid)
          .collection('Products')
          .doc(Id)
          .delete();
      //AllProducts
      await FirebaseFirestore.instance
          .collection('Products')
          .doc('All products')
          .collection('All Products')
          .doc(Id)
          .delete();
      //Collection All Products
      await FirebaseFirestore.instance
          .collection('Products')
          .doc(category)
          .collection('All Products')
          .doc(Id)
          .delete();
      //sub category
      await FirebaseFirestore.instance
          .collection('Products')
          .doc(category)
          .collection(subCategory)
          .doc(Id)
          .delete();
      //all user viewed,carted and fav
      QuerySnapshot allUser =
          await FirebaseFirestore.instance.collection('Users').get();
      List<DocumentSnapshot> alldocs = allUser.docs;
      for (DocumentSnapshot doc in alldocs) {
        String userId = doc.id;
        //viewed
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('Viewed')
            .doc(Id)
            .delete();
        //carted
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('Carted')
            .doc(Id)
            .delete();
        //Favorite
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('Fav')
            .doc(Id)
            .delete();
      }
    } catch (e) {}
  }

  Future DeleteSimple(String Id, String category) async {
    try {
      //user
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.uid)
          .collection('Products')
          .doc(Id)
          .delete();
      //AllProducts
      await FirebaseFirestore.instance
          .collection('Products')
          .doc('All products')
          .collection('All Products')
          .doc(Id)
          .delete();
      //Collection All Products
      await FirebaseFirestore.instance
          .collection('Products')
          .doc(category)
          .collection('All Products')
          .doc(Id)
          .delete();

      //all user viewed,carted and fav
      QuerySnapshot allUser =
          await FirebaseFirestore.instance.collection('Users').get();
      List<DocumentSnapshot> alldocs = allUser.docs;
      for (DocumentSnapshot doc in alldocs) {
        String userId = doc.id;
        //viewed
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('Viewed')
            .doc(Id)
            .delete();
        //carted
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('Carted')
            .doc(Id)
            .delete();
        //Favorite
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('Fav')
            .doc(Id)
            .delete();
      }
    } catch (e) {}
  }
}
