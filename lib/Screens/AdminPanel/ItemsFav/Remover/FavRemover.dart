import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavRemover {
  User? user = FirebaseAuth.instance.currentUser;
  Future remove(String id) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.uid)
        .collection("Fav")
        .doc(id)
        .delete();
  }


}
class CartedItemremiover{
  User? user=FirebaseAuth.instance.currentUser;
  Future CartRemover(String Id) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.uid)
        .collection("Carted")
        .doc(Id)
        .delete();
  }
}
