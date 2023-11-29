import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:planet/bindings/custom_bindings.dart';
import 'package:planet/screen/root.dart';
import 'package:planet/utils/OAuth/social_login.dart';
import 'package:planet/utils/OAuth/token_storage.dart';

void main() async {
  await initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  bool loggedIn = await TokenStorage().hasToken(TokenType.acc);
  FlutterNativeSplash.remove();

  await dotenv.load(fileName: ".env");

  KakaoSdk.init(
    nativeAppKey: '294bcf315044eea3b2a19efedab9dfef',
    javaScriptAppKey: 'ff95a3cddcfd4f6243533c2d8f71e1a2',
  );
  MobileAds.instance.initialize();

  runApp(MyApp(loggedIn: loggedIn));
  await Permission.appTrackingTransparency.request();
}

class MyApp extends StatelessWidget {
  final bool loggedIn;

  const MyApp({Key? key, required this.loggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: CustomBindings(),
      title: 'Planet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: loggedIn ? const RootScreen() : const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
          child: Scaffold(
              body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            children: <Widget>[
              Image.asset(
                'assets/images/logo.png',
                width: double.infinity,
                height: 500,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 80,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        SocialLogin("kakao").run();
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                        backgroundColor: const Color(0xFFFEE501),
                        minimumSize:
                            const Size(double.infinity, 50), // 높이를 50으로 설정
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/kakao-talk.svg',
                            width: 25,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text("Kakao로 계속하기",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextButton(
                      onPressed: () {
                        SocialLogin("google").run();
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                        backgroundColor: Colors.white,
                        minimumSize:
                            const Size(double.infinity, 50), // 높이를 50으로 설정
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/google.svg',
                              width: 25),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text("Google로 계속하기",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Platform.isAndroid
                        ? const SizedBox()
                        : TextButton(
                            onPressed: () {
                              SocialLogin("apple").run();
                            },
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              backgroundColor: Colors.black,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/icons/apple.svg',
                                    width: 25),
                                const SizedBox(width: 10),
                                const Text(
                                  "Apple로 계속하기",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
      ))),
    );
  }
}
