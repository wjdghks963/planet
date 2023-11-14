
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:planet/bindings/CustomBindings.dart';
import 'package:planet/screen/root.dart';
import 'package:planet/utils/OAuth/social_login.dart';
import 'package:planet/utils/OAuth/token_storage.dart';

void main() async {
  await initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.remove();

  bool loggedIn = await TokenStorage().hasToken();


  runApp( MyApp(loggedIn:loggedIn));
}

class MyApp extends StatelessWidget {
  final bool loggedIn;


  const MyApp({Key? key, required this.loggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: CustomBindings(),
      title: 'Planet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: loggedIn ? const RootScreen() : const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      backgroundColor: const Color(0xFFFFDC27),
                      minimumSize: const Size(double.infinity, 0),
                    ),
                    child: const Text("카카오 로그인",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(
                    height: 10,
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
                      minimumSize: const Size(double.infinity, 0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/google.svg'),
                        const SizedBox(width: 10,),
                        const Text("Continue with Google",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {},


                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 0),
                    ),
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/apple.svg'),
                        const SizedBox(width: 10,),
                        const   Text("Continue with Apple",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600))
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    )));
  }
}
