import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:note_app/providers/notification_service.dart';
//import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInProvider extends ChangeNotifier {
  SignInProvider() {
    print(_masterPassword);
    checkSignIn();
//    checkGuestUser();
//    initPackageInfo();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googlSignIn = new GoogleSignIn();

  final String defaultUserImageUrl =
      'https://www.oxfordglobal.co.uk/nextgen-omics-series-us/wp-content/uploads/sites/16/2020/03/Jianming-Xu-e5cb47b9ddeec15f595e7000717da3fe.png';
  final Firestore firestore = Firestore.instance;

  bool _guestUser = false;
  bool get guestUser => _guestUser;

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _hasError = false;
  bool get hasError => _hasError;

  String _errorCode;
  String get errorCode => _errorCode;

  String _name;
  String get name => _name;

  String _uid;
  String get uid => _uid;

  String _email;
  String get email => _email;

  String _imageUrl;
  String get imageUrl => _imageUrl;

  String _masterPassword;
  String get masterPassword => _masterPassword;

  String _signInProvider;
  String get signInProvider => _signInProvider;

  String timestamp;

  String _appVersion = '0.0';
  String get appVersion => _appVersion;

  String _packageName = '';
  String get packageName => _packageName;

//  void initPackageInfo() async {
////    PackageInfo packageInfo = await PackageInfo.fromPlatform();
//    _appVersion = packageInfo.version;
//    _packageName = packageInfo.packageName;
//    notifyListeners();
//  }

  Future<bool> validatePassword(String password) async {
    try {
      final firebaseUser = await _firebaseAuth.currentUser();

      final authCredentials = EmailAuthProvider.getCredential(
          email: firebaseUser.email, password: password);
      final user =
          (await firebaseUser.reauthenticateWithCredential(authCredentials))
              .user;
      return user != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> updatePassword(String password) async {
    var firebaseUser = await _firebaseAuth.currentUser();
    firebaseUser.updatePassword(password);
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googlSignIn.signIn();
    if (googleUser != null) {
      try {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        FirebaseUser userDetails =
            (await _firebaseAuth.signInWithCredential(credential)).user;

        this._name = userDetails.displayName;
        this._email = userDetails.email;
        this._imageUrl = userDetails.photoUrl;
        this._uid = userDetails.uid;
//        NotificationService.channel_id=this._uid;
//        this._masterPassword=null;
        this._signInProvider = 'google';

        _hasError = false;
        notifyListeners();
      } catch (e) {
        _hasError = true;
        _errorCode = e.toString();
        notifyListeners();
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }

  Future signUpwithEmailPassword(userName, userEmail, userPassword) async {
    try {
      final FirebaseUser user =
          (await _firebaseAuth.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      ))
              .user;
      assert(user != null);
      assert(await user.getIdToken() != null);
      this._name = userName;
      this._uid = user.uid;
//      NotificationService.channel_id=this._uid;
      this._imageUrl = defaultUserImageUrl;
      this._email = user.email;
      this._signInProvider = 'email';

      _hasError = false;
      notifyListeners();
    } catch (e) {
      _hasError = true;
      _errorCode = e.code;
      notifyListeners();
    }
  }

  Future signInwithEmailPassword(userEmail, userPassword) async {
    try {
      final FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: userEmail, password: userPassword))
          .user;
      assert(user != null);
      assert(await user.getIdToken() != null);
      final FirebaseUser currentUser = await _firebaseAuth.currentUser();
      this._uid = currentUser.uid;
//      NotificationService.channel_id=this._uid;
      this._signInProvider = 'email';

      _hasError = false;
      notifyListeners();
    } catch (e) {
      _hasError = true;
      _errorCode = e.code;
      notifyListeners();
    }
  }

  Future<bool> checkUserExists() async {
    DocumentSnapshot snap =
        await firestore.collection('users').document(_uid).get();
    if (snap.exists) {
      print('User Exists');
      return true;
    } else {
      print('new user');
      return false;
    }
  }

  Future saveToFirebase() async {
    final DocumentReference ref =
        Firestore.instance.collection('users').document(_uid);
    var userData = {
      'name': _name,
      'email': _email,
      'uid': _uid,
      'image url': _imageUrl,
      'timestamp': timestamp,
      'masterPassword': _masterPassword,
//      'loved items': [],
//      'bookmarked items': []
    };
    await ref.setData(userData);
  }

  Future getTimestamp() async {
    DateTime now = DateTime.now();
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
    timestamp = _timestamp;
  }

  Future saveDataToSP() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    await sp.setString('name', _name);
    await sp.setString('email', _email);
    await sp.setString('image_url', _imageUrl);
    await sp.setString('uid', _uid);
    await sp.setString('masterPassword', _masterPassword ?? "");
    await sp.setString('sign_in_provider', _signInProvider);
  }

  Future getDataFromSp() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _name = sp.getString('name');
    _email = sp.getString('email');
    _imageUrl = sp.getString('image_url');
    _uid = sp.getString('uid');
//    NotificationService.channel_id=this._uid;
    _masterPassword = sp.getString('masterPassword');
    _signInProvider = sp.getString('sign_in_provider');
    notifyListeners();
  }

  Future getUserDatafromFirebase(uid) async {
    await Firestore.instance
        .collection('users')
        .document(uid)
        .get()
        .then((DocumentSnapshot snap) {
      this._uid = snap.data['uid'];
//      NotificationService.channel_id=this._uid;
      this._name = snap.data['name'];
      this._email = snap.data['email'];
      this._imageUrl = snap.data['image url'];
      this._masterPassword = snap.data['masterPassword'];
      print(snap.data['name']);
      print(snap.data['email']);
    });
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('signed_in', true);
    _isSignedIn = true;
    notifyListeners();
  }

  void checkSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _isSignedIn = sp.getBool('signed_in') ?? false;
    notifyListeners();
  }

  Future userSignout() async {
//    if (_signInProvider == 'apple') {
//      await _firebaseAuth.signOut();
//    } else if (_signInProvider == 'facebook') {
//      await _firebaseAuth.signOut();
//      await _fbLogin.logOut();
//    } else
    if (_signInProvider == 'email') {
      await _firebaseAuth.signOut();
    } else {
      await _firebaseAuth.signOut();
      await _googlSignIn.signOut();
    }
    notifyListeners();
  }

  Future afterUserSignOut() async {
    await userSignout().then((value) async {
      await clearAllData().then((value) async {
        _isSignedIn = false;
        _guestUser = false;
        notifyListeners();
      });

      notifyListeners();
    });
  }

  Future setGuestUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool('guest_user', true);
    _guestUser = true;
    notifyListeners();
  }

  void checkGuestUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _guestUser = sp.getBool('guest_user') ?? false;
    notifyListeners();
  }

  Future clearAllData() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool('signed_in', false);
    this._uid = null;
    this._name = null;
    this._masterPassword = null;
    this._email = null;
    this._isSignedIn = false;
    this._imageUrl = null;
    await sp.clear();
    notifyListeners();
  }

  Future guestSignout() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool('guest_user', false);
    _guestUser = false;
    notifyListeners();
  }

  Future updateUserProfile(String newName, String newImageUrl) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    Firestore.instance
        .collection('users')
        .document(_uid)
        .updateData({'name': newName, 'image url': newImageUrl});

    sp.setString('name', newName);
    sp.setString('image_url', newImageUrl);
    _name = newName;
    _imageUrl = newImageUrl;

    notifyListeners();
  }

  Future updateUserMasterPassword(String masterPassword) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    Firestore.instance
        .collection('users')
        .document(_uid)
        .updateData({'masterPassword': masterPassword});

    sp.setString('masterPassword', masterPassword);

    _masterPassword = masterPassword;

    notifyListeners();
  }

//  Future<int> getTotalUsersCount() async {
//    final String fieldName = 'count';
//    final DocumentReference ref =
//        firestore.collection('item_count').document('users_count');
//    DocumentSnapshot snap = await ref.get();
//    if (snap.exists == true) {
//      int itemCount = snap[fieldName] ?? 0;
//      return itemCount;
//    } else {
//      await ref.setData({fieldName: 0});
//      return 0;
//    }
//  }
//
//  Future increaseUserCount() async {
//    await getTotalUsersCount().then((int documentCount) async {
//      await firestore
//          .collection('item_count')
//          .document('users_count')
//          .updateData({'count': documentCount + 1});
//    });
//  }

}
