import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

enum ThirdPlatform {
  wechat,
  facebook,
  apple,
  google,
}

///Facebook、Google、Apple登录工具类
class ThirdPlatformLogin {
  static late final ThirdPlatformLogin _instance =
      ThirdPlatformLogin._internal();
  factory ThirdPlatformLogin() => _instance;

  ThirdPlatformLogin._internal();

  ///Google登录[国产手机可能遇到缺少谷歌服务框架的情况，导致授权失败]
  ///https://pub.dev/packages/google_sign_in
  Future<String?> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: <String>[
        'profile', // View your basic profile info
        'email', //	View your email address
        'openid', // Authenticate using OpenID Connect
        'https://www.googleapis.com/auth/contacts.readonly', //	查看并下载您的联系人
      ],
    );
    try {
      GoogleSignInAccount? account = await _googleSignIn.signIn();
      debugPrint(
          'Google User Data: displayName: ${account?.displayName} email: ${account?.email} '
          'id: ${account?.id} serverAuthCode: ${account?.serverAuthCode}');
      GoogleSignInAuthentication? authentication =
          await account?.authentication;
      debugPrint(
          'Google login token: idToken: ${authentication?.idToken} accessToken: ${authentication?.accessToken}');
      return authentication?.idToken;
    } catch (error) {
      if (error is PlatformException) {
        ///缺少谷歌服务框架
        debugPrint(
            'ThirdPlatformLogin.signInWithGoogle ${error.message} ${error.code} ${error.details}');
      }
      return '';
    }
  }

  ///苹果登录
  ///Sign in with Apple only supported from iOS 13 onwards.
  ///https://pub.dev/packages/sign_in_with_apple
  Future<String?> signIdWithApple() async {
    try {
      AuthorizationCredentialAppleID credential =
          await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ]);
      debugPrint(
          '_LoginPageState._loginByAppleId userIdentifier: ${credential.userIdentifier}'
          ' identityToken: ${credential.identityToken}');
      return credential.identityToken;
    } catch (error) {
      if (error is PlatformException) {
        SignInWithAppleException exception =
            SignInWithAppleException.fromPlatformException(error);
        debugPrint(
            'ThirdPlatformLogin.signIdWithApple ${exception.toString()}');
      }
      return '';
    }
  }

  ///Facebook登录
  ///https://pub.dev/packages/flutter_login_facebook
  Future<String?> signIdWithFaceBook() async {
    final FacebookLogin login = FacebookLogin();
    final FacebookLoginResult result = await login.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    switch (result.status) {
      case FacebookLoginStatus.success:
        final FacebookAccessToken? accessToken = result.accessToken;
        debugPrint('Facebook login ${accessToken?.token}');
        return accessToken?.token ?? '';
      case FacebookLoginStatus.cancel:
      case FacebookLoginStatus.error:
        return '';
    }
  }
}
