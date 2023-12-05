import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDB {
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        return userData;
      }
      return null;
    } catch (e) {
      print('Error fetching user email: $e');
      return null;
    }
  }

  Future? getUserDataByEmail(String email) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      if (userDoc.docs.isNotEmpty) {
        final userData = userDoc.docs.first;
        return userData;
      }
      return null;
    } catch (e) {
      print('Error fetching user email: $e');
      return null;
    }
  }

  Future<bool> isUserNameUnique(String username) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final user = querySnapshot.docs.first;

      print('user is not unique');
      print(user.data());
      return false;
    } else {
      print('username is unique');
      return true;
    }
  }

  Future<bool> deleteUserData(String uid) async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
      print('user deleted');
      return true;
    } catch (e) {
      print('error $e');
      return false;
    }
  }
}
