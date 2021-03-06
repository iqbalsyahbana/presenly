import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class AddPegawaiController extends GetxController {
  TextEditingController nipC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addPegawai() async {
    if (nipC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      try {
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
                email: emailC.text, password: "password");

        if (userCredential.user != null) {
          String uid = userCredential.user!.uid;

          await firestore.collection("pegawai").doc(uid).set({
            "nip": nipC.text,
            "name": nameC.text,
            "email": emailC.text,
            "uid": uid,
            "createdAt": DateTime.now().toIso8601String(),
          });

          await userCredential.user!.sendEmailVerification();
        }
        print(userCredential);
        Get.snackbar("Success", "Pegawai Berhasil Ditambahkan");
        Get.offAllNamed(Routes.HOME);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          Get.snackbar("Terjadi Kesalahan", "email sudah ada");
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Terjadi Kesalahan", "password yang dimasukkan salah");
        }
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat menambah pegawai");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "NIP, Nama, dan Email harus diisi");
    }
  }
}
