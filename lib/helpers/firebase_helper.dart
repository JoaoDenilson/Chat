import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseHelper {
  static final FirebaseHelper _instance = FirebaseHelper.internal();
  User currentUser;

  factory FirebaseHelper() => _instance;

  FirebaseHelper.internal() {
    //Escutar qual quer alteração do cliente
    FirebaseAuth.instance.authStateChanges().listen((user) {
      this.currentUser = user;
    });
  }

  Stream<QuerySnapshot> snapshots() {
    return FirebaseFirestore.instance
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future<User> getUser() async {
    if (currentUser != null) return currentUser;
    //Login com o google
    final GoogleSignIn googleSingin = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSingin.signIn();

    //Login no firabase
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    //Credenciais
    final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);
    //Fazer login no Firebase
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return userCredential.user;
  }

  Future<void> sendMessage(String text) async {
    User user = await getUser();

    FirebaseFirestore.instance.collection("messages").add({
      "uid": user.uid,
      "senderName": user.displayName,
      "senderPhotoUrl": user.photoURL,
      "text": text,
      "time": Timestamp.now()
    });
  }

  Future<void> sendImage(File file) async {
    User user = await getUser();

    StorageUploadTask task = FirebaseStorage.instance
        .ref()
        .child('imgs')
        .child(DateTime.now().millisecondsSinceEpoch.toString())
        .putFile(file);
    StorageTaskSnapshot taskSnapshot = await task.onComplete;
    String url = await taskSnapshot.ref.getDownloadURL();

    FirebaseFirestore.instance.collection("messages").add({
      "uid": user.uid,
      "senderName": user.displayName,
      "senderPhotoUrl": user.photoURL,
      "imgUrl": url,
      "time": Timestamp.now()
    });
  }
}
