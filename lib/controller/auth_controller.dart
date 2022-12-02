import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:todo_app/pages/home_page.dart';
import 'package:todo_app/pages/login_page.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rxn<User> _firebaseUser = Rxn<User>();

  String? get user => _firebaseUser.value?.email;

  @override
  void onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  void createUser(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.to(() => LoginPage());
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error creating account', e.message.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.to(() => const HomePage());
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error logging in', e.message.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void signOut() async {
    try {
      await _auth.signOut();
      Get.back();
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error signing out', e.message.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
